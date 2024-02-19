variable "my_db_table" {
  description = "Name of the DynamoDB table"
  type        = string
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "dynamodb-table-policy"
  description = "Policy to allow read and write access to a specific DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ],
        Resource = "arn:aws:dynamodb:*:*:table/${var.my_db_table}"
      }
    ]
  })
}

output "arn" {
  value = aws_iam_policy.dynamodb_policy.arn
}
