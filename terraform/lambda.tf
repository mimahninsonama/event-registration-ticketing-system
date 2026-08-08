##################################################
# GET Events Lambda
##################################################

resource "aws_lambda_function" "get_events" {

  function_name = "${local.name_prefix}-get-events"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "get_events.lambda_function.lambda_handler"

  filename         = data.archive_file.get_events_zip.output_path
  source_code_hash = data.archive_file.get_events_zip.output_base64sha256

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      EVENTS_TABLE_NAME = aws_dynamodb_table.events.name
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-get-events"
      Type = "Lambda"
    }
  )
}
##################################################
# Register Event Lambda
##################################################

resource "aws_lambda_function" "register_event" {

  function_name = "${local.name_prefix}-register-event"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "register_event.lambda_function.lambda_handler"

  filename         = data.archive_file.register_event_zip.output_path
  source_code_hash = data.archive_file.register_event_zip.output_base64sha256

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      EVENTS_TABLE_NAME        = aws_dynamodb_table.events.name
      REGISTRATIONS_TABLE_NAME = aws_dynamodb_table.registrations.name
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-register-event"
      Type = "Lambda"
    }
  )
}
##################################################
# Get Registrations Lambda
##################################################

resource "aws_lambda_function" "get_registrations" {

  function_name = "${local.name_prefix}-get-registrations"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "get_registrations.lambda_function.lambda_handler"

  filename         = data.archive_file.get_registrations_zip.output_path
  source_code_hash = data.archive_file.get_registrations_zip.output_base64sha256

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      REGISTRATIONS_TABLE_NAME = aws_dynamodb_table.registrations.name
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-get-registrations"
      Type = "Lambda"
    }
  )
}
#Delete Registration Lambda
resource "aws_lambda_function" "delete_registration" {

  function_name = "${local.name_prefix}-delete-registration"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "delete_registration.lambda_function.lambda_handler"

  filename         = data.archive_file.delete_registration_zip.output_path
  source_code_hash = data.archive_file.delete_registration_zip.output_base64sha256

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      REGISTRATIONS_TABLE_NAME = aws_dynamodb_table.registrations.name
    }
  }
}