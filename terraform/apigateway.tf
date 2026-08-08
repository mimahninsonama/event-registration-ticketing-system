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
# Enable CORS
##################################################

module "events_cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.event_api.id
  api_resource_id = aws_api_gateway_resource.events.id
}

module "register_cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.event_api.id
  api_resource_id = aws_api_gateway_resource.register.id
}

module "registrations_cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.event_api.id
  api_resource_id = aws_api_gateway_resource.registrations_email.id
}

module "registration_cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.event_api.id
  api_resource_id = aws_api_gateway_resource.registration_id.id
}
##################################################
# API Deployment
##################################################

resource "aws_api_gateway_deployment" "deployment" {

  depends_on = [
    aws_api_gateway_integration.get_events,
    aws_api_gateway_integration.register_event,
    aws_api_gateway_integration.get_registrations,
    aws_api_gateway_integration.delete_registration,

    module.events_cors,
    module.register_cors,
    module.registrations_cors,
    module.registration_cors

  ]

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.events.id,
      aws_api_gateway_method.get_events.id,
      aws_api_gateway_integration.get_events.id,

      aws_api_gateway_resource.register.id,
      aws_api_gateway_method.register_event.id,
      aws_api_gateway_integration.register_event.id,

      aws_api_gateway_resource.registrations.id,
      aws_api_gateway_resource.registrations_email.id,
      aws_api_gateway_method.get_registrations.id,
      aws_api_gateway_integration.get_registrations.id,

      aws_api_gateway_resource.registration.id,
      aws_api_gateway_resource.registration_id.id,
      aws_api_gateway_method.delete_registration.id,
      aws_api_gateway_integration.delete_registration.id,

      module.events_cors,
      module.register_cors,
      module.registrations_cors,
      module.registration_cors

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
###################################################
# /register Resource
resource "aws_api_gateway_resource" "register" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_rest_api.event_api.root_resource_id

  path_part = "register"
}
###################################################
# POST /register
resource "aws_api_gateway_method" "register_event" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.register.id

  http_method = "POST"

  authorization = "NONE"
}
###################################################
# Lambda Integration

resource "aws_api_gateway_integration" "register_event" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.register.id

  http_method = aws_api_gateway_method.register_event.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.register_event.invoke_arn
}
###################################################
# Lambda Permission
resource "aws_lambda_permission" "register_event" {

  statement_id = "AllowRegisterEventInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.register_event.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.event_api.execution_arn}/*/*"
}
##################################################
# /registrations
##################################################

resource "aws_api_gateway_resource" "registrations" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_rest_api.event_api.root_resource_id

  path_part = "registrations"
}
##################################################
# /registrations/{email}
##################################################

resource "aws_api_gateway_resource" "registrations_email" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_resource.registrations.id

  path_part = "{email}"
}
##################################################
# GET /registrations/{email}
##################################################

resource "aws_api_gateway_method" "get_registrations" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.registrations_email.id

  http_method = "GET"

  authorization = "NONE"
}
##################################################
# Lambda Integration
##################################################

resource "aws_api_gateway_integration" "get_registrations" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.registrations_email.id

  http_method = aws_api_gateway_method.get_registrations.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.get_registrations.invoke_arn
}
##################################################
# Lambda Permission
##################################################

resource "aws_lambda_permission" "get_registrations" {

  statement_id = "AllowGetRegistrationsInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.get_registrations.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.event_api.execution_arn}/*/*"
}
##################################################
# /registration Resource
##################################################

resource "aws_api_gateway_resource" "registration" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_rest_api.event_api.root_resource_id

  path_part = "registration"
}

##################################################
# /registration/{id}
##################################################

resource "aws_api_gateway_resource" "registration_id" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  parent_id = aws_api_gateway_resource.registration.id

  path_part = "{id}"
}

##################################################
# DELETE /registration/{id}
##################################################

resource "aws_api_gateway_method" "delete_registration" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.registration_id.id

  http_method = "DELETE"

  authorization = "NONE"
}

##################################################
# Lambda Integration
##################################################

resource "aws_api_gateway_integration" "delete_registration" {

  rest_api_id = aws_api_gateway_rest_api.event_api.id

  resource_id = aws_api_gateway_resource.registration_id.id

  http_method = aws_api_gateway_method.delete_registration.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.delete_registration.invoke_arn
}

##################################################
# Lambda Permission
##################################################

resource "aws_lambda_permission" "delete_registration" {

  statement_id = "AllowDeleteRegistrationInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.delete_registration.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.event_api.execution_arn}/*/*"
}