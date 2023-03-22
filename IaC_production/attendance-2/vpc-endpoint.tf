# vpc endpoint 생성
resource "aws_vpc_endpoint" "attendance_endpoint_j" {
  vpc_id              = aws_vpc.attendanceVPC_j.id
  service_name        = "com.amazonaws.ap-northeast-2.dynamodb"
  vpc_endpoint_type   = "Gateway"
}
