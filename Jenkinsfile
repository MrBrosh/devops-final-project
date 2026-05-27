pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MrBrosh/devops-final-project.git'
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Ansible Playbook') {
            steps {
                dir('ansible') {
                    // כאן נריץ את ה-playbook לאחר שהשרת יוקם
                    sh 'ansible-playbook -i ../terraform/inventory playbook.yml'
                }
            }
        }
    }
}