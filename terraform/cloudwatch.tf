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
##################################################
# Register Event Log Group
##################################################

resource "aws_cloudwatch_log_group" "register_event" {

  name = "/aws/lambda/${aws_lambda_function.register_event.function_name}"

  retention_in_days = 14

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-register-event-logs"
      Type = "CloudWatch"
    }
  )
}
##################################################
# Get Registrations Log Group
##################################################

resource "aws_cloudwatch_log_group" "get_registrations" {

  name = "/aws/lambda/${aws_lambda_function.get_registrations.function_name}"

  retention_in_days = 14

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-get-registrations-logs"
      Type = "CloudWatch"
    }
  )
}
#Delete Registration Log Group
resource "aws_cloudwatch_log_group" "delete_registration" {

  name = "/aws/lambda/${aws_lambda_function.delete_registration.function_name}"

  retention_in_days = 14

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-delete-registration-logs"
      Type = "CloudWatch"
    }
  )
}