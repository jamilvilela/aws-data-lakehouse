# Architecture Decision Records (ADR) Index

> Index of all Architecture Decision Records for the AWS Data Lakehouse project.

---

| ID | Title | Status | Date |
|---|---|---|---|
| [ADR-001](ADR-001-lf-roles-as-principals.md) | Using IAM Roles as Lake Formation Principals | ✅ Accepted | 2024-01-15 |
| [ADR-002](ADR-002-medallion-bucket-per-zone.md) | Separate S3 Buckets per Medallion Zone | ✅ Accepted | 2024-01-15 |
| [ADR-003](ADR-003-single-analytics-role.md) | Single Unified IAM Role for Analytics Services | ✅ Accepted | 2024-01-15 |

---

## ADR Template

When proposing a new ADR, use the following structure:

```markdown
# ADR-NNN: Title

**Status:** [Proposed | Accepted | Deprecated | Superseded]
**Date:** YYYY-MM-DD
**Author:** @agent-name

---

## Context

[Description of the problem, constraint, or situation]

---

## Decision

[The chosen approach]

---

## Consequences

### Positive
- ✅ ...

### Negative
- ⚠️ ...

### Mitigations
- ...

---

## Alternatives Considered

### Alternative 1: ...
- **Pros:** ...
- **Cons:** ...

---

## Related

- [Feature F-00N: ...](../feature.md)
```
