#usr/bin/sh
echo sleep 600 && 

# 연결 완료 후 Nat Gateway 삭제 명령어 
terraform destroy -target=aws_nat_gateway.temporary_nat_gateway.id

# 연결 완료 후 eip 삭제 명령어
terraform destroy -target=aws_eip.temporary_eip
