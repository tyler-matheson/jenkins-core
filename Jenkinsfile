pipeline {
    agent any

    stages {
        stage('Build') {
            steps { // Restricted agent for r10k
                echo "Starting Build stage..."

                // Clear the workspace
                deleteDir()
                
                // DEBUG: view environment variables
                //sh 'env | sort'

                echo "Running Build Script..."
                sh '/bin/bash scripts/build.sh'
                
                echo "End of Build stage."
            }
        }

        stage('Deploy') {
            steps { // Restricted agent with S3 permissions for build artefact
                echo "Starting Deploy stage..."
                echo "This is build #${env.BUILD_NUMBER} of branch ${env.BRANCH_NAME}"

                // Clear the workspace
                deleteDir()

                // DEBUG: view environment variables
                //sh 'env | sort'

                checkout scm

                sh '/bin/bash scripts/deploy.sh'
            
                echo 'End of Build stage.'
            }
        }

        stage('Deployed') {
            steps {
                input('Do you want to proceed?')
            }
        }
    }
}