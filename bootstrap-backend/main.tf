#############################################
# Terraform Configuration
#############################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

#############################################
# AWS Provider
#############################################

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "event-registration-ticketing-system"
      Environment = "bootstrap"
      ManagedBy   = "Terraform"
      Owner       = "Ama Ninson"
    }
  }
}

#############################################
# Random Suffix for Globally Unique Bucket
#############################################

resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  numeric = true
  special = false
}

#############################################
# S3 Bucket for Terraform State
#############################################

resource "aws_s3_bucket" "terraform_state" {

  bucket = "event-registration-tfstate-${random_string.bucket_suffix.result}"

  force_destroy = false
}

#############################################
# Enable Server-Side Encryption
#############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

#############################################
# Block Public Access
#############################################

resource "aws_s3_bucket_public_access_block" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

}

#############################################
# DynamoDB Table for State Locking
#############################################

resource "aws_dynamodb_table" "terraform_lock" {

  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

#############################################
# Outputs
#############################################

output "terraform_state_bucket" {

  description = "S3 bucket used for Terraform state"

  value = aws_s3_bucket.terraform_state.bucket

}

output "terraform_lock_table" {

  description = "DynamoDB table used for state locking"

  value = aws_dynamodb_table.terraform_lock.name

}