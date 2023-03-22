# Notification 퍼블릭 서브넷 생성
resource "aws_subnet" "Public_At_Notification_j" {
  vpc_id     = aws_vpc.attendanceVPC_j.id
  cidr_block = var.Public_At_Notification_cidr_block
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_At_Notification_j"
  }
}

# Notification 프라이빗 서브넷 생성
resource "aws_subnet" "Private_At_Notification_j" {
  vpc_id     = aws_vpc.attendanceVPC_j.id
  cidr_block = var.Private_At_Notification_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Notification_j"
  }
}

# Notification 퍼블릭 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Notification_Pub_j" {
  vpc_id = aws_vpc.attendanceVPC_j.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_j.id
  }

  tags = {
    Name = "routeTable_Notification_Pub_j"
  }
}

# Notification 퍼블릭 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Notification_Pub_association_j" {
  subnet_id      = aws_subnet.Public_At_Notification_j.id
  route_table_id = aws_route_table.routeTable_Notification_Pub_j.id
}

# EIP 생성
resource "aws_eip" "Notification_eip_j" {
  vpc = true
}

# Notification NAT 생성
resource "aws_nat_gateway" "Notification_NAT_gateway_j" {
  allocation_id = aws_eip.Notification_eip_j.id
  subnet_id     = aws_subnet.Public_At_Notification_j.id
}

# Notification 라우팅 테이블 생성
resource "aws_route_table" "routTable_Notification_j" {
  vpc_id = aws_vpc.attendanceVPC_j.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Notification_NAT_gateway_j.id
  }

  tags = {
    Name = "routTable_Notification_j"
  }
}

# Notification 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Notification_association_j" {
  subnet_id      = aws_subnet.Private_At_Notification_j.id
  route_table_id = aws_route_table.routTable_Notification_j.id
}

# vpc endpoint와 route table 연결
resource "aws_vpc_endpoint_route_table_association" "attendance_endpoint_association_2_j" {
  vpc_endpoint_id    = aws_vpc_endpoint.attendance_endpoint_j.id
  route_table_id     = aws_route_table.routTable_Notification_j.id
}
