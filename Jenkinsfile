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
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage('Ansible Playbook') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i ../terraform/inventory.ini playbook.yml'
                }
            }
        }
        stage('Validate Website') {
            steps {
                dir('terraform') {
                    sh 'IP=$(terraform output -raw public_ip) && curl -fsS "http://$IP" | head -n 20'
                }
            }
        }
    }
}