# bastion host EC2 생성
resource "aws_instance" "bastion_ec2_teamd" {
    ami = "ami-030e520ec063f6467"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.bastion_sg_teamd.id]
    subnet_id = aws_subnet.Public_At_Bastion_teamd.id
    key_name = "bastion-ec2-key"
    associate_public_ip_address = "true"
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y openssh-server
        systemctl start sshd
        systemctl enable sshd
        EOF

    tags ={ 
	    Name = "bastion_ec2_teamd"
    }
}