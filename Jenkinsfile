pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                script {
                    def ips = sh(script: "terraform output -json", returnStdout: true)
                    def output = readJSON text: ips

                    def content = "[front]\n${output.front_ip.value}\n\n" +
                                  "[back]\n${output.back_ip.value}\n\n" +
                                  "[db]\n${output.db_ip.value}\n"

                    writeFile file: 'hosts.ini', text: content
                }
            }
        }

        stage('Run Ansible') {
            steps {
                sh 'ansible-playbook site.yml -i hosts.ini'
            }
        }
    }
}
