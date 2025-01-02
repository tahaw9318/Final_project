pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'taha221016/quiz:latest'
        DOCKER_REGISTRY = 'docker.io'
        KUBE_NAMESPACE = 'default' // Adjust namespace if needed
        KUBE_DEPLOYMENT_NAME = 'quiz-app' // Adjust deployment name if needed
    }
    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    deleteDir() // Clean the workspace
                }
            }
        }

        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-credentials', 
                                                  usernameVariable: 'GITHUB_USERNAME', 
                                                  passwordVariable: 'GITHUB_PASSWORD')]) {
                    bat 'git clone https://github.com/tahaw9318/Final_project.git'
                }
            }
        }

        stage('List Files') {
            steps {
                bat 'dir' // List the files in the workspace
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('Final_project') { // Correct directory name
                        bat 'docker build -t %DOCKER_IMAGE% .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials1', 
                                                  usernameVariable: 'DOCKER_USERNAME', 
                                                  passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        echo "Logging in to Docker registry: ${DOCKER_REGISTRY} with user: ${DOCKER_USERNAME}"

                        bat """
                            docker login %DOCKER_REGISTRY% -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%
                        """

                        echo "Pushing Docker image: ${DOCKER_IMAGE}"

                        bat """
                            docker push %DOCKER_IMAGE%
                        """
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    bat "docker run -d %DOCKER_IMAGE%"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: 'kubeconfig-credentials', variable: 'KUBECONFIG')]) {
                    script {
                        echo "Deploying to Kubernetes cluster"
                        // Apply Kubernetes manifest (adjust if a different approach is needed)
                        writeFile file: 'k8s-deployment.yaml', text: """
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: ${KUBE_DEPLOYMENT_NAME}
                          namespace: ${KUBE_NAMESPACE}
                        spec:
                          replicas: 1
                          selector:
                            matchLabels:
                              app: quiz-app
                          template:
                            metadata:
                              labels:
                                app: quiz-app
                            spec:
                              containers:
                              - name: quiz-app-container
                                image: ${DOCKER_IMAGE}
                                ports:
                                - containerPort: 80
                        """
                        bat 'kubectl apply -f k8s-deployment.yaml'
                        
                        // Verify deployment status
                        bat "kubectl rollout status deployment/${KUBE_DEPLOYMENT_NAME} -n ${KUBE_NAMESPACE}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
