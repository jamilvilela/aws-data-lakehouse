#!/usr/bin/env bash
set -euo pipefail

# AWS Data Lakehouse - Terraform Rollback
#
# Loads environment variables, assumes the Lake Formation admin role,
# and destroys the infrastructure managed by Terraform.

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly INFRA_DIR="${ROOT_DIR}/infra"
readonly TFVAR_FILE="tfvars/terraform.tfvars"
readonly LF_ADMIN_ROLE="datalake-admins-lf-role"

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

info()  { echo -e "${BLUE}${1}${NC}"; }
ok()    { echo -e "${GREEN}${1}${NC}"; }
warn()  { echo -e "${YELLOW}${1}${NC}"; }
fail()  { echo -e "${RED}${1}${NC}"; }

load_environment() {
  if [ ! -f "${ROOT_DIR}/.env" ]; then
    fail "Erro: arquivo .env não encontrado."
    echo "Copie .env.example para .env e preencha com seus valores."
    exit 1
  fi

  source "${ROOT_DIR}/.env"
  ok "Variáveis carregadas com sucesso."
}

assume_admin_role() {
  local current_arn account_id role_arn creds

  warn "Verificando role atual..."
  current_arn=$(aws sts get-caller-identity --query Arn --output text)

  if [[ "${current_arn}" == *"assumed-role/${LF_ADMIN_ROLE}/"* ]]; then
    ok "Role ${LF_ADMIN_ROLE} já está em uso."
    return
  fi

  warn "Assumindo role ${LF_ADMIN_ROLE}..."
  account_id=$(aws sts get-caller-identity --query Account --output text)
  role_arn="arn:aws:iam::${account_id}:role/${LF_ADMIN_ROLE}"

  creds=$(aws sts assume-role \
    --role-arn "${role_arn}" \
    --role-session-name "terraform-rollback" \
    --duration-seconds 3600 \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)

  if [ -z "${creds}" ]; then
    fail "Erro ao assumir a role ${role_arn}"
    exit 1
  fi

  read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "${creds}"
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  unset AWS_PROFILE
  export AWS_REGION="${AWS_REGION:-us-east-1}"

  ok "Role assumida com sucesso:"
  aws sts get-caller-identity
}

terraform_destroy() {
  cd "${INFRA_DIR}"
  warn "Executando: terraform destroy"
  terraform destroy -var-file="${TFVAR_FILE}" -auto-approve
}

main() {
  load_environment
  assume_admin_role
  terraform_destroy
  ok "Recursos destruídos."
}

main "$@"