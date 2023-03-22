# KMS 키 생성
resource "aws_kms_key" "dynamodb_key" {
  description             = "KMS key for DynamoDB encryption"
  enable_key_rotation     = true
}

# user 테이블 생성
resource "aws_dynamodb_table" "user_teamd" {
  name              = "user_teamd"
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "email"
  deletion_protection_enabled = true

  server_side_encryption {
    enabled = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    name = "user_teamd"
  }
}

# reward 테이블 생성
resource "aws_dynamodb_table" "reward_teamd" {
  name              = "reward_teamd"
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "reward_number"
  deletion_protection_enabled = true

  server_side_encryption {
    enabled = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }

  attribute {
    name = "reward_number"
    type = "N"
  }

  tags = {
    name = "reward_teamd"
  }
}

# compensation 테이블 생성
resource "aws_dynamodb_table" "compensation_teamd" {
  name              = "compensation_teamd"
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "email"
  deletion_protection_enabled = true

  server_side_encryption {
    enabled = true
    kms_key_arn = aws_kms_key.dynamodb_key.arn
  }

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    name = "compensation_teamd"
  }
}