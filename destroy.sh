#!/bin/bash

# AWS Data Lakehouse - Terraform Quick Destroy Script
# Este script carrega as variáveis de ambiente, assume a role de admin
# e destrói todos os recursos Terraform sem confirmação adicional.

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

# Carrega variáveis do .env (AWS_PROFILE, AWS_REGION, etc.)
source .env
echo -e "${GREEN}✅ Variáveis carregadas com sucesso!${NC}"

echo -e "${YELLOW}🔐 Verificando role atual...${NC}"
CURRENT_ARN=$(aws sts get-caller-identity --query Arn --output text)

if [[ "$CURRENT_ARN" == *":assumed-role/datalake-admins-lf-role/"* ]]; then
    echo -e "${GREEN}✓ Já está rodando como datalake-admins-lf-role, pulando assume-role.${NC}"
else
    echo -e "${YELLOW}🔐 Assumindo role datalake-admins-lf-role...${NC}"

    # Descobre a conta atual
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

    # ARN da role de admin do Lake Formation
    ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/datalake-admins-lf-role"

    # Assume a role e captura as credenciais temporárias
    CREDS=$(aws sts assume-role \
        --role-arn "$ROLE_ARN" \
        --role-session-name "terraform-admin-destroy" \
        --duration-seconds 3600 \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text)

    if [ -z "$CREDS" ]; then
        echo -e "${RED}❌ Erro ao assumir a role ${ROLE_ARN}${NC}"
        exit 1
    fi

    # Separa os campos em variáveis e exporta
    read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "$CREDS"
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN

    # Remove qualquer profile que possa interferir
    unset AWS_PROFILE

    # Garante uma região padrão, se não houver
    if [ -z "$AWS_REGION" ]; then
        export AWS_REGION="us-east-1"
    fi

    echo -e "${GREEN}✓ Role assumida com sucesso:${NC}"
    aws sts get-caller-identity
fi

# Entrar na pasta infra e executar terraform destroy
cd infra

echo -e "${RED}⚠️  Executando: terraform destroy${NC}"
terraform destroy -var-file="tfvars/terraform.tfvars" -auto-approve

echo ""
echo -e "${GREEN}✓ Recursos destruídos!${NC}"