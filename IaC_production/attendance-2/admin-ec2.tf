# admin EC2 생성
resource "aws_instance" "admin_ec2_j" {
    ami = "ami-030e520ec063f6467"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.bastion_sg_j.id]
    subnet_id = aws_subnet.Private_At_Admin_j.id
    key_name = "admin-key"
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y openssh-server
        systemctl start sshd
        systemctl enable sshd
        EOF

    tags ={ 
	    Name = "admin_ec2_j"
    }
}