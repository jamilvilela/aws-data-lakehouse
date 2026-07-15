# Prod — AWS Data Lakehouse Production Readiness

> **Production Readiness Checklist & Specifications** for deploying the AWS Data Lakehouse to production environments.

---

## Production Readiness Levels

| Level | Criteria | Status |
|---|---|---|
| 🟢 **Go** | All checks pass | ⬜ |
| 🟡 **Caution** | Non-blocking items open | ✅ |
| 🔴 **Blocked** | Critical items unresolved | ⬜ |

---

## Infrastructure Checklist

### 1. State Management

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 1.1 | Remote backend configured | S3 + DynamoDB | ❌ | Currently using local state (`terraform.tfstate`) |
| 1.2 | State file encryption | SSE-S3 or KMS | ❌ | Not configured |
| 1.3 | State locking | DynamoDB table | ❌ | Not configured |
| 1.4 | State backups | Versioning on state bucket | ❌ | Not configured |
| 1.5 | Access control | IAM policies restricting state access | ❌ | Not configured |

### 2. S3 Buckets

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 2.1 | Public access blocked | All 4 block settings enabled | ✅ | Configured on all 5 buckets |
| 2.2 | Encryption at rest | SSE-S3 or SSE-KMS | ⚠️ | Only workspace has SSE-S3; others lack encryption config |
| 2.3 | Bucket versioning | Enabled for data protection | ❌ | Not configured on any bucket |
| 2.4 | Lifecycle policies | Archive tmp/ after 90 days | ✅ | All buckets have lifecycle for tmp/ prefix |
| 2.5 | Object lock | For compliance/retention | ❌ | Not configured |
| 2.6 | Access logging | S3 access logs to separate bucket | ❌ | Not configured |
| 2.7 | Cross-region replication | For DR | ❌ | Not configured |
| 2.8 | Intelligent-Tiering | For cost optimization | ❌ | Not configured |

### 3. IAM

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 3.1 | Least privilege | Service-specific policies | ✅ | Role trust restricted to required services |
| 3.2 | Password policy | Strong password policy in account | ❌ | Not configured in Terraform |
| 3.3 | Access keys rotation | Max 90 days | ❌ | Not enforced in IaC |
| 3.4 | MFA enforcement | For console users | ❌ | Not configured |
| 3.5 | Permission boundaries | Use for delegated admin | ⚠️ | Partially via LF groups |
| 3.6 | Policy conditions | `aws:SourceArn` / `aws:SourceAccount` | ❌ | Not used |
| 3.7 | Service control policies | Organization-level guardrails | ❌ | Out of Terraform scope |

### 4. Lake Formation

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 4.1 | Admin principals | Restricted to `datalake-admins-lf-role` | ✅ | Single admin role configured |
| 4.2 | Data lake locations | All S3 buckets registered | ✅ | Raw, trusted, business registered |
| 4.3 | Database permissions | DESCRIBE granted per access level | ✅ | 3-tier model working |
| 4.4 | Table permissions | SELECT/INSERT/ALTER/DELETE per role | ✅ | Admin = full, Internal = read, External = limited |
| 4.5 | Tag-based access control | LF tags for fine-grained access | ❌ | Not configured |
| 4.6 | Hybrid access mode | For governed tables | ⚠️ | Internal users have governed table policy |
| 4.7 | Data filtering | Row/cell-level security | ❌ | Not configured |

### 5. Glue Data Catalog

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 5.1 | Database cataloging | All zones cataloged | ✅ | 4 databases created |
| 5.2 | Table schemas | Columns typed and documented | ✅ | All tables have typed columns + comments |
| 5.3 | Partitioning | Date-based partitions | ✅ | All tables partitioned by date |
| 5.4 | Schema versioning | Table versions tracked | ✅ | Glue native |
| 5.5 | Connection to data sources | JDBC/Network connections | ❌ | Not configured |
| 5.6 | Crawlers | For automatic schema discovery | ❌ | Not configured |

