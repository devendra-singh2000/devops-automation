pipeline {
  agent any
  tools {
      maven 'maven'
  }

    environment {
        
        reg_address = "749177923916.dkr.ecr.us-east-1.amazonaws.com"

        repo = "demo-app"
      
        
    }

    stages {
        stage('Checkout') {
          
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/devendra-singh2000/devops-automation.git']]])
            } 
                
        }

        stage('maven build'){
            steps{
          
//                 sh  'cd spring-boot-rest-example'
                sh 'mvn clean install'
                 }
        }
        
        stage('dockerfile build'){
            steps{
          
                sh  'docker build -t java-app/build /var/lib/jenkins/workspace/pushtorecr/.'
                sh 'docker tag java-app/build 749177923916.dkr.ecr.us-east-1.amazonaws.com/demo-app:java_app-build-${BUILD_NUMBER}'
                 }
        }
        stage('ECR logging'){
                steps{

                 sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 749177923916.dkr.ecr.us-east-1.amazonaws.com'
                }
        }
        
        stage('docker push'){
                 steps{
                     sh 'docker push ${reg_address}/${repo}:java_app-build-${BUILD_NUMBER}'
                 }
        }
        stage('terraform format check') {
            steps{
                sh 'terraform fmt'
            }
        }
        stage('terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform apply') {
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
        stage('terraform destroy'){
            steps{
                sh 'terraform destroy --auto-approve'
            }
        }      

    }
  
}
