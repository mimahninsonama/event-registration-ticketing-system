locals {

  name_prefix = "${var.project_name}-${var.environment}"

  account_id = data.aws_caller_identity.current.account_id

  current_region = data.aws_region.current.region

  events_table_name = "${local.name_prefix}-${var.events_table_name}"

  registrations_table_name = "${local.name_prefix}-${var.registrations_table_name}"

  registrations_email_index_name = var.registrations_email_index_name

  common_tags = {

    Project = var.project_name

    Environment = var.environment

    ManagedBy = "Terraform"

    Repository = "event-registration-ticketing-system"

    Owner = "Ama Ninson"

  }

  lambda_functions = [

    "get-events",

    "register-event",

    "get-registrations",

    "delete-registration"

  ]

}

#############################################
# IAM
#############################################

locals {

  lambda_role_name = "${local.name_prefix}-lambda-role"

  lambda_policy_name = "${local.name_prefix}-lambda-policy"

}