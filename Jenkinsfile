pipeline{
    agent any
    tools {
        maven 'maven'
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
}
}
