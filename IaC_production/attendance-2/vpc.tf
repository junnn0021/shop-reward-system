# VPC 생성
resource "aws_vpc" "attendanceVPC_j" {
  cidr_block       = var.attendanceVPC_cidr_block

  tags = {
    Name = "attendanceVPC_j"
  }
}