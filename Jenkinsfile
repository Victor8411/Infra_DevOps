pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "${env.WORKSPACE}/test1.json"
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                echo '📦 Initialisation de Terraform'
                sh 'rm -rf .terraform'
                sh 'echo yes | terraform init'
                echo '🚀 Application de l’infrastructure'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Génération hosts.ini') {
            steps {
                echo '📄 Génération dynamique de hosts.ini'
                sh './generate-hosts.sh'
            }
        }

        stage('Clean SSH fingerprints') {
            steps {
                echo '🧼 Nettoyage des anciennes empreintes SSH'
                sh '''
                    grep -Eo '[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+' hosts.ini | while read ip; do
                        echo "🧼 Suppression de l'empreinte SSH pour $ip"
                        ssh-keygen -R "$ip" -f /var/lib/jenkins/.ssh/known_hosts || true
                    done
                '''
            }
        }

        stage('Ansible Playbook') {
            steps {
                echo '🔧 Lancement du playbook Ansible'
                sh 'ansible-playbook -i hosts.ini site.yml'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminé avec succès.'
        }
        failure {
            echo '❌ Échec du pipeline.'
        }
    }
}
