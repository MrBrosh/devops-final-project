pipeline {
    agent { label 'host' }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MrBrosh/devops-final-project.git'
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    script {
                        if (isUnix()) {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                        } else {
                            powershell 'terraform init'
                            powershell 'terraform apply -auto-approve'
                        }
                    }
                }
            }
        }
        stage('Ansible Playbook') {
            steps {
                dir('ansible') {
                    script {
                        if (isUnix()) {
                            sh 'ansible-playbook -i ../terraform/inventory.ini playbook.yml'
                        } else {
                            powershell 'ansible-playbook -i ..\\terraform\\inventory.ini playbook.yml'
                        }
                    }
                }
            }
        }
        stage('Validate Website') {
            steps {
                dir('terraform') {
                    script {
                        if (isUnix()) {
                            sh 'IP=$(terraform output -raw public_ip) && curl -f "http://$IP" | head -n 20'
                        } else {
                            powershell '$ip = terraform output -raw public_ip; (Invoke-WebRequest -UseBasicParsing -Uri "http://$ip").StatusCode'
                        }
                    }
                }
            }
        }
    }
}