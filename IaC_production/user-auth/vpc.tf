// vpc 생성
resource "aws_vpc" "auth-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "auth-vpcsoobin"
  }
}

// igw Gataway 생성
resource "aws_internet_gateway" "auth-igw" {
  vpc_id = aws_vpc.auth-vpc.id
  tags = {
    Name = "auth-igwsoobin"
  }
}

// NAT Gateway 생성
resource "aws_nat_gateway" "auth-ngw" {
  allocation_id = aws_eip.auth-eip.id
  subnet_id = aws_subnet.auth-subnet-public1-ap-northeast-2a.id
  tags = {
  Name = "auth-ngwsoobin"
  }
}

// Elastic IP 생성
resource "aws_eip" "auth-eip" {
  vpc = true
}

// 퍼블릭 서브넷 생성
resource "aws_subnet" "auth-subnet-public1-ap-northeast-2a" {
  vpc_id = aws_vpc.auth-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "auth-subnet-public1-ap-northeast-2asoobin"
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
    Name = "auth-rtb-publicsoobin"
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
    Name = "auth-subnet-private1-ap-northeast-2asoobin"
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
    Name = "auth-rtb-privatesoobin"
  }
}

// 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "auth-rtb-private-subnet" {
  subnet_id      = aws_subnet.auth-subnet-private1-ap-northeast-2a.id
  route_table_id = aws_route_table.auth-rtb-private.id
}