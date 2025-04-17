pipeline {
  agent any

  environment {
    SLACK_WEBHOOK = credentials('SLACK_WEBHOOK_URL')
    HUGGINGFACE_API_KEY = credentials('HUGGINGFACE_API_KEY')
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/EmergencyTechOps/self-healing-ci.git'
      }
    }

    stage('Test in Node.js') {
      agent {
        docker {
          image 'node:18'
          args '-u root:root'
        }
      }
      steps {
        sh 'npm install'
        sh 'npm test || true'
        sh 'bash ai-remediation.sh || true'
      }
    }
  }
}
