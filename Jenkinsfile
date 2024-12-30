pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'alina222619/quiz:latest'
        DOCKER_REGISTRY = 'docker.io'
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
                    // Clone the GitHub repository using credentials
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
                        // Building the Docker image
                        bat 'docker build -t %DOCKER_IMAGE% .'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', 
                                                  usernameVariable: 'DOCKER_USERNAME', 
                                                  passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login to Docker Hub and push the image
                        bat "echo %DOCKER_PASSWORD% | docker login %DOCKER_REGISTRY% -u %DOCKER_USERNAME% --password-stdin"
                        bat "docker push %DOCKER_IMAGE%"
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container
                    bat "docker run -d %DOCKER_IMAGE%"
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
