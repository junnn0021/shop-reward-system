# EventBridge 규칙 생성
resource "aws_cloudwatch_event_rule" "notification_event_rule" {
  name        = "notification_event_rule"
  description = "EventBridge rule to trigger Lambda function daily at 00:00"
  schedule_expression = "cron(0 0 * * ? *)"
}

# 권한 부여
resource "aws_lambda_permission" "eventbridge_permission" {
statement_id = "AllowExecutionFromCloudWatch"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.Notification_j.function_name
principal = "events.amazonaws.com"
source_arn = aws_cloudwatch_event_rule.notification_event_rule.arn
}

# 트리거 구성
resource "aws_cloudwatch_event_target" "notification_event_target" {
target_id = "notification_event_target"
rule = aws_cloudwatch_event_rule.notification_event_rule.name
arn = aws_lambda_function.Notification_j.arn
}