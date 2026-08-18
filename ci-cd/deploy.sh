#!/usr/bin/env bash
set -euo pipefail

# AWS Data Lakehouse - Terraform Deployment
#
# Loads environment variables, assumes the Lake Formation admin role,
# and provisions the infrastructure with Terraform.

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
    fail "Error: .env file not found."
    echo "Copy .env.example to .env and fill in your values."
    exit 1
  fi

  source "${ROOT_DIR}/.env"
  export TF_VAR_user_lake_admin_name="${user_lake_admin_name:-}"
  ok "Variables loaded successfully."
}

assume_admin_role() {
  local current_arn account_id role_arn creds

  warn "Checking current role..."
  current_arn=$(aws sts get-caller-identity --query Arn --output text)

  if [[ "${current_arn}" == *"assumed-role/${LF_ADMIN_ROLE}/"* ]]; then
    ok "Role ${LF_ADMIN_ROLE} is already in use."
    return
  fi

  warn "Assuming role ${LF_ADMIN_ROLE}..."
  account_id=$(aws sts get-caller-identity --query Account --output text)
  role_arn="arn:aws:iam::${account_id}:role/${LF_ADMIN_ROLE}"

  creds=$(aws sts assume-role \
    --role-arn "${role_arn}" \
    --role-session-name "terraform-deploy" \
    --duration-seconds 3600 \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)

  if [ -z "${creds}" ]; then
    fail "Error assuming role ${role_arn}"
    exit 1
  fi

  read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "${creds}"
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  unset AWS_PROFILE
  export AWS_REGION="${AWS_REGION:-us-east-1}"

  ok "Role assumed successfully:"
  aws sts get-caller-identity
}

terraform_apply() {
  cd "${INFRA_DIR}"
  terraform init
  terraform validate
  terraform plan -var-file="${TFVAR_FILE}"
  terraform apply -var-file="${TFVAR_FILE}" -auto-approve
}

validate_deployment() {
  local groups roles databases tables

  echo ""
  echo "Post-deploy validation"
  echo "======================"
  set +e

  groups=$(aws iam list-groups --query 'Groups[?starts_with(GroupName, `datalake`)].GroupName' --output text)
  if [ -z "${groups}" ]; then
    fail "IAM groups not found."
  else
    ok "IAM groups:"
    for group in ${groups}; do
      echo "  - ${group}"
    done
  fi

  roles=$(aws iam list-roles --query 'Roles[?contains(RoleName, `datalake`) && contains(RoleName, `lf`)].RoleName' --output text)
  if [ -z "${roles}" ]; then
    fail "LF roles not found."
  else
    ok "LF roles:"
    for role in ${roles}; do
      echo "  - ${role}"
    done
  fi

  databases=$(aws glue get-databases --query 'DatabaseList[].Name' --output text)
  if [ -z "${databases}" ]; then
    fail "Glue databases not found."
  else
    ok "Glue databases:"
    for db in ${databases}; do
      echo "  - ${db}"
    done
  fi

  tables=$(aws glue get-tables --database-name db_raw --query 'TableList[].Name' --output text)
  if [ -z "${tables}" ]; then
    fail "Tables in db_raw not found."
  else
    ok "Tables in db_raw:"
    for table in ${tables}; do
      echo "  - ${table}"
    done
  fi

  set -e
}

main() {
  load_environment
  assume_admin_role
  terraform_apply
  validate_deployment
  ok "Deploy completed."
}

main "$@"