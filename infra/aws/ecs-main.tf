resource "aws_ecs_cluster" "ecs_cluster" {
  name = "prod"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "clientes-api-service"
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  cluster         = aws_ecs_cluster.ecs_cluster.id
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "clientes-api"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition
    ]
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-sg"
  description = "Sg para ecs"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Permitindo trafego apenas do SG do LB
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "clientes-api"
      image     = "${aws_ecr_repository.api-repo.repository_url}:latest"
      cpu       = 512
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

