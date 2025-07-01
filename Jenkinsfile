pipeline {
  agent any

  environment {
    GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}/terraform-test1/test1.json"
  }

  stages {
    stage('Terraform Init & Apply') {
      steps {
        echo '📦 Initialisation de Terraform'
        sh 'terraform init'

        echo '🚀 Application de l’infrastructure'
        sh 'terraform apply -auto-approve'
      }
    }

    stage('Ansible Playbook') {
      steps {
        echo '📡 Provision avec Ansible'
        sh 'ansible-playbook site.yml'
      }
    }
  }

  post {
    failure {
      echo '❌ Échec du pipeline.'
    }
  }
}
