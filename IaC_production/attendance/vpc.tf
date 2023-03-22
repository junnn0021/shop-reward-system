# VPC 생성
resource "aws_vpc" "attendance_VPC" {
  cidr_block       = var.attendanceVPC_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_network_address_usage_metrics = true

  tags = {
    Name = "attendance_VPC"
  }
}

