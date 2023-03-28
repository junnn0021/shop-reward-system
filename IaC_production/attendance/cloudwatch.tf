resource "aws_cloudwatch_metric_alarm" "ecs_health_check" {
  alarm_name          = "ecs-health-check-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors the ECS Health Check status check failures"
  dimensions = {
    ServiceName = "attendance_svc_teamd"
    ClusterName = "attendance_ECS_teamd"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_utilization" {
  alarm_name          = "ecs-cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors the ECS service CPU utilization"
  dimensions = {
    ServiceName = "attendance_svc_teamd"
    ClusterName = "attendance_ECS_teamd"
  }
}