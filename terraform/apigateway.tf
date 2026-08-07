##################################################
# REST API
##################################################

resource "aws_api_gateway_rest_api" "event_api" {

  name = "${local.name_prefix}-api"

  description = "Serverless Event Registration API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-api"
      Type = "API Gateway"
    }
  )
}

##################################################
# /events Resource
##################################################

resource "aws_api_gateway_resource" "events" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_rest_api.event_api.root_resource_id

  path_part = "events"
}

##################################################
# GET /events
##################################################

resource "aws_api_gateway_method" "get_events" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.events.id

  http_method = "GET"

  authorization = "NONE"
}

##################################################
# Lambda Integration
##################################################

resource "aws_api_gateway_integration" "get_events" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.events.id

  http_method = aws_api_gateway_method.get_events.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.get_events.invoke_arn
}

##################################################
# Lambda Permission
##################################################

resource "aws_lambda_permission" "api_gateway" {

  statement_id = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.get_events.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.event_api.execution_arn}/*/*"
}
##################################################
# API Deployment
##################################################

resource "aws_api_gateway_deployment" "deployment" {

  depends_on = [
    aws_api_gateway_integration.get_events
  ]

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.events.id,
      aws_api_gateway_method.get_events.id,
      aws_api_gateway_integration.get_events.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
##################################################
# API Stage
##################################################

resource "aws_api_gateway_stage" "dev" {

  deployment_id = aws_api_gateway_deployment.deployment.id

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  stage_name = var.environment

  tags = local.common_tags
}