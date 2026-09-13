# Pi-hole Terraform (OpenTofu)

![OpenTofu](https://img.shields.io/badge/OpenTofu-1.10.0-7B42BC?style=flat-square&logo=opentofu&logoColor=white)
![Pi-hole Provider](https://img.shields.io/badge/dklesev%2Fpihole-~>1.0-96060C?style=flat-square)
![GitHub Actions](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white)

## 📖 Description

**Pi-hole Terraform** manages your homelab Pi-hole instance as code using [OpenTofu](https://opentofu.org/). Instead of clicking through the web UI for every allow/deny rule or local DNS record, you declare DNS policy in version-controlled `.tf` files and apply changes predictably. Remote state lives in **Amazon S3**, and **GitHub Actions** validates, plans, and applies updates on every push to `main`—with **Tailscale** so CI can reach Pi-hole on your private network.

## ✨ Key Features

- **Declarative DNS policy** — Centralized allow and deny lists in `allow.tf` and `deny.tf`, with support for `exact` and `regex` rules (including subdomain wildcards via regex).
- **Local DNS records** — Optional `pihole_local_dns` resources for static hostname → IP mappings in `main.tf`.
- **Remote state on S3** — Encrypted state in `us-east-1` with lockfile support for safer concurrent operations.
- **CI/CD pipeline** — Format check, validate (no backend), plan, and apply using a saved plan artifact so production matches what was reviewed.
- **Homelab-friendly access** — Plan/apply jobs connect through Tailscale; Pi-hole API credentials supplied via GitHub Secrets and `TF_VAR_*` environment variables.
- **Safe refactors** — `moved` blocks document one-time state migrations without destructive recreates.

## 🛠️ Tech Stack

| Category | Tools |
|----------|--------|
| **IaC** | [OpenTofu](https://opentofu.org/) 1.10.x (Terraform-compatible) |
| **Provider** | [dklesev/pihole](https://registry.terraform.io/providers/dklesev/pihole/latest) (~> 1.0, pinned in lockfile) |
| **State backend** | AWS S3 (`encrypt`, `use_lockfile`) |
| **CI/CD** | GitHub Actions (`opentofu/setup-opentofu`, artifact-based plan/apply) |
| **Network (CI)** | [Tailscale GitHub Action](https://github.com/tailscale/github-action) |
| **Target** | Pi-hole HTTP API (admin password auth) |

## 🚀 Getting Started

### Prerequisites

Install and configure the following before working locally:

1. **[OpenTofu](https://opentofu.org/docs/intro/install/)** — `1.10.0` matches CI; other 1.x versions may work if compatible.
2. **AWS credentials** — IAM user or role with read/write access to the state bucket configured in `main.tf` (for `tofu init`, `plan`, and `apply`).
3. **Network reachability** — Your machine must reach the Pi-hole API URL (default in `variables.tf` is a LAN address; adjust `pihole_host` if yours differs).
4. **Pi-hole admin password** — Required for the provider; never commit it to git.

For **GitHub Actions** (optional, if you fork or maintain the repo), configure repository secrets:

| Secret | Purpose |
|--------|---------|
| `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` | S3 backend access |
| `PIHOLE_PASSWORD` | Maps to `TF_VAR_pihole_password` |
| `TS_OAUTH_CLIENT_ID` / `TS_OAUTH_SECRET` | Tailscale OAuth for plan/apply runners |

### Installation

Clone the repository and initialize providers and backend:

```bash
git clone https://github.com/ndtvinh13/pihole-tf.git
cd pihole-tf
```

Create a local variables file (gitignored) with your Pi-hole credentials:

```bash
cat > secrets.auto.tfvars <<'EOF'
pihole_password = "your-pihole-admin-password"
# pihole_host   = "http://192.168.0.206:8800"  # optional override
EOF
```

Export AWS credentials for the remote backend, then initialize:

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_REGION="us-east-1"

tofu init
```

## 💻 Usage

### Validate and format

```bash
tofu fmt -recursive
tofu validate
```

### Preview changes

```bash
tofu plan
```

### Apply changes

```bash
tofu apply
```

Apply a saved plan (same pattern as CI):

```bash
tofu plan -out=tfplan
tofu apply -auto-approve tfplan
```

### Add an allow or deny rule

Edit the `locals` map in `allow.tf` or `deny.tf`. Use a stable map key (e.g. `allow_example_com`), set `kind` to `"regex"` or `"exact"`, and run plan/apply.

**Regex (domain + subdomains):**

```hcl
allow_example_com = {
  domain  = "(^|\\.)example\\.com$"
  kind    = "regex"
  comment = "Allow example.com and *.example.com"
}
```

**Exact hostname:**

```hcl
allow_api_example_com = {
  domain  = "api.example.com"
  kind    = "exact"
  comment = "Allow api.example.com only"
}
```

### Add local DNS (A/hostname mapping)

In `main.tf`, add a `pihole_local_dns` resource:

```hcl
resource "pihole_local_dns" "my_service" {
  hostname = "service.home.arpa"
  ip       = "192.168.1.50"
}
```

### CI behavior

On push to `main`, the workflow runs:

1. **Validate** — `tofu fmt -check`, init without backend, `tofu validate`
2. **Plan** — Tailscale connect → full init → `tofu plan -out=tfplan` → upload artifact
3. **Apply** — Download `tfplan` → `tofu apply -auto-approve tfplan`

Pushes from feature branches still run validate; plan/apply follow the workflow’s branch rules on `main`.

### Useful outputs

After apply, selected allow rules are exposed in `outputs.tf` (e.g. `github_com`, `newrelic_com`) for inspection or downstream tooling:

```bash
tofu output github_com
```

---

**Note:** Replace the default S3 bucket name and backend key in `main.tf` if you use your own state bucket. Keep `secrets.auto.tfvars` and `.terraform/` out of version control (see `.gitignore`).
