properties([
    parameters([
        string(
            defaultValue: 'dev',
            name: 'Environment'
        ),
        choice(
            choices: ['plan', 'apply', 'destroy'], 
            name: 'Terraform_Action'
        )])
])

pipeline {
    agent any
    stages {
        stage("Preparing") {
            steps {
                sh "echo preparing"
            }
        }

        stage("Checkout SCM") {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/radhe203/nginx-tf.git']])
            }
        }

        stage("Initializing Terraform") {
            steps {
                withAWS(credentials: "aws-creds", region: "us-east-1") {
                    dir("eks") {
                        sh "terraform init"
                    }
                }
            }
        }

        stage("Validating") {
            steps {
                withAWS(credentials: "aws-creds", region: "us-east-1") {
                    dir("eks") {
                        sh "terraform validate"
                    }
                }
            }
        }

        stage("Terraform Action") {
            steps {
                withAWS(credentials: "aws-creds", region: "us-east-1") {
                    dir("eks") {
                        script {
                            if (params.Terraform_Action == 'plan') {
                                sh "terraform plan"
                            } else if (params.Terraform_Action == 'apply') {
                                sh "terraform apply --auto-approve"
                            } else if (params.Terraform_Action == 'destroy') {
                                sh "terraform destroy --auto-approve"
                            }
                        }
                    }
                }
            }
        }
    }
}
