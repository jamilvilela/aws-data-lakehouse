#!/bin/bash

# AWS Data Lakehouse - Terraform Destroy Script
# Este script carrega as variáveis de ambiente e destrói os recursos

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# Aviso de destruição
echo -e "${RED}⚠️  AVISO: Você está prestes a destruir os recursos do Terraform!${NC}"
echo -e "${RED}Esta ação é irreversível e pode resultar em perda de dados.${NC}"
echo ""
echo "Digite 'sim, destruir' para confirmar:"
read -r confirmation

if [ "$confirmation" != "sim, destruir" ]; then
    echo -e "${YELLOW}Destruição cancelada.${NC}"
    exit 0
fi

# Entrar na pasta infra e executar terraform destroy
cd infra

echo ""
echo -e "${YELLOW}Executando: terraform destroy${NC}"
terraform destroy -var-file="tfvars/terraform.tfvars" -auto-approve

echo ""
echo -e "${GREEN}✓ Recursos destruídos com sucesso!${NC}"
