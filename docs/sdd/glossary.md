# Glossary — AWS Data Lakehouse Terminology

> **Domain Glossary** for terms used throughout the SDD documentation and Terraform codebase.

---

## A

| Term | Definition |
|---|---|
| **Athena** | AWS serverless query service that analyzes data in S3 using standard SQL. Uses Glue Catalog for metadata. |
| **ARN** | Amazon Resource Name — unique identifier for AWS resources. |

## B

| Term | Definition |
|---|---|
| **Bronze Layer** | See *Landing Zone* or *Raw Zone*. Medallion architecture terminology for raw, immutable data. |

## C

| Term | Definition |
|---|---|
| **Catalog** | See *Glue Data Catalog*. |
| **Crawler** | AWS Glue feature that automatically discovers schema and populates the Data Catalog. |

## D

| Term | Definition |
|---|---|
| **Data Lake** | Centralized repository storing structured and unstructured data at any scale. |
| **Data Lakehouse** | Modern data architecture combining data lake flexibility with warehouse ACID transactions and governance. |
| **`datalake-admins`** | IAM group with full administrative access to the data lake. |
| **`datalake-admins-lf-role`** | IAM role used as Lake Formation principal for admin-level permissions. |
| **`datalake-policy`** | Main IAM policy attached to the analytics role, covering S3, Glue, Athena, LF, and other services. |
| **`datalake-users-internal`** | IAM group with read-only access to all data lake zones. |
| **`datalake-users-external`** | IAM group with read-only access limited to the business zone. |

| **`db_raw`** | Glue database for raw zone tables (e.g., `etl_execution_control`, `data_quality_metrics`). |
| **`db_trusted`** | Glue database for trusted/refined zone tables. |
| **`db_business`** | Glue database for business-ready zone tables. |

## E

| Term | Definition |
|---|---|
| **ETL** | Extract, Transform, Load — data processing pipeline. |
| **External Table** | Glue table type where data resides in S3 (not managed by Glue). |

## G

| Term | Definition |
|---|---|
| **Glue Data Catalog** | AWS managed metadata repository storing table definitions, schemas, partitions, and locations. |
| **Gold Layer** | See *Business Zone*. Medallion architecture terminology for curated, business-ready data. |

## I

| Term | Definition |
|---|---|
| **IAM** | AWS Identity and Access Management — manages users, groups, roles, and policies. |
| **IaC** | Infrastructure as Code — managing infrastructure through machine-readable definition files (Terraform). |

## L

| Term | Definition |
|---|---|
| **Lake Formation** | AWS service for centralized data governance, permission management, and access control. |
| **Landing Zone** | First stage of data ingestion. Transient storage before data moves to raw zone. |
| **LF** | Abbreviation for *Lake Formation*. |
| **LF Principal** | The entity (IAM role or user) that receives permissions in Lake Formation. |
| **LF-Tag** | Key-value pair used for tag-based access control in Lake Formation. |

## M

| Term | Definition |
|---|---|
| **Medallion Architecture** | Data lake design pattern with Bronze (raw), Silver (cleaned), and Gold (aggregated) layers. |
| **Module** | Terraform self-contained collection of resources (e.g., `module "s3"`, `module "iam"`). |

## P

| Term | Definition |
|---|---|
| **Parquet** | Columnar storage format optimized for analytics. Used for all Glue tables in this project. |
| **Partition** | Division of a table into segments (by date) for query performance and cost optimization. |
| **PassRole** | IAM permission allowing a principal to pass a role to an AWS service. |

## R

| Term | Definition |
|---|---|
| **Raw Zone** | Bronze layer — immutable storage of raw, unprocessed data. |
| **`role-datalake-analytics`** | Main IAM role trusted by multiple AWS services (Glue, Athena, Step Functions, etc.). |

## S

| Term | Definition |
|---|---|
| **S3** | AWS Simple Storage Service — object storage for data lake files. |
| **SDD** | Spec-Driven Development — development methodology where specifications drive implementation. |
| **Silver Layer** | See *Trusted Zone*. Medallion architecture terminology for cleaned, validated data. |
| **Snappy** | Compression algorithm used for Parquet files (balance of speed and ratio). |
| **SSE-S3** | Server-Side Encryption with S3-managed keys (AES256). |
| **`sts:AssumeRole`** | AWS Security Token Service API to obtain temporary credentials for a role. |

## T

| Term | Definition |
|---|---|
| **Terraform** | HashiCorp IaC tool for provisioning cloud resources. |
| **Trusted Zone** | Silver layer — data that has been cleaned, validated, and transformed. |
| **Trust Policy** | IAM role policy specifying which principals can assume the role. |

## W

| Term | Definition |
|---|---|
| **Workspace Zone** | Temporary ETL working area for notebooks, scripts, and intermediate processing. |

## Z

| Term | Definition |
|---|---|
| **Zone** | Logical data storage area within the medallion architecture (landing, raw, trusted, business, workspace). |

---

## Environment Variables

| Variable | Description | Used In |
|---|---|---|
| `AWS_PROFILE` | AWS CLI profile | `setup.sh`, `destroy.sh` |
| `AWS_REGION` | AWS region (default: `us-east-1`) | `setup.sh`, `destroy.sh` |
| `TF_VAR_user_lake_admin_name` | Legacy lake admin variable | `setup.sh` |

## Terraform Conventions

| Convention | Standard |
|---|---|
| Module source | `./modules/<name>` |
| Variable file | `tfvars/terraform.tfvars` |
| Resource naming | `snake_case` |
| IAM policy format | `jsonencode()` |
| Tagging | `merge(var.tags, { Name = ... })` |
