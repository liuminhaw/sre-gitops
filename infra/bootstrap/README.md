# Terraform Bootstrap Guide (GCP ops + GCS Remote State + GitHub WIF)

This directory (`infra/bootstrap/`) bootstraps the **shared ops project** and shared resources used by the rest of this repo:

- A GCP project (the “ops/shared” project)
- A GCS bucket for Terraform remote state (used by `infra/bootstrap` and `infra/live/*`)
- Artifact Registry (Docker) repository for app images
- GitHub Actions Workload Identity Federation (OIDC) + per-environment IAM bindings (so CI/CD can run without long-lived keys)
- Optional: creates additional per-environment projects (dev/staging/prod) via `sre_projects`

This guide follows the common pattern: **create the state bucket with local state first**, then **migrate** to the GCS backend so Terraform can manage itself safely.

## Prerequisites

- Terraform (see `required_version` in `main.tf`)
- GCP credentials with permission to create projects/enable APIs/create IAM/buckets (often “Organization Admin” + billing permissions)
- Local auth (one of):
  - `gcloud auth application-default login`
  - or set `GOOGLE_APPLICATION_CREDENTIALS` to a service account JSON (local-only; CI uses WIF)

## Configure inputs

Edit `terraform.tfvars` (or use `-var-file=...`) and set at least:

- `project_id` (ops/shared project)
- `billing_account_id`
- `region`
- `tf_state_bucket_name`
- `github_owner`, `github_repo`
- `sre_projects` (e.g., dev/staging/prod project IDs)

## Step 1 — Create state bucket using local state

For the *very first* run, you must **not** use a remote backend yet.

In this repo, `backend.tf` already exists to represent the final desired state. For first-time bootstrap, temporarily disable it:

```bash
mv backend.tf backend.tf.disabled
```

Then run:

``` bash
terraform init
terraform apply
```

At this stage, Terraform state exists locally:

```
infra/bootstrap/terraform.tfstate
```

---

## Step 2 — Enable the GCS backend configuration

Re-enable the backend config:

```bash
mv backend.tf.disabled backend.tf
```

---

## Step 3 — Migrate local state to GCS

Run
``` bash
terraform init -migrate-state
```

Terraform will prompt:
```bash
Do you want to copy existing state to the new backend?

# type: yes
```

---

## After Migration

-   Local state is copied to GCS
-   Bootstrap now uses remote state
-   GCS bucket becomes the source of truth
-   Local state file is no longer authoritative

---

## Validation

``` bash
terraform plan

# Expected output: No changes.
```

---

## Outputs you will use later

After `terraform apply`, useful outputs include:

- WIF:
  - `wif_pool_name`
  - `wif_provider_name`
- CI/CD:
  - `github_sa_email` (per target project)
- Registry:
  - `registry_repo_id`
- Remote state:
  - `tf_state_bucket_url`

These are typically wired into GitHub Environments Variables (see root `README.md`).

## Optional: Create Additional Projects

`terraform.tfvars` supports creating additional projects via `sre_projects`, allowing per-project `org_id` / `folder_id`:

```hcl
sre_projects = {
  "example-project-a" = {
    billing_account_id = "AAAAAA-BBBBBB-CCCCCC"
    org_id             = "123456789012"
  }
  "example-project-b" = {
    billing_account_id = "AAAAAA-BBBBBB-CCCCCC"
    folder_id          = "folders/123456789012"
  }
}
```

Note: `org_id` and `folder_id` are mutually exclusive per project.

---

## Notes / gotchas

- Do not commit `.terraform/` directories or `terraform.tfstate*` files in real projects. They can contain sensitive metadata.
- If you change the state bucket name/prefix, update backend blocks under `infra/live/*/backend.tf` accordingly.
- This bootstrap creates IAM bindings for GitHub OIDC. The policy in `modules/github-wip/` is intentionally restrictive to this repo and certain refs/events.

## Summary

1.  Disable `backend.tf` and apply once to create the bucket/resources
2.  Re-enable `backend.tf`
3.  Run `terraform init -migrate-state`
4.  Run `terraform plan` to confirm no drift

This is the standard and production-safe Terraform bootstrap pattern.
