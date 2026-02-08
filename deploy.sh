#!/bin/bash

# AWS Data Lakehouse - Terraform Deploy Script
# Este script carrega as variáveis de ambiente e executa terraform plan e apply

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se .env existe
if [ ! -f .env ]; then
    echo -e "${RED}Erro: arquivo .env não encontrado!${NC}"
    echo "Crie o arquivo .env com as variáveis necessárias."
    echo "Você pode copiar de .env.example: cp .env.example .env"
    exit 1
fi

# Carregar variáveis do .env
echo -e "${YELLOW}Carregando variáveis do .env...${NC}"
export $(cat .env | grep -v '#' | xargs)

# Verificar se control_account foi carregado
if [ -z "$control_account" ]; then
    echo -e "${RED}Erro: control_account não foi definido no .env${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Variáveis carregadas com sucesso${NC}"
echo "  control_account: $control_account"
echo ""

# Entrar na pasta infra
cd infra

# Terraform Plan
echo -e "${YELLOW}Executando: terraform plan${NC}"
terraform plan -var-file="tfvars/terraform.tfvars"

echo ""
echo -e "${YELLOW}Deseja continuar com o apply? (s/n)${NC}"
read -p "Resposta: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Deploy cancelado."
    exit 0
fi

# Terraform Apply
echo -e "${YELLOW}Executando: terraform apply${NC}"
terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve

echo -e "${GREEN}✓ Deploy concluído com sucesso!${NC}"
