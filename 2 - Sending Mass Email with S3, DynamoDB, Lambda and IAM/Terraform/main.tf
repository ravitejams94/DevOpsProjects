
# Defining the provider we are using
provider "aws" {
  region = var.region
}

############################################################################

# Importing all the necessary modules
module "ses_policy" {
  source = "./modules/ses_policy"
}

module "s3_policy" {
  source      = "./modules/s3_policy"
  bucket_name = var.bucket_name
}

module "dynamo_db_policy" {
  source = "./modules/dynamo_db_policy"
  my_db_table = var.my_db_table
}


############################################################################

# Creating the Bucket with 
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  force_destroy = true # This is done so that even if the bucket has objects it will be destroyed
}


############################################################################
# Creating the DynamoDB table
resource "aws_dynamodb_table" "my_table" {
  name           =  var.my_db_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Email"

  attribute {
    name = "Email"
    type = "S"  # String type for email
  }
}


############################################################################
# Create IAM role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

############################################################################
# Attach IAM policies to Lambda execution role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = module.s3_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ses_policy_attachment" {
  policy_arn = module.ses_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  policy_arn = module.dynamo_db_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

############################################################################
# Define the Lambda Function
resource "aws_lambda_function" "my_lambda_function" {
  function_name    = "my-lambda-function"
  filename         = "lambda_function.zip"  # Path to your Python Lambda function code zip file
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn

  # These are the env variables which we will be passint to lambda function
  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      S3_KEY      = var.file_name
      REGION      = var.region
      MAIL_FROM   = var.mail_from
      MY_TABLE    = var.my_db_table
    }
  }
  # Adding the pandas layer to the Lambda function
  layers = ["arn:aws:lambda:${var.region}:${var.pandas_account_id}:layer:AWSSDKPandas-Python38:15"]
}

############################################################################
# Allowing lambda to be invoked when file is uploaded to S3 bucket
resource "aws_lambda_permission" "s3_trigger_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

resource "aws_s3_bucket_notification" "my_bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    # This extenstion can be changed if required to whatever file type your uploading
    filter_suffix       = ".xlsx"
  }
}
