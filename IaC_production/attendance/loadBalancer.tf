# attendance-tg-s 타겟 그룹 생성
resource "aws_lb_target_group" "attendanceTg-teamd" {
  name     = "attendanceTg-teamd"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.attendance_VPC.id

  health_check {
    enabled = true
    healthy_threshold = 5
    interval = 30
    matcher = "200-399"
    path = var.healthcheck_path
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }
}

# attendance-alb-s 로드밸런서 생성
resource "aws_lb" "attendanceAlb-teamd" {
  name               = "attendanceAlb-teamd"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.attendance_securityGroup_teamd.id]
  subnets            = [aws_subnet.Public_At_Entrance_teamd.id, aws_subnet.Public_At_Entrance2_teamd.id]

  tags = {
    Environment = "attendanceAlb-teamd"
  }
}

# attendance-alb_listner 로드밸런서 리스너 생성
resource "aws_lb_listener" "attendanceAlb-teamd_listner" {
  load_balancer_arn = aws_lb.attendanceAlb-teamd.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.attendanceTg-teamd.arn
    }
  }

# attendance-svc-tg-s 타겟 그룹 생성
resource "aws_lb_target_group" "attendanceSvcTg-teamd" {
  name     = "attendanceSvcTg-teamd"
  port     = 80
  protocol = "TCP"
  target_type = "alb"
  vpc_id   = aws_vpc.attendance_VPC.id

  health_check {
    enabled = true
    healthy_threshold = 5
    interval = 30
    matcher = "200-399"
    path = var.healthcheck_path
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }
}

# attendance-Nlb-s 로드밸런서 생성
resource "aws_lb" "attendanceNlb-teamd" {
  name               = "attendanceNlb-teamd"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.Public_At_Entrance_teamd.id, aws_subnet.Public_At_Entrance2_teamd.id]

  tags = {
    Environment = "attendanceNlb-teamd"
  }
}

# attendance-Nlb_listner 로드밸런서 리스너 생성
resource "aws_lb_listener" "attendanceNlb-teamd_listner" {
  load_balancer_arn = aws_lb.attendanceNlb-teamd.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.attendanceSvcTg-teamd.arn
    }
  }

# attendanceAlb 로드밸런서 attendanceSvcTg-teamd에 등록
  resource "aws_lb_target_group_attachment" "Nlb_attachment" {
  target_group_arn = aws_lb_target_group.attendanceSvcTg-teamd.arn
  target_id        = aws_lb.attendanceAlb-teamd.id
  port             = 80
}