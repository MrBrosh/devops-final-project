# DevOps Final Project – Jenkins + Terraform + Ansible

**Student:** Matan Brosh  
**Repository:** https://github.com/MrBrosh/devops-final-project  
**Deployed app (bonus):** [Cv-Builder](https://github.com/MrBrosh/Cv-Builder)

---

## Project goal

A Jenkins pipeline that automates:

1. **Terraform** – provision an Ubuntu server on AWS (EC2) + Security Group + SSH key
2. **Ansible** – install and configure the **CV Builder** app (React + Node.js) behind Nginx
3. **Validation** – verify the website and API are reachable over HTTP

---

## Architecture flow

```
Lecturer / Student
      |
      v
+-------------+     git pull      +------------------+
|   Jenkins   | ----------------> | devops-final-    |
|  (Docker)   |                   | project (GitHub)   |
+------+------+                   +------------------+
       | Build Now
       v
+-------------+   terraform apply   +-------------+
|  Terraform  | -----------------> |  AWS EC2    |
+-------------+                     +------+------+
       |                                   |
       | ansible-playbook                  | SSH :22
       v                                   v
+-------------+                     +-------------+
|   Ansible   | -----------------> | CV Builder  |
|             |   clone + build     | Nginx :80   |
+-------------+                     +-------------+
```

---

## For the lecturer – how to run and verify

> **Login credentials (Jenkins + website)** were sent via the course Moodle message.  
> **Do not store passwords in this file or in Git.**

### 1) Sign in to Jenkins

| Item | Value |
|------|-------|
| **URL** | http://13.63.160.119:8080 |
| **Username / password** | As provided in Moodle |

The lecturer account uses limited permissions (Matrix):

- **Overall → Read** – access the dashboard
- **Job → Build, Read, Workspace** – run the pipeline and view logs
- **View → Read**

### 2) Run the pipeline

1. Sign in to Jenkins
2. Open job: **`devops-final-project`**
3. Click **Build Now**
4. Open the build → **Console Output** and follow:
   - Checkout
   - Terraform Init & Apply
   - Ansible Playbook
   - Validate Website

**Estimated runtime:** about 10–15 minutes (React build may take a while).

### 3) Check the website after a successful build

At the end of the Terraform stage, the console shows:

```
public_ip = "x.x.x.x"
```

Open in a browser:

| What to check | URL |
|---------------|-----|
| **CV Builder app** | `http://<public_ip>/` |
| **API health** | `http://<public_ip>/health` |

**App login** – credentials were sent via Moodle (admin user is created automatically on the server).

### 4) Expected success indicators

- Jenkins: **Finished: SUCCESS** (green)
- Console – Validate stage shows `/health` response and **CV Builder** on the homepage
- Browser – login screen / CV editor

---

## Bonus – full application deployment

Instead of a static HTML page, the pipeline deploys **[Cv-Builder](https://github.com/MrBrosh/Cv-Builder)**:

- **Frontend:** React + Vite (served by Nginx)
- **Backend:** Node.js + Express (`systemd`, reverse proxy at `/api`)
- **Features:** CV editor, live preview, server-side save, AI text improvement (if Gemini key is configured)

---

## Repository structure

```
devops-final-project/
├── Jenkinsfile              # Pipeline (Checkout → Terraform → Ansible → Validate)
├── README.md                # This file
├── jenkins.Dockerfile         # Custom image: Jenkins + Terraform + Ansible
├── terraform/
│   ├── main.tf              # EC2, SG, key pair, inventory, Ubuntu 24.04 AMI
│   ├── variables.tf
│   └── outputs.tf           # public_ip, inventory_path
└── ansible/
    ├── playbook.yml         # CV Builder deployment
    └── templates/
        ├── nginx-cv-builder.conf.j2
        ├── cv-builder.service.j2
        └── server.env.j2
```

---

## Pipeline stages

| Stage | Tool | Action |
|-------|------|--------|
| Checkout | Git | Pull code from GitHub |
| Terraform Init & Apply | Terraform | Create/update AWS infrastructure |
| Ansible Playbook | Ansible | Install Node, Nginx, clone Cv-Builder, build, start services |
| Validate Website | curl | `GET /health` + check homepage title |

---

## Jenkins environment

- **Jenkins** runs in Docker on EC2 (`jenkins-devops:lts` image)
- **Terraform** and **Ansible** are included in the image
- **AWS credentials** in Jenkins (Global): `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`  
  *(not committed to Git)*

### AWS settings

| Parameter | Value |
|-----------|-------|
| Region | `us-east-1` |
| Instance type | `t3.micro` (Free Tier eligible) |
| AMI | Ubuntu 24.04 (auto-selected) |
| Open ports | 22 (SSH), 80 (HTTP), 8080 (Jenkins) |

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| Terraform fails | Check AWS credentials in Jenkins; check Free Tier limits |
| Ansible SSH fails | Wait 1 minute and rebuild (new instance boot); check SG allows port 22 |
| npm build fails | Small instance – swap is enabled; retry the build |
| Website not loading | Use `public_ip` from Terraform output; check SG allows port 80 |
| Jenkins unreachable | Check SG allows inbound port 8080 |

---

## Links

| Resource | URL |
|----------|-----|
| DevOps repo (assignment) | https://github.com/MrBrosh/devops-final-project |
| CV Builder repo | https://github.com/MrBrosh/Cv-Builder |
| Jenkins | http://13.63.160.119:8080 |

---

## Security notes

- AWS keys, SSH keys, and passwords are **not** stored in Git
- Lecturer Jenkins access is limited (no Admin)
- Consider restricting Security Group port 8080 to specific IPs after grading

---

**Good luck!**