### 6. Monitoring & Observability

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 6.1 | CloudTrail | Data plane and management events | ❌ | Not configured in Terraform |
| 6.2 | CloudWatch dashboards | S3, Glue, LF metrics | ❌ | Not configured |
| 6.3 | S3 server access logs | Log delivery bucket | ❌ | Not configured |
| 6.4 | Athena query logging | `cloudtrail` or `awsathena` logs | ❌ | Not configured |
| 6.5 | Budget alerts | Cost anomaly detection | ❌ | Not configured |
| 6.6 | Health events | AWS Health notifications | ❌ | Not configured |

### 7. Security

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 7.1 | Encryption default | AES256 or KMS | ⚠️ | Only workspace bucket has explicit encryption |
| 7.2 | Secrets management | AWS Secrets Manager / Parameter Store | ❌ | Not configured |
| 7.3 | VPC endpoints | S3 Gateway, Glue, LF endpoints | ❌ | Not configured |
| 7.4 | Network ACLs | Subnet-level controls | ❌ | Not configured (serverless) |
| 7.5 | WAF / Shield | For web-facing analytics | ❌ | Not applicable (internal) |
| 7.6 | Config rules | Compliance validation | ❌ | Not configured |

### 8. CI/CD & Automation

| # | Check | Standard | Status | Notes |
|---|---|---|---|---|
| 8.1 | Terraform plan in PR | Automated validation | ❌ | No CI/CD pipeline |
| 8.2 | Terraform apply gated | Manual approval for prod | ❌ | No pipeline |
| 8.3 | Policy as Code | Sentinel / OPA / tfsec | ❌ | Not configured |
| 8.4 | Drift detection | `terraform plan` in scheduled job | ❌ | Not configured |
| 8.5 | Cost estimation | `infracost` or similar | ❌ | Not configured |

---

## Deployment Environments

| Environment | Purpose | Backend | State Isolation |
|---|---|---|---|
| **dev** | Development & testing | `s3://tf-state-dev/` + DynamoDB | ⬜ |
| **staging** | Pre-production validation | `s3://tf-state-staging/` + DynamoDB | ⬜ |
| **prod** | Production workloads | `s3://tf-state-prod/` + DynamoDB | ⬜ |

**Current state:** Single environment, local state. No environment isolation.

---

## Runbook

### Deploy

```bash
# 1. Load environment
source .env

# 2. Assume LF admin role
# (automatic in setup.sh)

# 3. Deploy
cd infra
terraform init
terraform plan -var-file="tfvars/terraform.tfvars"
terraform apply -var-file="tfvars/terraform.tfvars" -auto-approve
```

### Destroy

```bash
source .env
cd infra
terraform destroy -var-file="tfvars/terraform.tfvars" -auto-approve
```

### Validate

```bash
# Check IAM groups
aws iam list-groups --query 'Groups[?starts_with(GroupName, `datalake`)].GroupName'

# Check LF roles
aws iam list-roles --query 'Roles[?contains(RoleName, `datalake`) && contains(RoleName, `lf`)].RoleName'

# Check Glue databases
aws glue get-databases --query 'DatabaseList[].Name'
```

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---|---|---|
| `AccessDeniedException` | Not running as LF admin | Assume `datalake-admins-lf-role` via setup.sh |
| Lake Formation "Resource Not Found" | S3 location not registered | Verify `aws_lakeformation_resource` exists |
| Glue table `ACCESS DENIED` | LF permissions not granted | Check `aws_lakeformation_permissions` grants |
| Terraform state lock | Concurrent operation | Delete stale lock in DynamoDB (not configured yet) |

---

## Production Recommendations (Priority Order)

1. **🔴 Critical:** Configure remote state with S3 + DynamoDB
2. **🔴 Critical:** Enable SSE-S3 encryption on all buckets
3. **🟡 High:** Implement Terraform workspaces for env isolation
4. **🟡 High:** Add S3 bucket versioning
5. **🟡 High:** Set up CI/CD pipeline with `terraform plan` in PRs
6. **🟢 Medium:** Configure CloudTrail and CloudWatch dashboards
7. **🟢 Medium:** Implement LF tag-based access control
8. **🟢 Medium:** Add `aws:SourceArn` conditions to IAM policies
9. **🔵 Low:** Enable S3 access logs
10. **🔵 Low:** Configure budget alerts
