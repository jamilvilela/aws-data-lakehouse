# ADR-002: Separate S3 Buckets per Medallion Zone

**Status:** ✅ Accepted  
**Date:** 2024-01-15  
**Author:** @architect

---

## Context

The data lakehouse follows the medallion architecture with distinct data zones:

- **Landing** — Initial data ingestion
- **Raw** — Immutable raw data (bronze)
- **Trusted** — Cleaned/transformed data (silver)
- **Business** — Curated enterprise data (gold)
- **Workspace** — Temporary ETL working area

Each zone has different security, lifecycle, and access requirements. The question is whether to use separate S3 buckets or a single bucket with prefixes.

---

## Decision

Use **separate S3 buckets** for each zone, with unique permissions and configurations per bucket.

| Zone | Bucket Name | Access Control |
|---|---|---|
| Landing | `lakehouse-landing-{account_id}` | Sources + ETL |
| Raw | `lakehouse-raw-{account_id}` | ETL only |
| Trusted | `lakehouse-trusted-{account_id}` | ETL + Internal |
| Business | `lakehouse-business-{account_id}` | All consumers |
| Workspace | `lakehouse-workspace-{account_id}` | ETL only |

---

## Consequences

### Positive
- ✅ Independent lifecycle policies per zone
- ✅ Independent encryption settings
- ✅ Clear IAM policy scoping (`Resource: arn:aws:s3:::lakehouse-raw-*`)
- ✅ Lake Formation resource registration works cleanly per bucket
- ✅ Easy to add/remove zones without affecting others
- ✅ Cost tracking per zone

### Negative
- ⚠️ 5 buckets to manage instead of 1
- ⚠️ Slightly higher operational overhead
- ⚠️ Cross-bucket operations need `s3:ListBucket` on all relevant buckets

---

## Alternatives Considered

### Single Bucket with Prefixes
- **Pros:** Single bucket management, simpler IAM
- **Cons:** Lake Formation requires separate resource registration for fine-grained control; lifecycle policies limited to prefix filters; risk of accidental cross-zone access; harder to apply different encryption

---

## Related

- [Feature F-001: S3 Storage Zones](../feature.md#f-001-s3-storage-zones)
- [Architecture: Data Zones Detail](../architecture.md#data-zones-detail)
