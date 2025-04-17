pipeline {
  agent any
  environment {
    SLACK_WEBHOOK = credentials('SLACK_WEBHOOK_URL')
    HUGGINGFACE_API_KEY = credentials('HUGGINGFACE_API_KEY')
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/EmergencyTechOps/self-healing-ci.git'
      }
    }
    stage('Install') {
      steps {
        sh 'npm install'
      }
    }
    stage('Test') {
      steps {
        script {
          def status = sh(script: 'npm test || true', returnStatus: true)
          if (status != 0) {
            echo "❌ Tests failed. Triggering AI remediation..."
            sh 'bash ai-remediation.sh'
          }
        }
      }
    }
  }
}
