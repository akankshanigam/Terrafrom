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
                        sh "terraform init -backend-config=credentials=\"$GCP_CRED\""
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

        stage('Prepare Credentials') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp_cred', variable: 'GCP_CRED_FILE')]) {
                        sh 'cp ${GCP_CRED_FILE} /var/jenkins_home/workspace/terrafrom_main/credentials.json'
                        sh 'ls -l /var/jenkins_home/workspace/terrafrom_main' // Debugging step
            
                        sh "cp ${GCP_CRED_FILE} credentials.json"
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
    }
}
