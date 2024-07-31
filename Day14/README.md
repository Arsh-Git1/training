Project
Problem Statement:

You are tasked with setting up a CI/CD pipeline using Jenkins to streamline the deployment process of a simple Java application. The pipeline should accomplish the following tasks:

    Fetch the Dockerfile:
        The pipeline should clone a GitHub repository containing the source code of the Java application and a Dockerfile.

FROM openjdk:11

COPY . /usr/src/myapp

WORKDIR /usr/src/myapp

RUN javac App.java

CMD ["java", "App.java"]



    Create a Docker Image:
        The pipeline should build a Docker image from the fetched Dockerfile.

sh "docker build -t arshshaikh777/myjava-app"



    Push the Docker Image:
        The pipeline should push the created Docker image to a specified DockerHub repository.

    Deploy the Container:
        The pipeline should deploy a container using the pushed Docker image.

pipeline {
    agent any
    environment {
        registry = 'docker.io'  
        registryCredential = 'docker-hub' 
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Arsh-Git1/training/Day14.git', branch: 'main'
            }
        }

        stage('build image') {
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        def customImage = docker.build("arshshaikh777/myjava-app:${env.BUILD_ID}")
                        customImage.push()


                    }

                }
            }
        }

        stage('Deploy Container') {
            steps {

                script {
                    docker.withRegistry('', registryCredential) {
                        def runContainer = docker.image("arshshaikh777/myjava-app:${env.BUILD_ID}").run('--name mynew-container -d')
                        echo "Container ID: ${runContainer.id}"
                    }
                }
            }
        }

        stage('Output') {
            steps{
                script{
                    sh 'java App.java'
                }
            }
        }

    }


}

Deliverables:

    GitHub Repository: A GitHub repository containing:

        The source code of a simple Java application.

        A Dockerfile for building the Docker image.

![alt text](<Screenshot from 2024-07-31 16-45-08.png>)

![alt text](<Screenshot from 2024-07-31 16-46-30.png>)

![alt text](<Screenshot from 2024-07-31 16-46-45.png>)



    Jenkins Pipeline Script: A Jenkinsfile (pipeline script) that:

        Clones the GitHub repository.

        Builds the Docker image.

        Pushes the Docker image to DockerHub.

        Deploys a container using the pushed image.

stage('build image') {
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        def customImage = docker.build("arshshaikh777/myjava-app:${env.BUILD_ID}")
                        customImage.push()


                    }

                }
            }
        }

        stage('Deploy Container') {
            steps {

                script {
                    docker.withRegistry('', registryCredential) {
                        def runContainer = docker.image("arshshaikh777/myjava-app:${env.BUILD_ID}").run('--name mynew-container -d')
                        echo "Container ID: ${runContainer.id}"
                    }
                }
            }
        }

![alt text](<Screenshot from 2024-07-31 16-56-26.png>)


DockerHub Repository:
        A DockerHub repository where the Docker images will be stored.***

Jenkins Setup:

Jenkins installed and configured on a local Ubuntu machine.

Required plugins installed (e.g., Git, Docker, Pipeline).






