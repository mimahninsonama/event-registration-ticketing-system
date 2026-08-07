terraform {
  backend "s3" {
    bucket         = "event-registration-tfstate-wkpb56"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}