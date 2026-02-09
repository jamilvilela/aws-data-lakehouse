#!/bin/bash

# AWS Data Lakehouse - Terraform Deploy Script

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📂 Carregando variáveis de .env...${NC}"

if [ ! -f .env ]; then
    echo -e "${RED}❌ Erro: Arquivo .env não encontrado!${NC}"
    echo "   Copie .env.example para .env e preencha com seus valores"
    echo "   cp .env.example .env"
    exit 1
fi

source .env
echo -e "${GREEN}✅ Variáveis carregadas com sucesso!${NC}"

export TF_VAR_user_lake_admin_name="$user_lake_admin_name"

echo -e "${YELLOW}🔐 Verificando role atual...${NC}"
CURRENT_ARN=$(aws sts get-caller-identity --query Arn --output text)

if [[ "$CURRENT_ARN" == *":assumed-role/datalake-admins-lf-role/"* ]]; then
  echo -e "${GREEN}✓ Já está rodando como datalake-admins-lf-role, pulando assume-role.${NC}"
else
  echo -e "${YELLOW}🔐 Assumindo role datalake-admins-lf-role...${NC}"

  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

  # ARN da role de admin LF
  ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/datalake-admins-lf-role"

  CREDS=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --role-session-name "terraform-admin" \
    --duration-seconds 3600 \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)

  if [ -z "$CREDS" ]; then
    echo -e "${RED}Erro ao assumir a role ${ROLE_ARN}${NC}"
    exit 1
  fi

  read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "$CREDS"
  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export AWS_SESSION_TOKEN

  # Remove qualquer profile que possa interferir
  unset AWS_PROFILE

  if [ -z "$AWS_REGION" ]; then
    export AWS_REGION="us-east-1"
  fi

  echo -e "${GREEN}✓ Role assumida com sucesso:${NC}"
  aws sts get-caller-identity
fi


# Terraform Plan
echo -e "${YELLOW}Executando: terraform ${NC}"

cd infra
terraform init 

terraform plan -var-file="tfvars/terraform.tfvars"
terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve

# Step Validate
echo ""
echo "✓ PASSO 9: Validar Sucesso"
echo "==========================="
echo ""

# Desliga o 'exit on error' para não matar o script no validate
set +e

echo "Checando grupos IAM..."
GROUPS=$(aws iam list-groups --query 'Groups[?starts_with(GroupName, `datalake`)].GroupName' --output text)
if [ -z "$GROUPS" ]; then
    echo "❌ Grupos não encontrados (ou sem permissão para iam:ListGroups)"
else
    echo "✅ Grupos encontrados:"
    for group in $GROUPS; do
        echo "   - $group"
    done
fi

echo ""
echo "Checando roles LF..."
ROLES=$(aws iam list-roles --query 'Roles[?contains(RoleName, `datalake`) && contains(RoleName, `lf`)].RoleName' --output text)
if [ -z "$ROLES" ]; then
    echo "❌ Roles não encontradas (ou sem permissão para iam:ListRoles)"
else
    echo "✅ Roles encontradas:"
    for role in $ROLES; do
        echo "   - $role"
    done
fi

echo ""
echo "Checando Glue databases..."
DATABASES=$(aws glue get-databases --query 'DatabaseList[].Name' --output text)
if [ -z "$DATABASES" ]; then
    echo "❌ Databases não encontrados (ou sem permissão para glue:GetDatabases)"
else
    echo "✅ Databases encontrados:"
    for db in $DATABASES; do
        echo "   - $db"
    done
fi

# (opcional) religar set -e se tiver mais coisa depois
set -e

echo -e "${GREEN}✓ Deploy concluído!${NC}"
