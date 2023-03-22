# Secret Manager 주의 사항
- sercret manager 보안암호는 destroy시 30일 경과 후에 삭제되기에 apply전 반드시 보안암호의 이름을 변경 후 올릴것

  - ### 변경되어야 할 부분
   - secrets_manager.tf : resource "aws_secretsmanager_secret"
   - secrets_manager.tf : resource "aws_secretsmanager_secret_version"
   - attendanceECS.tf : data "aws_secretsmanager_secret"