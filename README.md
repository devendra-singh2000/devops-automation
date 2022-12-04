# Docker image using Jenkins and deploy on AWS ECS
---
## Requirements
| Name  | Version |
| ------ | ------ |
| Jenkins | >=2.3 |
| JDK | >=11.0 |
| Terraform | >=4.0 |
| AWS | >=4.0 |
| Ubuntu | >=20.04 |
| Git | >= 2.25 |

##  Infrastructure Setup 
| Number | Name |
| ------ | ------|
| 1 | VPC |
| 1 | Public subnets |
| 1 | Load Balancer |

## Set up a build pipeline with Jenkins and Amazon ECS
- We’ll be using a sample Java application, available on GitHub. The repository contains a simple Dockerfile that uses a openjdk base image and runs our application: 
- This Dockerfile is used by the build pipeline to create a new Docker image. The built image will then be used to start a new service on an ECS cluster. 
## Providers
AWS

#  Setup the build environment
- For our build environment we’ll launch an Amazon EC2 instance using the Amazon Linux AMI and install and configure the required packages. Make sure that the security group we select for our instance allows traffic on ports TCP/22, TCP/80 and TCP/8080.

## Modules
| Name | Description |
| ------ | ------ |
| vpc | To create VPC for our infrastructure |
| elb | For load balancer|
| sg | Security groups |
| subnet | For creating subnet |

##   Resources 
| Name | Type |
|------|------|
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | data source |
| [aws_ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |


#  Install and configure Jenkins, Docker and Nginx
- Connect to instance using private key and switch to the root user. First, let’s update the repositories and install Docker, Nginx and Git. 
```sh
    1. yum update -y
    2. yum install -y docker nginx git
```
-  To install Jenkins on Amazon Linux, we need to add the Jenkins repository and install Jenkins from there. 
```sh
    1. wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    2. rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    3. yum install jenkins
```
- We’ll be using Jenkins to build our Docker images, so we need to add the jenkins user to the docker group. A reboot may be required for the changes to take effect.
```sh    
    usermod -a -G docker jenkins
```
-  Start the Docker, Jenkins and Nginx services and make sure they will be running after a reboot: 


#  Configure the Jenkins build
---
 On the Jenkins dashboard, click on New Item, select the pipeline project job, add a name for the job, and click OK. Configure the Jenkins job:
```sh
Under GitHub Project, add the path of  GitHub repository – e.g. https://github.com/devendra-singh2000/devops-automation.git. 
```
```sh
Select pipeline script from SCM
```


##  Deployment
First initialise the backend, and install the aws plugin and prepare terraform.:

```sh
terraform init
```

The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares:

```sh
terraform plan
```
The terraform apply command executes the actions proposed in a terraform plan
```sh
terraform apply
```

The terraform destroy command terminates resources managed by our Terraform project.
```sh
terraform destroy
```


## Author
----
Module managed by [Devendra Singh](https://github.com/devendra-singh2000)






