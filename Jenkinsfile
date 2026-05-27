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
                    sh '''
                    if ! command -v terraform &> /dev/null; then
                        curl -fsSL https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip -o terraform.zip
                        unzip -o terraform.zip
                        mv terraform /usr/local/bin/
                    fi
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }
        stage('Ansible Playbook') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i ../terraform/inventory playbook.yml'
                }
            }
        }
    }
}