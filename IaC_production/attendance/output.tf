output "access_data" {
  value = data.aws_secretsmanager_secret.access_data.arn
}