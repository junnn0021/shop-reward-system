resource "aws_secretsmanager_secret" "Dynamo_secrets_key" {
  name = "Dynamo_secrets_key"
  description = "DynamoDB 접근용 ACCESS KEY"
}

resource "aws_secretsmanager_secret_version" "DynamoDB_Access_version" {
  secret_id     = aws_secretsmanager_secret.Dynamo_secrets_key.id
  secret_string = jsonencode(var.AWS_ACCESS_KEY)
}
