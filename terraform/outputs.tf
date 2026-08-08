#############################################
# Project Information
#############################################

output "project_name" {
  description = "Project Name"

  value = var.project_name
}

output "environment" {
  description = "Deployment Environment"

  value = var.environment
}

#############################################
# AWS Information
#############################################

output "aws_account_id" {
  description = "AWS Account ID"

  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Current AWS Region"

  value = data.aws_region.current.region
}

output "iam_user_arn" {
  description = "IAM User ARN"

  value = data.aws_caller_identity.current.arn
}

output "iam_user_id" {
  description = "IAM User ID"

  value = data.aws_caller_identity.current.user_id
}

output "aws_partition" {
  description = "AWS Partition"

  value = data.aws_partition.current.partition
}

#############################################
# IAM
#############################################

output "lambda_role_name" {

  value = aws_iam_role.lambda_role.name

}

output "lambda_role_arn" {

  value = aws_iam_role.lambda_role.arn

}

#############################################
# DynamoDB Outputs
#############################################

output "events_table_name" {
  description = "Name of the Events DynamoDB table"
  value       = aws_dynamodb_table.events.name
}

output "events_table_arn" {
  description = "ARN of the Events DynamoDB table"
  value       = aws_dynamodb_table.events.arn
}

output "registrations_table_name" {
  description = "Name of the Registrations DynamoDB table"
  value       = aws_dynamodb_table.registrations.name
}

output "registrations_table_arn" {
  description = "ARN of the Registrations DynamoDB table"
  value       = aws_dynamodb_table.registrations.arn
}

output "registrations_email_index" {
  description = "GSI used to query registrations by email"
  value       = local.registrations_email_index_name
}
output "api_base_url" {

  description = "Base URL for the API Gateway"

  value = aws_api_gateway_stage.dev.invoke_url
}
output "website_url" {

  value = aws_s3_bucket_website_configuration.frontend.website_endpoint

}

output "website_bucket" {

  value = aws_s3_bucket.frontend.bucket

}