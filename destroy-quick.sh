#!/bin/bash

# AWS Data Lakehouse - Terraform Quick Destroy Script
# Este script carrega as variáveis de ambiente e destrói os recursos sem confirmação adicional

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

# Entrar na pasta infra e executar terraform destroy
cd infra

echo -e "${RED}⚠️  Executando: terraform destroy${NC}"
terraform destroy -var-file="tfvars/terraform.tfvars" -auto-approve

echo ""
echo -e "${GREEN}✓ Recursos destruídos!${NC}"
