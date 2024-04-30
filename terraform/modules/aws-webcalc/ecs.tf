# Define the ECS cluster
resource "aws_ecs_cluster" "webcalc_cluster" {
  name = "webcalc-cluster"
}

# Define the ECS task definition
resource "aws_ecs_task_definition" "webcalc_task_definition" {
  family                   = "webcalc-task"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256" # CPU units (e.g., 256 = 0.25 vCPU)
  memory                   = "512" # Memory in MiB
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "webcalc-container"
      image     = "mytherapycoding/webcalc:latest"
      cpu       = 256
      memory    = 512
      essential = true
      command   = ["uvicorn", "main:app", "--reload", "--port", "80"]
      # Port mappings
      portMappings = [
        {
          containerPort = 80 # Port within the Docker container
          hostPort      = 80 # Port on the ECS container instance
          protocol      = "tcp"
        },
        # Add more port mappings as needed
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/api/health || exit 1"]
        interval    = 30 # Interval (in seconds) between health checks
        timeout     = 5  # Timeout (in seconds) for each health check
        retries     = 3  # Number of retries before considering the task unhealthy
        startPeriod = 60 # Time (in seconds) to wait before starting health checks
      }

      # Log configuration
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/webcalc-logs" # CloudWatch Logs group name
          "awslogs-region"        = "us-east-1"         # AWS region for CloudWatch Logs
          "awslogs-stream-prefix" = "webcalc" # Log stream prefix
        }
      }
    }
  ])
}


# Define the ECS service
resource "aws_ecs_service" "webcalc_service" {
  name            = "webcalc-service"
  cluster         = aws_ecs_cluster.webcalc_cluster.id
  task_definition = aws_ecs_task_definition.webcalc_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  # Add additional service configurations here...

  network_configuration {
    subnets          = [aws_subnet.private_subnet.id]  # Specify private subnet
    security_groups  = [aws_security_group.ecs_security_group.id]
    # assign_public_ip = "DISABLED"  # Set to "ENABLED" if public IP is needed
  }
}
