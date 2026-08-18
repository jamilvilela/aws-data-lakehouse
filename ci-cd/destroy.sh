#!/usr/bin/env bash
set -euo pipefail

# AWS Data Lakehouse - Terraform Destroy
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
    fail "Error: .env file not found."
    echo "Copy .env.example to .env and fill in your values."
    exit 1
  fi

  source "${ROOT_DIR}/.env"
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
    --role-session-name "terraform-destroy" \
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

terraform_destroy() {
  cd "${INFRA_DIR}"
  warn "Running: terraform destroy"
  terraform destroy -var-file="${TFVAR_FILE}" -auto-approve
}

confirm_destroy() {
  local confirmation
  fail "⚠️  WARNING: This action will destroy ALL infrastructure (full teardown)."
  fail "This operation is irreversible. Type the exact word to confirm."
  read -r -p "Type 'destroy_all' to confirm: " confirmation
  if [ "${confirmation}" != "destroy_all" ]; then
    fail "Invalid confirmation. Destroy cancelled."
    exit 1
  fi
  ok "Confirmation received. Proceeding with destroy..."
}

main() {
  load_environment
  assume_admin_role
  confirm_destroy
  terraform_destroy
  ok "Resources destroyed."
}

main "$@"