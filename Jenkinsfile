pipeline {
    agent any 

    environment {
        GCP_CRED = credentials('gcp_cred')
        PATH = "$PATH:$WORKSPACE/bin"
    }

    stages {
        stage('Install Terraform') {
            when {
                expression { return false }
            }
            steps {
                script {
                    sh 'mkdir -p $WORKSPACE/bin'
                    sh 'curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.4/terraform_1.0.4_linux_amd64.zip'
                    sh 'unzip -o terraform.zip terraform'
                    sh 'chmod +x terraform'
                    sh 'mv terraform $WORKSPACE/bin/'
                }
            }
        }

        stage('Checkout') {
            when {
                expression { return true }
            }
            steps {
                sh 'rm -rf Terrafrom'
                sh 'git clone https://github.com/akankshanigam/Terrafrom.git'
            }
        }
        
        stage('Terraform Init') {
            when {
                expression { return true }
            }
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp_cred', variable: 'GCP_CRED')]) {
                        sh 'cp $GCP_CRED $WORKSPACE/credentials.json'
                        sh 'terraform init -backend-config=credentials="credentials.json"'
                    } // Added closing brace
                } // Added closing brace
            }
        }
        
        stage('Terraform Validate') {
            when {
                expression { return true }
            }
            steps {
                script {
                    sh "terraform plan -var 'credentials_file=credentials.json' -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return true }
            }
            steps {
                script {
                     sh "terraform apply -auto-approve tfplan"
                    
                }
            }
        }
    }
}
