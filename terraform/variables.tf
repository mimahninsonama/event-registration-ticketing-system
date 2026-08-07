variable "aws_region" {
  description = "AWS deployment region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "lambda_runtime" {
  description = "Python runtime"

  type = string

  default = "python3.13"
}

variable "lambda_timeout" {

  type = number

  default = 30
}

variable "lambda_memory_size" {

  type = number

  default = 256
}

#############################################
# DynamoDB Tables
#############################################

variable "events_table_name" {
  description = "Events DynamoDB table"
  type        = string
  default     = "events"
}

variable "registrations_table_name" {
  description = "Registrations DynamoDB table"
  type        = string
  default     = "registrations"
}

variable "registrations_email_index_name" {
  description = "Global Secondary Index for looking up registrations by email"
  type        = string
  default     = "email-index"
}