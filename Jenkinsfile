pipeline {
    agent any
    environment {
        // מגדירים את התיקייה הנוכחית כמיקום להתקנה
        PATH = "${env.WORKSPACE}/bin:${env.PATH}"
    }
    stages {
        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh '''
                    mkdir -p ${WORKSPACE}/bin
                    if ! command -v terraform &> /dev/null; then
                        curl -fsSL https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip -o terraform.zip
                        unzip -o -q terraform.zip -d ${WORKSPACE}/bin
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