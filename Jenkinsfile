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
                git branch: 'main', url: 'https://github.com/akankshanigam/Terrafrom.git'
            }
        }

        stage('Terraform Init') {
            when {
                expression { return true }
            }
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp_cred', variable: 'GCP_CRED')]) {
                        sh "terraform init -backend-config=credentials=\"$GCP_CRED\""
                    }
                }
            }
        }

        stage('Prepare Credentials') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp_cred', variable: 'GCP_CRED_FILE')]) {
                        sh "cp ${GCP_CRED_FILE} ${WORKSPACE}/key.json"
                        sh "ls -l ${WORKSPACE}" // Debugging step
                    }
                }
            }
        }

        stage('Terraform Validate') {
            when {
                expression { return true }
            }
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp_cred', variable: 'GCP_CRED')]) {
                        sh "terraform plan -var 'credentials_file=${GCP_CRED}' -out=tfplan"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return true }
            }
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return true }
            }
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
