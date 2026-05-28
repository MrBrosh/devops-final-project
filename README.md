# DevOps Final Project (Jenkins + Terraform + Ansible)

## Goal
Build a Jenkins pipeline that provisions a cloud VM with Terraform, configures a website with Ansible, and validates the website is accessible over HTTP.

## Repository structure
- `Jenkinsfile`: Jenkins pipeline
- `terraform/`: AWS infrastructure (EC2, Security Group, SSH key, inventory)
- `ansible/`: Playbook that installs Nginx and deploys `index.html`

## Prerequisites (Jenkins agent)
- Terraform installed (`terraform`)
- Ansible installed (`ansible-playbook`)
- AWS credentials available to the job (recommended: Jenkins Credentials → environment variables `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)

## How it works
1. **Terraform** provisions an EC2 instance and opens ports 22/80.
2. Terraform generates:
   - `terraform/web_key.pem` (SSH key used by Ansible)
   - `terraform/inventory.ini` (Ansible inventory with instance IP)
3. **Ansible** connects to the instance and installs/configures Nginx + deploys a static page.
4. **Validation** checks the website responds via HTTP.

## Notes
- Region is `us-east-1` by default (see `terraform/main.tf`).
- Instance is Ubuntu 24.04 and uses `ansible_user=ubuntu`.