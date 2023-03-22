# bastion host 퍼블릭 서브넷 생성
resource "aws_subnet" "Public_At_Bastion_j" {
  vpc_id     = aws_vpc.attendanceVPC_j.id
  cidr_block = var.Public_At_Bastion_cidr_block
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_At_Bastion_j"
  }
}

# bastion host IGW 생성
resource "aws_internet_gateway" "Entrance_igw_j" {
  vpc_id = aws_vpc.attendanceVPC_j.id

  tags = {
    Name = "Entrance_igw_j"
  }
}

# bastion host 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Bastion_j" {
  vpc_id = aws_vpc.attendanceVPC_j.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_j.id
  }

  tags = {
    Name = "routeTable_Bastion_j"
  }
}

# bastion host 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Bastion_association_j" {
  subnet_id      = aws_subnet.Public_At_Bastion_j.id
  route_table_id = aws_route_table.routeTable_Bastion_j.id
}