# bastion host 보안 그룹 생성
resource "aws_security_group" "bastion_sg_teamd" {
    vpc_id = aws_vpc.attendance_VPC.id
    name = "bastion_sg_teamd"
    description = "bastion_sg_teamd"

    tags = {
        Name = "bastion_sg_teamd"
    }
}

# bastion host 보안 그룹 규칙
resource "aws_security_group_rule" "bastion_sg_rule_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "bastion_sg_rule_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "bastion_sg_rule_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "bastion_sg_rule_out" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

# Notification 보안 그룹 생성
resource "aws_security_group" "Notification_sg_teamd" {
    vpc_id = aws_vpc.attendance_VPC.id
    name = "Notification_sg_teamd"
    description = "Notification_sg_teamd"

    tags = {
        Name = "Notification_sg_teamd"
    }
}

# Notification 보안 그룹 규칙
resource "aws_security_group_rule" "Notification_sg_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_stmp_1" {
    type = "ingress"
    from_port = 25
    to_port = 25
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_stmp_2" {
    type = "ingress"
    from_port = 465
    to_port = 465
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_stmp_3" {
    type = "ingress"
    from_port = 587
    to_port = 587
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_stmp_4" {
    type = "ingress"
    from_port = 2465
    to_port = 2465
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_stmp_5" {
    type = "ingress"
    from_port = 2587
    to_port = 2587
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "Notification_sg_out" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_teamd.id
    lifecycle{
        create_before_destroy = true
    }
}

# Public 보안그룹 생성 (SSH, HTTP, busybox allow)
resource "aws_security_group" "attendance_securityGroup_teamd" {
  name        = "attendance_securityGroup_teamd"
  description = "attendance_securityGroup_teamd"
  vpc_id      = aws_vpc.attendance_VPC.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "busybox from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "attendance_securityGroup_teamd"
  }
}