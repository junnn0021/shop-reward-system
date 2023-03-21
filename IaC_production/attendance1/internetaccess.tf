# 임시 탄력적 IP 생성
resource "aws_eip" "temporary_eip" {
  vpc      = true
  tags = {
    Name = "temporary_eip"
  }
}

# 임시 NAT Gateway 생성
resource "aws_nat_gateway" "temporary_nat_gateway" {
  allocation_id = aws_eip.temporary_eip.id
  subnet_id = aws_subnet.Public_At_Entrance_s.id
  
  tags = {
    Name = "temporary_nat_gateway"
  }
}
