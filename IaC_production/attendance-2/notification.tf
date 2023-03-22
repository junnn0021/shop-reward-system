# PushAlertEmail 람다 생성
resource "aws_lambda_function" "Notification_j" {
  function_name = "Notification_j"
  filename      = "./notification.zip"
  role          = aws_iam_role.lambda_access_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  source_code_hash = filebase64sha256("./notification.zip")
  memory_size       = 2048
  timeout           = 10

  environment {
    variables = {
      SOURCEEMAIL = var.PushAlertEmail_env
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.Private_At_Notification_j.id]
    security_group_ids = [aws_security_group.Notification_sg_j.id]
  }
}

# PushAlertEmail 람다 IAM 역할 정의
resource "aws_iam_role" "lambda_access_role" {
  name = "lambda_access_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 정책 생성
resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = "arn:aws:dynamodb:ap-northeast-2:758733530144:table/user"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name = "lambda_logs_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:TagResource"
        ],
        Resource = [
          "arn:aws:logs:ap-northeast-2:758733530144:log-group:/aws/lambda/Notification_j*:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:ap-northeast-2:758733530144:log-group:/aws/lambda/Notification_j*:*:*"
        ]
      }
    ]
  })
}

# 정책 연결
resource "aws_iam_role_policy_attachment" "dynamodb_access_policy_attachment" {
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
  role       = aws_iam_role.lambda_access_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
  role = aws_iam_role.lambda_access_role.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_access_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_full_access_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.lambda_access_role.name
}

resource "aws_iam_role_policy_attachment" "ses_full_access_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.lambda_access_role.name
}

resource "aws_iam_role_policy_attachment" "vpc_cross_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCCrossAccountNetworkInterfaceOperations"
  role       = aws_iam_role.lambda_access_role.name
}