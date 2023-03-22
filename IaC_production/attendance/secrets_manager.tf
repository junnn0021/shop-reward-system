resource "aws_secretsmanager_secret" "Dynamo_teamd_secrets" {
  name = "Dynamo_teamd_secrets"
  description = "DynamoDB 접근용 ACCESS KEY"
}

resource "aws_secretsmanager_secret_version" "DynamoDB_Access_version" {
  secret_id     = aws_secretsmanager_secret.Dynamo_teamd_secrets.id
  secret_string = jsonencode(var.AWS_ACCESS_KEY)
}
