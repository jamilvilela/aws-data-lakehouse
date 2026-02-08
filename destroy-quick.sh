#!/bin/bash

# AWS Data Lakehouse - Terraform Quick Destroy Script
# Este script carrega as variáveis de ambiente e destrói os recursos sem confirmação adicional

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# Entrar na pasta infra e executar terraform destroy
cd infra

echo -e "${RED}⚠️  Executando: terraform destroy${NC}"
terraform destroy -var-file="tfvars/terraform.tfvars" -auto-approve

echo ""
echo -e "${GREEN}✓ Recursos destruídos!${NC}"
