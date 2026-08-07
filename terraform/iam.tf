#############################################
# Lambda Assume Role Policy
#############################################

data "aws_iam_policy_document" "lambda_assume_role" {

  statement {

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]

    }

    actions = [
      "sts:AssumeRole"
    ]

  }

}

#############################################
# Lambda Execution Role
#############################################

resource "aws_iam_role" "lambda_role" {

  name = local.lambda_role_name

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

}

#############################################
# Lambda Permissions
#############################################

data "aws_iam_policy_document" "lambda_permissions" {

  statement {

    sid = "CloudWatchLogs"

    effect = "Allow"

    actions = [

      "logs:CreateLogGroup",

      "logs:CreateLogStream",

      "logs:PutLogEvents"

    ]

    resources = [
      "*"
    ]

  }

  statement {

    sid = "DynamoDB"

    effect = "Allow"

    actions = [

      "dynamodb:GetItem",

      "dynamodb:PutItem",

      "dynamodb:UpdateItem",

      "dynamodb:DeleteItem",

      "dynamodb:Query",

      "dynamodb:Scan"

    ]

    resources = [
      aws_dynamodb_table.events.arn,
      aws_dynamodb_table.registrations.arn,
      "${aws_dynamodb_table.registrations.arn}/index/*"
    ]

  }

}

#############################################
# IAM Policy
#############################################

resource "aws_iam_policy" "lambda_policy" {

  name = local.lambda_policy_name

  policy = data.aws_iam_policy_document.lambda_permissions.json

}

#############################################
# Attach Policy
#############################################

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.lambda_policy.arn

}