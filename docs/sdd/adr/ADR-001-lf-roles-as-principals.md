# ADR-001: Using IAM Roles as Lake Formation Principals

**Status:** ✅ Accepted  
**Date:** 2024-01-15  
**Author:** @architect

---

## Context

AWS Lake Formation is the central governance service for the data lake. It manages permissions on databases, tables, and S3 locations. Lake Formation supports several principal types:

- IAM Users
- IAM Roles
- IAM Groups ❌ **Not supported**
- SAML/SSO users

The project requires a 3-tier access model:
1. **Admins** — Full access to all data and metadata
2. **Internal Users** — Read access to all zones
3. **External Users** — Read access to business zone only

IAM Groups are the natural mechanism for managing multiple users with the same permissions. However, LF does not accept groups as principals.

---

## Decision

We will create dedicated IAM roles for each access level and use them as Lake Formation principals:

| IAM Group | sts:AssumeRole Target | LF Principal Role |
|---|---|---|
| `datalake-admins` | → | `datalake-admins-lf-role` |
| `datalake-users-internal` | → | `datalake-users-internal-lf-role` |
| `datalake-users-external` | → | `datalake-users-external-lf-role` |

---

## Mechanism

1. IAM users are created and added to IAM groups.
2. Each IAM group has an inline policy allowing `sts:AssumeRole` on the corresponding LF role.
3. Users authenticate as their IAM user, then assume the LF role.
4. All Lake Formation permissions are granted to the LF roles (not to users or groups).

```hcl
# Group policy (simplified)
resource "aws_iam_group_policy" "assume_role" {
  policy = jsonencode({
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = aws_iam_role.datalake_admins_lf_role.arn
    }]
  })
}

# LF permission (simplified)
resource "aws_lakeformation_permissions" "example" {
  principal   = aws_iam_role.datalake_admins_lf_role.arn
  permissions = ["SELECT", "DESCRIBE"]
}
```

---

## Consequences

### Positive
- ✅ Lake Formation permission model works correctly
- ✅ Group membership cleanly controls access levels
- ✅ No changes needed when adding new users (just add to group)
- ✅ Audit trail shows which role was used

### Negative
- ⚠️ Users must explicitly assume role (via AWS CLI, console switch role, or SDK)
- ⚠️ Additional IAM roles in the account (3 LF roles + 1 workflow role)
- ⚠️ Slightly more complex setup

### Mitigations
- `setup.sh` script automates role assumption for Terraform deployment
- Console users can switch role in the AWS Console UI
- SDK users can use `sts:AssumeRole` programmatically

---

## Alternatives Considered

### Alternative 1: Direct IAM User Principals
- **Pros:** Simple, direct
- **Cons:** Every user must be individually added to LF permissions; poor scalability

### Alternative 2: SAML Federation
- **Pros:** Enterprise SSO, no IAM users
- **Cons:** Requires identity provider; overengineered for current scope

### Alternative 3: LF Tag-Based Access Control
- **Pros:** Flexible, attribute-based
- **Cons:** More complex; still requires principal configuration; not supported for all permission types

---

## Related

- [Feature F-005: Access Control Model](../feature.md#f-005-access-control-model-3-tier)
- [Architecture: IAM & Access Control](../architecture.md#iam--access-control-architecture)
