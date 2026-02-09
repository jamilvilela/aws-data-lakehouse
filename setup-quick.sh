#!/bin/bash

# AWS Data Lakehouse - Terraform Quick Deploy Script
# Este script carrega as variáveis de ambiente e executa terraform plan e apply sem confirmação

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Terraform Plan
echo -e "${YELLOW}Executando: terraform ${NC}"


# Entrar na pasta infra e executar terraform
cd infra
terraform init 
terraform plan -var-file="tfvars/terraform.tfvars"
terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve

aws iam add-user-to-group --user-name lake-admin --group-name datalake-admins

echo -e "${GREEN}✓ Deploy concluído!${NC}"
