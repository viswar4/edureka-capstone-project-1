pipeline{
    agent any
    tools {
        maven 'maven'
    }
    environment{
        DOCKER_HUB_CREDENTIALS = 'dockerhub'
        DOCKER_IMAGE_NAME = 'viswar4/edureka-project1'
        DOCKER_IMAGE_TAG = "${env.BUILD_ID}"
    }

    stages{
    
    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.war'
      }
    }

    stage('Unit tests') {
        steps {
        sh "mvn test"
        }
    
    post {
            success {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
            }
        }

    }

    stage('Sonarqube code analysis'){
        steps{
            withSonarQubeEnv(credentialsId: 'sonarqube',installationName: 'sonarqube') {
                    sh 'mvn clean package sonar:sonar'
            }
        }
    }

    stage('Quality gate status'){
        steps{
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
        }
    }
}

    stage('Docker image build and push to dockerhub'){
        steps{
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")

                    //Log into Dockerhub
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_HUB_CREDENTIALS){
                        dockerImage.push()
                    }
                }
                }
        }
    
    stage('Trivy Docker image scan'){
        steps{
            script{
                def trivyScanResult = sh(script: "trivy --exit-code 0 $(docker.Image)", returnStatus: true )
                if (trivyScanResult !=0){
                    error "Trivy scan failed"
                }
            }
        }
    }
    
    }
}
