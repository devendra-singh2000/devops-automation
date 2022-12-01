# Create docker image using Jenkins and deploy on AWS ECS
---
## Set up a build pipeline with Jenkins and Amazon ECS
- We’ll be using a sample Java application, available on GitHub. The repository contains a simple Dockerfile that uses a openjdk base image and runs our application: 
- This Dockerfile is used by the build pipeline to create a new Docker image. The built image will then be used to start a new service on an ECS cluster. 

#  Setup the build environment
- For our build environment we’ll launch an Amazon EC2 instance using the Amazon Linux AMI and install and configure the required packages. Make sure that the security group we select for our instance allows traffic on ports TCP/22, TCP/80 and TCP/8080.

#  Install and configure Jenkins, Docker and Nginx
- Connect to instance using private key and switch to the root user. First, let’s update the repositories and install Docker, Nginx and Git. 
1. yum update -y
2. yum install -y docker nginx git

-  To install Jenkins on Amazon Linux, we need to add the Jenkins repository and install Jenkins from there. 
1. wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
2. rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
3. yum install jenkins

- We’ll be using Jenkins to build our Docker images, so we need to add the jenkins user to the docker group. A reboot may be required for the changes to take effect.
-> usermod -a -G docker jenkins
-  Start the Docker, Jenkins and Nginx services and make sure they will be running after a reboot: 

---

#  Configure the Jenkins build

 On the Jenkins dashboard, click on New Item, select the Freestyle project job, add a name for the job, and click OK. Configure the Jenkins job:

    Under GitHub Project, add the path of  GitHub repository – e.g. https://github.com/devendra-singh2000/devops-automation.git. 
    In addition to the application source code, the repository contains the Dockerfile used to build the image, as explained at the beginning of this walkthrough. 

    Under Source Code Management provide the Repository URL for Git, e.g. https://github.com/devendra-singh2000/devops-automation.git.
    In the Build Triggers section, select Build when a change is pushed to GitHub.
    In the Build section, add a Docker build and publish step to the job and configure it to publish to your Docker registry repository (e.g. AWS ECR) and add a tag to identify the image (e.g. v_$BUILD_NUMBER). 

The Repository Name specifies the name of the AWS ECR repository where the image will be published; this is composed of a user name  and an image name . In our case, the Dockerfile sits in the root path of our repository, so we won’t specify any path in the Directory Dockerfile is in field. Note, the repository name needs to be the same as what is used in the task definition template. 






