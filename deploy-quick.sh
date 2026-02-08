#!/bin/bash

# AWS Data Lakehouse - Terraform Quick Deploy Script
# Este script carrega as variáveis de ambiente e executa terraform plan e apply sem confirmação

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


# Entrar na pasta infra e executar terraform
cd infra
terraform plan -var-file="tfvars/terraform.tfvars"
terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve

echo -e "${GREEN}✓ Deploy concluído!${NC}"
