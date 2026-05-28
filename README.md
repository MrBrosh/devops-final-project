# DevOps Final Project (Jenkins + Terraform + Ansible)

## Goal
Build a Jenkins pipeline that provisions a cloud VM with Terraform, deploys a real web application with Ansible, and validates the website is accessible over HTTP.

## Bonus: CV Builder deployment
The pipeline deploys **[Cv-Builder](https://github.com/MrBrosh/Cv-Builder)** (React + Node.js) instead of a static demo page:

- **Terraform** provisions Ubuntu EC2 + Security Group (22/80) + SSH key + Ansible inventory
- **Ansible** installs Node.js 20, Nginx, clones Cv-Builder, builds client/server, runs API via `systemd`, and serves the SPA through Nginx (with `/api` reverse proxy)
- **Validation** checks `GET /health` and that the homepage contains `CV Builder`

### Demo credentials (created on server start)
| Field | Value |
|-------|-------|
| Email | `admin@cvbuilder.local` |
| Password | `Admin123!` |

### Optional: enable AI (Gemini)
Add a Jenkins credential:
- Kind: **Secret text**
- ID: `GEMINI_API_KEY`
- Secret: your Google AI Studio key

If omitted, the app still runs; AI text improvement will not work until a key is provided.

## Repository structure
- `Jenkinsfile` – pipeline stages
- `terraform/` – AWS infrastructure
- `ansible/` – CV Builder deployment playbook + templates
- `jenkins.Dockerfile` – custom Jenkins image with Terraform + Ansible (optional)

## Prerequisites (Jenkins)
- Terraform + Ansible available on the Jenkins agent (included in `jenkins-devops:lts` image)
- AWS credentials: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

## Jenkins URL
After deployment, open: `http://<public_ip>/` (from Terraform output `public_ip`).

## Notes
- Default AWS region: `us-east-1`
- Instance type: `t3.micro` (Free Tier eligible)
- Ubuntu 24.04 AMI is selected automatically
