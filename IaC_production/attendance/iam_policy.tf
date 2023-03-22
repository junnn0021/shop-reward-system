resource "aws_iam_role_policy" "ecr_authtorizationken" {
  name = "ecr_authtorizationken"
  role = aws_iam_role.ecsTaskExecutionRole_teamd.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetAuthorizationToken",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_role_policy" "AWSRevokeOlderSessions" {
  name = "AWSRevokeOlderSessions"
  role = aws_iam_role.ecsTaskExecutionRole_teamd.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ],
            "Condition": {
                "DateLessThan": {
                    "aws:TokenIssueTime": "2023-03-19T08:18:26.567Z"
                }
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.ecsTaskExecutionRole_teamd.id
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.ecsTaskExecutionRole_teamd.id
}

resource "aws_iam_role_policy_attachment" "AmazonECS_FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.ecsTaskExecutionRole_teamd.id
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecsTaskExecutionRole_teamd.id
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecsTaskExecutionRole_teamd.id
}