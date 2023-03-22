# attendance_VPC IGW 생성
resource "aws_internet_gateway" "Entrance_igw_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id

  tags = {
    Name = "Entrance_igw_teamd"
  }
}