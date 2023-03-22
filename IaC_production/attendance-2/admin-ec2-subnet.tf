# admin 프라이빗 서브넷 생성
resource "aws_subnet" "Private_At_Admin_j" {
  vpc_id     = aws_vpc.attendanceVPC_j.id
  cidr_block = var.Private_At_Admin_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Admin_j"
  }
}

# admin 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Admin_j" {
  vpc_id = aws_vpc.attendanceVPC_j.id

  tags = {
    Name = "routeTable_Admin_j"
  }
}

# admin 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Admin_association_j" {
  subnet_id      = aws_subnet.Private_At_Admin_j.id
  route_table_id = aws_route_table.routeTable_Admin_j.id
}

# vpc endpoint와 route table 연결
resource "aws_vpc_endpoint_route_table_association" "attendance_endpoint_association_j" {
  vpc_endpoint_id    = aws_vpc_endpoint.attendance_endpoint_j.id
  route_table_id     = aws_route_table.routeTable_Admin_j.id
}
