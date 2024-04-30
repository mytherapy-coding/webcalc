# Define the IAM role for ECS task execution
resource "aws_iam_role" "task_execution_role" {
  name = "webcalc-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "webcalc-task-execution-role"
  }
}