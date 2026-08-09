##################################################
# Sample Events
##################################################

resource "aws_dynamodb_table_item" "event_001" {

  table_name = aws_dynamodb_table.events.name
  hash_key   = "event_id"

  item = jsonencode({
    event_id    = { S = "EVT-001" }
    title       = { S = "AWS Cloud Bootcamp" }
    location    = { S = "Accra" }
    date        = { S = "2026-09-15" }
    capacity    = { N = "50" }
    registered  = { N = "0" }
    description = { S = "Learn AWS fundamentals and cloud best practices." }
  })
}

resource "aws_dynamodb_table_item" "event_002" {

  table_name = aws_dynamodb_table.events.name
  hash_key   = "event_id"

  item = jsonencode({
    event_id    = { S = "EVT-002" }
    title       = { S = "Terraform Fundamentals" }
    location    = { S = "Kumasi" }
    date        = { S = "2026-09-22" }
    capacity    = { N = "10" }
    #registered  = { N = "0" }
    description = { S = "Infrastructure as Code with Terraform." }
  })
}

resource "aws_dynamodb_table_item" "event_003" {

  table_name = aws_dynamodb_table.events.name
  hash_key   = "event_id"

  item = jsonencode({
    event_id    = { S = "EVT-003" }
    title       = { S = "Serverless on AWS" }
    location    = { S = "Takoradi" }
    date        = { S = "2026-10-05" }
    capacity    = { N = "35" }
    #registered  = { N = "0" }
    description = { S = "Build applications using Lambda and API Gateway." }
  })
}

resource "aws_dynamodb_table_item" "event_004" {

  table_name = aws_dynamodb_table.events.name
  hash_key   = "event_id"

  item = jsonencode({
    event_id    = { S = "EVT-004" }
    title       = { S = "Cloud Security Essentials" }
    location    = { S = "Cape Coast" }
    date        = { S = "2026-10-18" }
    capacity    = { N = "3" }
    #registered  = { N = "0" }
    description = { S = "Identity, IAM, encryption, and security best practices." }
  })
}

resource "aws_dynamodb_table_item" "event_005" {

  table_name = aws_dynamodb_table.events.name
  hash_key   = "event_id"

  item = jsonencode({
    event_id    = { S = "EVT-005" }
    title       = { S = "DevOps with AWS" }
    location    = { S = "Tamale" }
    date        = { S = "2026-11-02" }
    capacity    = { N = "5" }
    #registered  = { N = "0" }
    description = { S = "CI/CD, CodePipeline, and deployment automation." }
  })
}