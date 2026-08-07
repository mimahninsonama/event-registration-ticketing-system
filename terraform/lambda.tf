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