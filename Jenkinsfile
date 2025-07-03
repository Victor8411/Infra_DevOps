pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "${env.WORKSPACE}/test1.json"
        ANSIBLE_HOST_KEY_CHECKING = "False"
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
                    KNOWN_HOSTS="/var/lib/jenkins/.ssh/known_hosts"
                    for ip in $(awk '/ansible_host/ {print $2}' hosts.ini | cut -d= -f2); do
                        ssh-keygen -f "$KNOWN_HOSTS" -R "$ip" || true
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
