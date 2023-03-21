# ECR 생성
resource "aws_ecr_repository" "attendance_ecr" {
  name                 = "attendance_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# Secret Manager ARN 참조
data "aws_secretsmanager_secret" "access_data" {
  arn = aws_secretsmanager_secret.DynamoAccess_secrets.arn
}

# Task-definition 작성
resource "aws_ecs_task_definition" "attendance_task_definition_s" {
  family = "attendance_task_definition_s"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072
  task_role_arn = aws_iam_role.ecsTaskExecutionRole_s.arn
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole_s.arn
  container_definitions = jsonencode([
    {
      name      = "attendance_container_s"
      image     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}:latest"
      secrets = [
      {
        name  = "AWS_ACCESS_KEY_ID"
        valueFrom = "${data.aws_secretsmanager_secret.access_data.arn}:${var.KEY_ID}::"
      },
      {
        name  = "AWS_SECRET_ACCESS_KEY"
        valueFrom = "${data.aws_secretsmanager_secret.access_data.arn}:${var.SECRET_KEY}::"
      },
      ]
      environment = [
        {
        name  = "TOPICARN"
        value = "${aws_sns_topic.stock_notification_s.arn}"
      },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group = "true"
          awslogs-group = "/ecs/attendance_task_definition_s"
          awslogs-region = "${var.region}"
          awslogs-stream-prefix =  "ecs"
        }
      }
    
      cpu       = 0
      essential = true
      portMappings = [
        {
          name      = "attendance_container_s-3000-tcp"
          containerPort = 3000
          hostPort      = 3000
          appprotocol = "http"
        }
      ]
    }
  ])
 
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_cloudwatch_log_group" "attendance_ECS_logGroup" {
  name = "attendance_ECS_logGroup"
}

# kms 키 생성
resource "aws_kms_key" "ecsKms" {
  description             = "ecsKms"
  deletion_window_in_days = 7
}

# dns 네임스페이스 생성
resource "aws_service_discovery_private_dns_namespace" "Service_vpc_namespace" {
  name = "my-Service_vpc_namespace"
  description = "My private DNS namespace for Service Discovery"
  vpc = aws_vpc.attendanceVPC_s.id
}

# ECS 클러스터 생성
resource "aws_ecs_cluster" "attendance_ECS_s" {
  name = "attendance_ECS_s"

  configuration {
  execute_command_configuration {
    kms_key_id = aws_kms_key.ecsKms.arn
    logging    = "OVERRIDE"

  log_configuration {
    cloud_watch_encryption_enabled = true
    cloud_watch_log_group_name     = aws_cloudwatch_log_group.attendance_ECS_logGroup.name
      }
    }
  }
  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.Service_vpc_namespace.arn
  }
}

# ECS 서비스 생성
resource "aws_ecs_service" "attendance_svc_s" {
  name            = "attendance_svc_s"
  cluster         = aws_ecs_cluster.attendance_ECS_s.id
  task_definition = aws_ecs_task_definition.attendance_task_definition_s.arn
  desired_count   = 2  
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.attendance-tg-s.arn
    container_name   = "attendance_container_s"
    container_port   = 3000
  }
  
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  network_configuration {
    subnets          = [aws_subnet.Private_At_Service_s.id, aws_subnet.Private_At_Service2_s.id]
    assign_public_ip = false
    security_groups  = [aws_security_group.attendance_securityGroup_s.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# AutoScaling Target 생성
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.attendance_svc_s.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# AutoScaling Policy 생성
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "ecs-autoscaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.ecs_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.ecs_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.ecs_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    target_value       = 70
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
