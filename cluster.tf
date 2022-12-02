resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.ProjectVpc.id
  cidr_block             = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_ecs_cluster" "foo" {
  name = "white-hart"

}
//ddddd
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}



resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello-world-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<DEFINITION
[
  {
    "image":  "749177923916.dkr.ecr.us-east-1.amazonaws.com/demo-app:java_app-build-23",
    "cpu": 1024,
    "memory": 2048,
    "name": "hello-world-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}
resource "aws_security_group" "hello_world_task" {
  name        = "example-task-security-group"
  vpc_id      = aws_vpc.ProjectVpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_ecs_service" "hello_world" { 
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.hello_world_task.id]
    subnets         = aws_subnet.PublicSubnet.*.id
    assign_public_ip = true

  
}

}
# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.ProjectVpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

 
# }
resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.ProjectVpc.default_route_table_id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  }
}