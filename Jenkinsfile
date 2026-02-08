pipeline {
    agent any
    
    environment {
        // AWS Configuration
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = credentials('ecr-registry')
        ECR_REPOSITORY = 'aws-training-ci-cd-project'
        IMAGE_TAG = "bigbadwolf-${env.BUILD_NUMBER}"
        
        // Docker Configuration
        DOCKER_IMAGE = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        DOCKER_IMAGE_LATEST = "${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code checked out successfully'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    sh 'docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE_LATEST}'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    // Test if the image can be run
                    sh '''
                        TEST_CONTAINER="test-container-${BUILD_NUMBER}"
                        docker run -d --name ${TEST_CONTAINER} -p 8080:80 ${DOCKER_IMAGE}
                        sleep 5
                        curl -f http://localhost:8080 || exit 1
                        docker stop ${TEST_CONTAINER}
                        docker rm ${TEST_CONTAINER}
                    '''
                    echo 'Tests passed successfully'
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    echo 'Logging into AWS ECR...'
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    '''
                    
                    echo 'Pushing Docker image to ECR...'
                    sh 'docker push ${DOCKER_IMAGE}'
                    sh 'docker push ${DOCKER_IMAGE_LATEST}'
                    echo 'Docker image pushed successfully'
                }
            }
        }
        
        stage('Deploy to AWS') {
            steps {
                script {
                    echo 'Deploying to AWS...'
                    // This can be customized based on deployment target:
                    // - ECS: Update ECS service
                    // - EKS: Update Kubernetes deployment
                    // - EC2: Deploy via CodeDeploy
                    // - Elastic Beanstalk: Deploy new version
                    
                    // Example: Update ECS service
                    sh '''
                        aws ecs update-service \
                            --cluster training-cluster \
                            --service training-service \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                    '''
                    echo 'Deployment completed successfully'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
            // You can add notification here (e.g., Slack, email)
        }
        failure {
            echo 'Pipeline failed!'
            // You can add notification here (e.g., Slack, email)
        }
        always {
            // Cleanup - remove only the images built in this pipeline
            sh '''
                docker rmi ${DOCKER_IMAGE} || true
                docker rmi ${DOCKER_IMAGE_LATEST} || true
            '''
        }
    }
}
