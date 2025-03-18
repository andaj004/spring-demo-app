pipeline {
    agent any
    environment {
        // Set the path to the temporary kubeconfig location
        KUBECONFIG = '/tmp/kubeconfig'
    }
    stages {
        stage('Checkout') {
            steps {
                // Pull the latest code from GitHub
                git 'https://github.com/andaj004/spring-demo-app'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build('spring-app-dev')
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Push the built Docker image to a registry
                    docker.withRegistry('https://hub.docker.com/repositories/andaj') {
                        docker.image('spring-app-dev').push()
                    }
                }
            }
        }
        stage('Deploy to K3D Cluster') {
            steps {
                script {
                    // Use the kubeconfig from Jenkins credentials store to configure access
                    withCredentials([file(credentialsId: 'kubeconfig-dev', variable: 'KUBECONFIG_FILE')]) {
                        // Copy the kubeconfig to the appropriate path
                        sh """
                          cp $KUBECONFIG_FILE $KUBECONFIG
                          echo "Kubeconfig file copied successfully!"
                        """
                        // Deploy using Helm
                        sh """
                          helm upgrade --install spring-app ./helm/dev --kubeconfig $KUBECONFIG
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            // Clean up any sensitive files
            cleanWs()
        }
    }
}
