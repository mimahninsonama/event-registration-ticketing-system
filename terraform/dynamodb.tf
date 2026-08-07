#############################################
# Events DynamoDB Table
#############################################

resource "aws_dynamodb_table" "events" {
  name         = local.events_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "event_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.events_table_name
      Type = "Events"
    }
  )
}


#############################################
# Registrations DynamoDB Table
#############################################

resource "aws_dynamodb_table" "registrations" {
  name         = local.registrations_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "registration_id"

  attribute {
    name = "registration_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = local.registrations_email_index_name
    projection_type = "ALL"

    key_schema {
      attribute_name = "email"
      key_type       = "HASH"
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.registrations_table_name
      Type = "Registrations"
    }
  )
}