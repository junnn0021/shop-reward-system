# VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "dynamoDB_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  service_name      = "com.amazonaws.ap-northeast-2.dynamodb"

  tags = {
    Name = "dynamoDB_endpoint"
  }
}

# routeTable_Entrance_s - VPC endpoint 연결
resource "aws_vpc_endpoint_route_table_association" "exadynamo_endpoint_association_service" {
  route_table_id  = aws_route_table.routeTable_Service_teamd.id
  vpc_endpoint_id = aws_vpc_endpoint.dynamoDB_endpoint.id
}

# vpc endpoint와 route table 연결
resource "aws_vpc_endpoint_route_table_association" "dynamo_endpoint_association_notification" {
  vpc_endpoint_id    = aws_vpc_endpoint.dynamoDB_endpoint.id
  route_table_id     = aws_route_table.routTable_Notification_priv_teamd.id
}

# vpc endpoint와 route table 연결
resource "aws_vpc_endpoint_route_table_association" "dynamo_endpoint_association_admin" {
  vpc_endpoint_id    = aws_vpc_endpoint.dynamoDB_endpoint.id
  route_table_id     = aws_route_table.routeTable_Admin_teamd.id
}

# S3 VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "S3_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "S3_endpoint"
  }
}

# routeTable_Entrance_s - S3 endpoint 연결
resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_association" {
  route_table_id  = aws_route_table.routeTable_Service_teamd.id
  vpc_endpoint_id = aws_vpc_endpoint.S3_endpoint.id
}

# secrets manager VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "secrets_manager_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  subnet_ids        = [aws_subnet.Private_At_Service_teamd.id, aws_subnet.Private_At_Service2_teamd.id]
  service_name      = "com.amazonaws.ap-northeast-2.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.attendance_securityGroup_teamd.id,
  ]

  private_dns_enabled = true
  
  tags = {
    Name = "secrets_manager_endpoint"
  }
}

# ecr_dkr VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  subnet_ids        = [aws_subnet.Private_At_Service_teamd.id, aws_subnet.Private_At_Service2_teamd.id]
  service_name      = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.attendance_securityGroup_teamd.id,
  ]

  private_dns_enabled = true
  tags = {
    Name = "ecr_dkr_endpoint"
  }
}

# cloudwatch_logs VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "cloudwatch_logs_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  subnet_ids        = [aws_subnet.Private_At_Service_teamd.id, aws_subnet.Private_At_Service2_teamd.id]
  service_name      = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.attendance_securityGroup_teamd.id,
  ]

  private_dns_enabled = true
  tags = {
    Name = "cloudwatch_logs_endpoint"
  }
}

# cloudwatch_logs VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  subnet_ids        = [ aws_subnet.Private_At_Service_teamd.id, aws_subnet.Private_At_Service2_teamd.id ]
  service_name      = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.attendance_securityGroup_teamd.id,
  ]

  private_dns_enabled = true
  tags = {
    Name = "ecr_api_endpoint"
  }
}

# SNS VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "sns_endpoint" {
  vpc_id            = aws_vpc.attendance_VPC.id
  subnet_ids        = [ aws_subnet.Private_At_Service_teamd.id, aws_subnet.Private_At_Service2_teamd.id ]
  service_name      = "com.amazonaws.ap-northeast-2.sns"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.attendance_securityGroup_teamd.id,
  ]

  private_dns_enabled = true
  tags = {
    Name = "sns_endpoint"
  }
}