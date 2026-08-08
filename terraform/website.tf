##################################################
# Frontend Website Bucket
##################################################

resource "aws_s3_bucket" "frontend" {

  bucket = "${local.name_prefix}-frontend"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-frontend"
      Type = "Website"
    }
  )
}

##################################################
# Static Website Hosting
##################################################

resource "aws_s3_bucket_website_configuration" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

##################################################
# Public Access Block
##################################################

resource "aws_s3_bucket_public_access_block" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

##################################################
# Bucket Policy
##################################################

resource "aws_s3_bucket_policy" "frontend" {

  bucket = aws_s3_bucket.frontend.id

  depends_on = [
    aws_s3_bucket_public_access_block.frontend
  ]

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "PublicRead"

        Effect = "Allow"

        Principal = "*"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          "${aws_s3_bucket.frontend.arn}/*"
        ]

      }

    ]

  })

}