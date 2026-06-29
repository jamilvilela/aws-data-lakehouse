# ADR-003: Single Unified IAM Role for Analytics Services

**Status:** ✅ Accepted  
**Date:** 2024-01-15  
**Author:** @architect

---

## Context

Multiple AWS services need to access data lake resources:

- AWS Glue (ETL)
- AWS Step Functions (Orchestration)
- Amazon Athena (Query)
- Amazon S3 (Storage)
- Amazon SNS (Notifications)
- Amazon SQS (Queuing)
- Amazon Firehose (Streaming)

These could use separate roles per service (least privilege) or a single unified role.

---

## Decision

Create a **single unified IAM role** (`role-datalake-analytics`) trusted by all required services, with a comprehensive policy covering all data lake actions.

---

## Consequences

### Positive
- ✅ Simpler to manage — one role instead of seven
- ✅ Easier to audit — single permission boundary
- ✅ Services can pass the role to each other (ETL workflows)
- ✅ Lower risk of misconfiguration across multiple roles

### Negative
- ⚠️ Broader permissions than strictly necessary per service
- ⚠️ If compromised, the role provides wide data access
- ⚠️ Harder to attribute actions to specific services via IAM

### Mitigations
- S3 permissions scoped to `lakehouse-*-*` buckets (not all S3)
- Lake Formation provides additional fine-grained access control
- CloudTrail logs show which service assumed the role

---

## Alternatives Considered

### Separate Roles per Service
- **Pros:** Maximum least privilege
- **Cons:** Complex to manage, role-passing between services requires extra configuration, harder to debug

### Role Chaining with PassRole
- **Pros:** Flexible, chain of responsibility
- **Cons:** Complex trust policies, potential for broken chains

---

## Related

- [Feature F-002: IAM Data Lake Role & Policy](../feature.md#f-002-iam-data-lake-role--policy)
- [Architecture: Policy Summary](../architecture.md#policy-summary)
