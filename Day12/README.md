Project
Project Overview

Your organization is implementing continuous integration (CI) practices to streamline the software development lifecycle. As part of this initiative, you will create a Jenkins declarative pipeline for building a simple Maven project hosted on GitHub. This project aims to automate the build process, ensure code quality, and facilitate continuous delivery (CD).
Objectives

    Create a Jenkins pipeline script using declarative syntax.

pipeline {
    agent any

    tools {
        maven 'Maven - 3.9.0'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                git url: 'https://github.com/Arsh-Git1/Day_12.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                sh 'mvn clean install'
            }
        }

        stage('Archive Artifacts') {
            steps {
                // Archive the built artifacts
                archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}



    Clone a Maven project from a specified GitHub repository.

    Execute the build process and run unit tests.

    Archive build artifacts.

    Provide clear feedback on build status through Jenkins' UI and console output.

Instructions

Setup Jenkins Job

    Create a new Jenkins pipeline job.

![alt text](<Screenshot from 2024-07-31 15-17-30.png>)


    Configure the job to pull the Jenkinsfile from the GitHub repository.

Create Jenkinsfile

    Write a declarative pipeline script (Jenkinsfile) that includes the following stages:

        Clone Repository: Clone the Maven project from the GitHub repository.

        Build: Execute the Maven build process (mvn clean install).

        Test: Run unit tests as part of the Maven build.

        Archive Artifacts: Archive the build artifacts for future use.

![alt text](<Screenshot from 2024-07-31 15-19-12.png>)

![alt text](<Screenshot from 2024-07-31 15-19-22.png>)

Configure Pipeline Parameters

    Allow the pipeline to accept parameters such as Maven goals and options for flexibility.

    Ensure the pipeline can be easily modified for different build configurations.

![alt text](<Screenshot from 2024-07-31 15-13-19.png>)

![alt text](<Screenshot from 2024-07-31 15-13-41.png>)

Run the Pipeline

    Trigger the Jenkins pipeline job manually or set up a webhook for automatic triggering on GitHub repository changes.

![alt text](<Screenshot from 2024-07-31 15-12-37.png>)


    Monitor the build process through Jenkins' UI and console output.

Deliverables

    Jenkinsfile: A declarative pipeline script with the defined stages and steps.

    Jenkins Job Configuration: Configured Jenkins job that uses the Jenkinsfile from the GitHub repository.

    Build Artifacts: Successfully built and archived artifacts stored in Jenkins.

    Build Reports: Output of the build process, including unit test results, displayed in Jenkins.

    Pipeline Visualization: Visual representation of the pipeline stages and steps in Jenkins, showing the flow and status of each build 

![alt text](<Screenshot from 2024-07-31 15-23-04.png>)