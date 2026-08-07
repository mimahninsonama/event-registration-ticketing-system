##################################################
# CloudWatch Log Group
##################################################

resource "aws_cloudwatch_log_group" "get_events" {

  name = "/aws/lambda/${aws_lambda_function.get_events.function_name}"

  retention_in_days = 14

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-get-events-logs"
      Type = "CloudWatch"
    }
  )
}