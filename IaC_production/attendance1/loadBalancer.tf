# attendance-tg-s 타겟 그룹 생성
resource "aws_lb_target_group" "attendance-tg-s" {
  name     = "attendance-tg-s"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.attendanceVPC_s.id

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
resource "aws_lb" "attendance-alb-s" {
  name               = "attendance-alb-s"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.attendance_securityGroup_s.id]
  subnets            = [aws_subnet.Public_At_Entrance_s.id, aws_subnet.Public_At_Entrance2_s.id]

  tags = {
    Environment = "attendance-alb-s"
  }
}

# attendance-alb_listner 로드밸런서 리스너 생성
resource "aws_lb_listener" "attendance-alb_listner" {
  load_balancer_arn = aws_lb.attendance-alb-s.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.attendance-tg-s.arn
    }
  }

# attendance-svc-tg-s 타겟 그룹 생성
resource "aws_lb_target_group" "attendance-svc-tg-s" {
  name     = "attendance-svc-tg-s"
  port     = 80
  protocol = "TCP"
  target_type = "alb"
  vpc_id   = aws_vpc.attendanceVPC_s.id

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
resource "aws_lb" "attendance-Nlb-s" {
  name               = "attendance-Nlb-s"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.Public_At_Entrance_s.id, aws_subnet.Public_At_Entrance2_s.id]

  tags = {
    Environment = "attendance-Nlb-s"
  }
}

# attendance-Nlb_listner 로드밸런서 리스너 생성
resource "aws_lb_listener" "attendance-Nlb_listner" {
  load_balancer_arn = aws_lb.attendance-Nlb-s.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.attendance-svc-tg-s.arn
    }
  }

# attendance-alb-s 로드밸런서 attendance-svc-tg-s에 등록
  resource "aws_lb_target_group_attachment" "Nlb_attachment" {
  target_group_arn = aws_lb_target_group.attendance-svc-tg-s.arn
  target_id        = aws_lb.attendance-alb-s.id
  port             = 80
}