# Create IAM policy for Amazon SES full access
resource "aws_iam_policy" "ses_full_access_policy" {
  name        = "lambda-ses-full-access-policy"
  description = "Policy for Lambda to have full access to Amazon SES"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "ses:*",
      Resource = "*"
    }]
  })
}

output "arn" {
  value = aws_iam_policy.ses_full_access_policy.arn
}
