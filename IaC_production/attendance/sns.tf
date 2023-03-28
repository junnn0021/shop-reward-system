resource "aws_sns_topic" "stock_notification_s" {
  name = "stock_notification_s"
}

resource "aws_sns_topic_subscription" "admin1_email_target" {
  topic_arn = aws_sns_topic.stock_notification_s.arn
  protocol  = "email"
  endpoint  = var.admin1
}

resource "aws_sns_topic_subscription" "admin2_email_target" {
  topic_arn = aws_sns_topic.stock_notification_s.arn
  protocol  = "email"
  endpoint  = var.admin2
}