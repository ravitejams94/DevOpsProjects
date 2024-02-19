variable "bucket_name" {
  description = "Unique name of the bucket for Mass Email"
  type        = string
}

# Create IAM policy for S3 read access
resource "aws_iam_policy" "s3_read_policy" {
  name        = "lambda-s3-read-policy"
  description = "Policy for Lambda to read a specific S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

output "arn" {
  value = aws_iam_policy.s3_read_policy.arn
}
