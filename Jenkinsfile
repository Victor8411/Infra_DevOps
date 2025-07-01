pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}/terraform-test1/test1.json"
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                echo '📦 Initialisation de Terraform'
                dir('terraform-test1') {
                    sh 'terraform init'
                    echo '🚀 Application de l’infrastructure'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Playbook') {
            steps {
                echo '📡 Lancement du playbook Ansible'
                sh '''
                    cd terraform-test1
                    ansible-playbook -i inventory.ini playbook.yml
                '''
            }
        }
    }

    post {
        failure {
            echo '❌ Échec du pipeline.'
        }
        success {
            echo '✅ Pipeline terminé avec succès.'
        }
    }
}
