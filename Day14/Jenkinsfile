pipeline {
    agent any
    environment {
        registry = 'docker.io'  
        registryCredential = 'docker-hub' 
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Amaan00101/training_day-14.git', branch: 'main'
            }
        }

        stage('build image') {
            steps{
                script{
                    docker.withRegistry('', registryCredential){
                        def customImage = docker.build("amaan00101/myjava-app:${env.BUILD_ID}")
                        customImage.push()


                    }

                }
            }
        }

        stage('Deploy Container') {
            steps {

                script {
                    docker.withRegistry('', registryCredential) {
                        def runContainer = docker.image("amaan00101/myjava-app:${env.BUILD_ID}").run('--name mynew-container -d')
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
