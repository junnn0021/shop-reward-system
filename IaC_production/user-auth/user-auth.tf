// user-auth-dev-auth lambda 권한
resource "aws_iam_role" "user_auth_role" {
  name = "user_auth_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// user-auth-dev-auth lambda 생성
resource "aws_lambda_function" "user_auth" {
  function_name = "user_auth_teamd"
  handler = "index.auth"
  runtime = "nodejs14.x"
  filename = "./user-auth.zip"
  role = aws_iam_role.user_auth_role.arn
  source_code_hash = filebase64sha256("./user-auth.zip")
  memory_size       = 2048
  timeout           = 10

  // subnet 과 보안그룹 연결
  vpc_config {
    subnet_ids = [aws_subnet.auth-subnet-private1-ap-northeast-2a.id]
    security_group_ids = [aws_security_group.auth-security-soobin.id]
  }

  // lambda 에서 쓰는 환경변수
  environment {
    variables = {
      USERPOOL= var.USERPOOL
      rds_db_name = var.rds_db_name
      rds_host = var.rds_host
      rds_password = var.rds_password
      rds_user = var.rds_user
    }
  }
}

// user-auth-dev-purchase lambda  권한 추가

resource "aws_iam_role_policy_attachment" "user_auth_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy5" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy6" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy7" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCCrossAccountNetworkInterfaceOperations"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_role_policy_attachment" "user-auth-lambda-auth-policy8" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.user_auth_role.name
}

resource "aws_iam_policy" "lambda_logs_policy_1" {
  name = "lambda_logs_policy_1"
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
          "arn:aws:logs:ap-northeast-2:758733530144:log-group:/aws/lambda/user_auth_teamd*:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:ap-northeast-2:758733530144:log-group:/aws/lambda/user_auth_teamd*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment_1" {
  policy_arn = aws_iam_policy.lambda_logs_policy_1.arn
  role = aws_iam_role.user_auth_role.name
}

resource "aws_lambda_permission" "apigw_auth_ambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_auth.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:ap-northeast-2:758733530144:${aws_api_gateway_rest_api.please.id}/*/*${aws_api_gateway_resource.auth_resource.path}"
}