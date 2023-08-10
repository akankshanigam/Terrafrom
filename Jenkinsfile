pipeline {
    agent any 

    environment {
        AWS_ACCESS_KEY_ID     = credentials('access_key'')
        AWS_SECRET_ACCESS_KEY = credentials('secret_key')
    }

    stages {
        stage('Install Terraform') {
            when {
                expression { return true}
            }
            steps {
                script {
                    sh 'curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip'
                    sh 'unzip terraform.zip'
                    sh 'chmod +x terraform'
                    sh 'mv terraform /usr/local/bin/'
                }
            }
        }

        stage('Checkout') {
            when {
                expression { return false }
            }
            steps {
                sh 'git clone https://github.com/akankshanigam/Terrafrom.git'
            }
        }
        
        stage('Terraform Init') {
            when {
                expression { return false }
            }
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Validate') {
            when {
                expression { return false }
            }
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return false }
            }
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
