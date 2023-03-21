# attendanceVPC 생성
resource "aws_vpc" "attendanceVPC_s" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "attendanceVPC_s"}
}

# Public_At_Entrance 서브넷 생성
resource "aws_subnet" "Public_At_Entrance_s" {
  vpc_id            = aws_vpc.attendanceVPC_s.id
  cidr_block        = var.Entrance_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Public_At_Entrance_s"
  }
}

# Public_At_Entrance2_s 서브넷 생성
resource "aws_subnet" "Public_At_Entrance2_s" {
  vpc_id            = aws_vpc.attendanceVPC_s.id
  cidr_block        = var.Entrance_cidr_block2
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Public_At_Entrance2_s"
  }
}

# Private_At_Service_s 서브넷 생성
resource "aws_subnet" "Private_At_Service_s" {
  vpc_id            = aws_vpc.attendanceVPC_s.id
  cidr_block        = var.Service_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Service_s"
  }
}

# Private_At_Service2_s 서브넷 생성
resource "aws_subnet" "Private_At_Service2_s" {
  vpc_id            = aws_vpc.attendanceVPC_s.id
  cidr_block        = var.Service_cidr_block2
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Private_At_Service2_s"
  }
}

# Entrance_igw_s 생성
resource "aws_internet_gateway" "Entrance_igw_s" {
  vpc_id = aws_vpc.attendanceVPC_s.id

  tags = {
    Name = "Entrance_igw_s"
  }
}

# routeTable_Entrance_s 생성
resource "aws_route_table" "routeTable_Entrance_s" {
  vpc_id = aws_vpc.attendanceVPC_s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_s.id
  }

  tags = {
    Name = "routeTable_Entrance_s"
  }
}

# 라우팅 테이블 - 서브넷 Public_At_Entrance_s 연결
resource "aws_route_table_association" "Connect_rt_PublicEnt" {
  subnet_id      = aws_subnet.Public_At_Entrance_s.id
  route_table_id = aws_route_table.routeTable_Entrance_s.id
}

# 라우팅 테이블 - 서브넷 Public_At_Entrance2_s 연결
resource "aws_route_table_association" "Connect_rt_PublicEnt2" {
  subnet_id      = aws_subnet.Public_At_Entrance2_s.id
  route_table_id = aws_route_table.routeTable_Entrance_s.id
}

# VPC 엔드포인트 생성
resource "aws_vpc_endpoint" "attendance_endpoint_s" {
  vpc_id            = aws_vpc.attendanceVPC_s.id
  service_name      = "com.amazonaws.ap-northeast-2.dynamodb"

  tags = {
    Name = "attendance_endpoint_s"
  }
}

# routeTable_Service_s 생성
resource "aws_route_table" "routeTable_Service_s" {
  vpc_id = aws_vpc.attendanceVPC_s.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.temporary_nat_gateway.id
  }
  tags = {
    Name = "routeTable_Service_s"
  }
}

# routeTable_Entrance_s - VPC endpoint 연결
resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.routeTable_Service_s.id
  vpc_endpoint_id = aws_vpc_endpoint.attendance_endpoint_s.id
}

# 라우팅 테이블 - 서브넷 Private_At_Service_s 연결
resource "aws_route_table_association" "Connect_rt_PrivateSer" {
  subnet_id      = aws_subnet.Private_At_Service_s.id
  route_table_id = aws_route_table.routeTable_Service_s.id
}

# 라우팅 테이블 - 서브넷 Private_At_Service2_s 연결
resource "aws_route_table_association" "Connect_rt_PrivateSer2" {
  subnet_id      = aws_subnet.Private_At_Service2_s.id
  route_table_id = aws_route_table.routeTable_Service_s.id
}

