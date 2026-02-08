# aws-training-ci-cd-project

A simple web application demonstrating CI/CD pipeline with Docker, Jenkins, and AWS services.

## Project Structure

- `index.html` - Simple HTML web page
- `Dockerfile` - Docker configuration to containerize the application using nginx
- `Jenkinsfile` - Jenkins pipeline for CI/CD deployment to AWS
- `.dockerignore` - Files to exclude from Docker build context

## Local Development

### Build Docker Image
```bash
docker build -t aws-training-app .
```

### Run Locally
```bash
docker run -d -p 8080:80 aws-training-app
```

Access the application at: http://localhost:8080

### Stop Container
```bash
docker stop <container-id>
```

## CI/CD Pipeline

The Jenkinsfile defines a complete CI/CD pipeline with the following stages:

1. **Checkout** - Pull code from repository
2. **Build** - Build Docker image
3. **Test** - Run automated tests on the Docker container
4. **Push to ECR** - Push image to AWS Elastic Container Registry
5. **Deploy** - Deploy to AWS (ECS/EKS/EC2/Elastic Beanstalk)

### Prerequisites

To use the Jenkins pipeline, configure:
- Jenkins credentials for ECR registry
- AWS CLI installed on Jenkins agent
- AWS credentials configured
- Target deployment service (ECS cluster/service, etc.)

### Environment Variables

Update the following in Jenkinsfile:
- `AWS_REGION` - Your AWS region
- `ECR_REPOSITORY` - Your ECR repository name
- Deployment configuration in the Deploy stage

## Deployment Options

The pipeline supports multiple AWS deployment targets:
- **Amazon ECS** - Container orchestration
- **Amazon EKS** - Kubernetes on AWS
- **Amazon EC2** - Direct instance deployment
- **Elastic Beanstalk** - Platform as a Service

Customize the Deploy stage in Jenkinsfile based on your target service.