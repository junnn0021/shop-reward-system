// vpc 생성
resource "aws_vpc" "auth-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "authVpc_teamd"
  }
}

// igw Gataway 생성
resource "aws_internet_gateway" "auth-igw" {
  vpc_id = aws_vpc.auth-vpc.id
  tags = {
    Name = "auth_igw_teamd"
  }
}

// NAT Gateway 생성
resource "aws_nat_gateway" "auth-ngw" {
  allocation_id = aws_eip.auth-eip.id
  subnet_id = aws_subnet.auth-subnet-public1-ap-northeast-2a.id
  tags = {
  Name = "auth_ngw_teamd"
  }
}

// Elastic IP 생성
resource "aws_eip" "auth-eip" {
  vpc = true
  tags = {
  Name = "auth_eip_teamd"
  }
}

// 퍼블릭 서브넷 생성
resource "aws_subnet" "auth-subnet-public1-ap-northeast-2a" {
  vpc_id = aws_vpc.auth-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "auth_public1_teamd"
  }
}

// 퍼블릭 라우트 테이블 생성
resource "aws_route_table" "auth-rtb-public" {
  vpc_id = aws_vpc.auth-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.auth-igw.id
  }
  tags = {
    Name = "auth_rtb_public_teamd"
  }
}

// 퍼플릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "auth-rtb-public-subnet" {
  subnet_id = aws_subnet.auth-subnet-public1-ap-northeast-2a.id
  route_table_id = aws_route_table.auth-rtb-public.id
}

// 프라이빗 서브넷 생성
resource "aws_subnet" "auth-subnet-private1-ap-northeast-2a" {
  vpc_id = aws_vpc.auth-vpc.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "auth_private_teamd"
  }
}

// 프라이빗 라우트 테이블 생성
resource "aws_route_table" "auth-rtb-private" {
  vpc_id = aws_vpc.auth-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.auth-ngw.id
  }
  tags = {
    Name = "auth_rtb_private_teamd"
  }
}

// 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "auth-rtb-private-subnet" {
  subnet_id      = aws_subnet.auth-subnet-private1-ap-northeast-2a.id
  route_table_id = aws_route_table.auth-rtb-private.id
}