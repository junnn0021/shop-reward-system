# admin 프라이빗 서브넷 생성
resource "aws_subnet" "Private_At_Admin_teamd" {
  vpc_id     = aws_vpc.attendance_VPC.id
  cidr_block = var.Private_At_Admin_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Admin_teamd"
  }
}

# admin 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Admin_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id

  tags = {
    Name = "routeTable_Admin_teamd"
  }
}

# admin 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Admin_association_teamd" {
  subnet_id      = aws_subnet.Private_At_Admin_teamd.id
  route_table_id = aws_route_table.routeTable_Admin_teamd.id
}

# bastion host 퍼블릭 서브넷 생성
resource "aws_subnet" "Public_At_Bastion_teamd" {
  vpc_id     = aws_vpc.attendance_VPC.id
  cidr_block = var.Public_At_Bastion_cidr_block
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_At_Bastion_teamd"
  }
}

# bastion host 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Bastion_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_teamd.id
  }

  tags = {
    Name = "routeTable_Bastion_teamd"
  }
}

# bastion host 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Bastion_association_teamd" {
  subnet_id      = aws_subnet.Public_At_Bastion_teamd.id
  route_table_id = aws_route_table.routeTable_Bastion_teamd.id
}



# Notification 퍼블릭 서브넷 생성
resource "aws_subnet" "Public_At_Notification_teamd" {
  vpc_id     = aws_vpc.attendance_VPC.id
  cidr_block = var.Public_At_Notification_cidr_block
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_At_Notification_teamd"
  }
}

# Notification 프라이빗 서브넷 생성
resource "aws_subnet" "Private_At_Notification_teamd" {
  vpc_id     = aws_vpc.attendance_VPC.id
  cidr_block = var.Private_At_Notification_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Notification_teamd"
  }
}

# Notification 퍼블릭 라우팅 테이블 생성
resource "aws_route_table" "routeTable_Notification_Pub_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_teamd.id
  }

  tags = {
    Name = "routeTable_Notification_Pub_teamd"
  }
}

# Notification 퍼블릭 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Notification_Pub_association_teamd" {
  subnet_id      = aws_subnet.Public_At_Notification_teamd.id
  route_table_id = aws_route_table.routeTable_Notification_Pub_teamd.id
}

# EIP 생성
resource "aws_eip" "Notification_eip_teamd" {
  vpc = true
  tags = {
    Name = "Notification_eip_teamd"
  }
}

# Notification NAT 생성
resource "aws_nat_gateway" "Notification_NAT_gateway_teamd" {
  allocation_id = aws_eip.Notification_eip_teamd.id
  subnet_id     = aws_subnet.Public_At_Notification_teamd.id
  tags = {
    Name = "Notification_NAT_gateway_teamd"
  }
}

# Notification 라우팅 테이블 생성
resource "aws_route_table" "routTable_Notification_priv_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Notification_NAT_gateway_teamd.id
  }

  tags = {
    Name = "routTable_Notification_priv_teamd"
  }
}

# Notification 라우팅 테이블 연결
resource "aws_route_table_association" "routeTable_Notification_priv_association_teamd" {
  subnet_id      = aws_subnet.Private_At_Notification_teamd.id
  route_table_id = aws_route_table.routTable_Notification_priv_teamd.id
}

# Public_At_Entrance 서브넷 생성
resource "aws_subnet" "Public_At_Entrance_teamd" {
  vpc_id            = aws_vpc.attendance_VPC.id
  cidr_block        = var.Entrance_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Public_At_Entrance_teamd"
  }
}

# Public_At_Entrance2 서브넷 생성
resource "aws_subnet" "Public_At_Entrance2_teamd" {
  vpc_id            = aws_vpc.attendance_VPC.id
  cidr_block        = var.Entrance_cidr_block2
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Public_At_Entrance2_teamd"
  }
}

# Private_At_Service 서브넷 생성
resource "aws_subnet" "Private_At_Service_teamd" {
  vpc_id            = aws_vpc.attendance_VPC.id
  cidr_block        = var.Service_cidr_block
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Private_At_Service_teamd"
  }
}

# Private_At_Service2 서브넷 생성
resource "aws_subnet" "Private_At_Service2_teamd" {
  vpc_id            = aws_vpc.attendance_VPC.id
  cidr_block        = var.Service_cidr_block2
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Private_At_Service2_teamd"
  }
}

# routeTable_Entrance_s 생성
resource "aws_route_table" "routeTable_Entrance_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Entrance_igw_teamd.id
  }

  tags = {
    Name = "routeTable_Entrance_teamd"
  }
}

# 라우팅 테이블 - 서브넷 Public_At_Entrance_s 연결
resource "aws_route_table_association" "Connect_rt_PublicEnt" {
  subnet_id      = aws_subnet.Public_At_Entrance_teamd.id
  route_table_id = aws_route_table.routeTable_Entrance_teamd.id
}

# 라우팅 테이블 - 서브넷 Public_At_Entrance2_s 연결
resource "aws_route_table_association" "Connect_rt_PublicEnt2" {
  subnet_id      = aws_subnet.Public_At_Entrance2_teamd.id
  route_table_id = aws_route_table.routeTable_Entrance_teamd.id
}

# routeTable_Service_s 생성
resource "aws_route_table" "routeTable_Service_teamd" {
  vpc_id = aws_vpc.attendance_VPC.id
  
  tags = {
    Name = "routeTable_Service_teamd"
  }
}

# 라우팅 테이블 - 서브넷 Private_At_Service_s 연결
resource "aws_route_table_association" "Connect_rt_PrivateSer" {
  subnet_id      = aws_subnet.Private_At_Service_teamd.id
  route_table_id = aws_route_table.routeTable_Service_teamd.id
}

# 라우팅 테이블 - 서브넷 Private_At_Service2_s 연결
resource "aws_route_table_association" "Connect_rt_PrivateSer2" {
  subnet_id      = aws_subnet.Private_At_Service2_teamd.id
  route_table_id = aws_route_table.routeTable_Service_teamd.id
}

