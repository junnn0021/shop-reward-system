# bastion host 보안 그룹 생성
resource "aws_security_group" "bastion_sg_j" {
    vpc_id = aws_vpc.attendanceVPC_j.id
    name = "bastion_sg_j"
    description = "bastion_sg_j"

    tags = {
        Name = "bastion_sg_j"
    }
}

# bastion host 보안 그룹 규칙
resource "aws_security_group_rule" "bastion_sg_rule_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.bastion_sg_j.id
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
    security_group_id = aws_security_group.bastion_sg_j.id
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
    security_group_id = aws_security_group.bastion_sg_j.id
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
    security_group_id = aws_security_group.bastion_sg_j.id
    lifecycle{
        create_before_destroy = true
    }
}

# Notification 보안 그룹 생성
resource "aws_security_group" "Notification_sg_j" {
    vpc_id = aws_vpc.attendanceVPC_j.id
    name = "Notification_sg_j"
    description = "Notification_sg_j"

    tags = {
        Name = "Notification_sg_j"
    }
}

# Notification 보안 그룹 규칙
resource "aws_security_group_rule" "Notification_sg_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
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
    security_group_id = aws_security_group.Notification_sg_j.id
    lifecycle{
        create_before_destroy = true
    }
}