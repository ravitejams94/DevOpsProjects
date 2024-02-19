
# Sending Mass emails with S3, DynamoDB, Lambda and IAM (TERRAFORM IMPLEMENTATION)

- Difficulty : Easy-Medium (⭐⭐)
- Time : 2 Hours(⏲️)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#Prerequisites)
- [Walkthrough](#walkthrough)
- [Deployment](#deployment)
  
## Introduction
  
As per the previous setup we had created the following and now we will automate everything with terraform:-
- Setting up S3 Bucket.
- Creating the AWS Lambda Function 
- Setting Up Dynamo DB table
- Setting up IAM policies and permissions
  
## Prerequisites
- AWS account
- Basic AWS knowledge
- Beginner Python code understanding
- Before running this make sure you export your AWS access ID and secret key. For more details see [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
- Terraform basic knowledge. 
  
## Flowchart
![Flowchart](https://github.com/ravitejams94/DevOpsProjects/blob/main/2%20-%20Sending%20Mass%20Email%20with%20S3%2C%20DynamoDB%2C%20Lambda%20and%20IAM/Mass%20Email.png)

## Walkthrough
Here we will go through the files used for this one by one. Before running this zip and compress the **lambda_function.py**. 

# terraform.tfvars

This file contains the hardcoded values which can be modified according to one's creiteria. 
- bucket_name - The bucket name must be unique. You can modify the name to your choice.
- region - Pick one closest to you. For more details on AWS Regions you can see [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)
- file_name - File name must be the same. You can change is here but the uploaded file to S3 bucket must have the same name. This file must contain two columns. One is the "Email" and the next is the "Name" column.
- pandas_account_id - This variable refers to the AWS account ID of the person who had made pandas publicly available to be used by all.
- mail_form - This must be validated via SES. For more details you can check the previous document
- my_db_table - This is the name of the dynamo db table


```
# Custom bucket name(Can be changed to any name you like)
bucket_name         = "my-mass-email-bucket-name-test"

# Region for AWS
region              = "ap-south-1"

# Name of the file (Can be changed, make sure the uploaded file has same name - extension also same(xlsx))
file_name           = "Emails.xlsx" 

# Leave this as default
pandas_account_id   = "336392948345" # AWS provided ID for publicly available pandas layer to be used with python 3.8

# Give an SES approved mail id
mail_from           = "random@gmail.com"

# Name of your dynamo DB table (Can be changed)
my_db_table         = "dynamo_db_table"
```

# variables.tf

This file contains all the variable declaration along with description of eahc variable and what that variable is used for. These variables will be refered to again in the **main.tf**

# main.tf 

This is the main terraform scripts which builds the infrastructure required for this particular project to run. 

Here we are mentioning that AWS is the provide we are currently using.
```
provider "aws" {
  region = var.region
}
```

We are importing the modules here. These modules contain the policies which will be attached to IAM. Also the variables are imported here from tfvars file.
```
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
```

Creating the bucket resource here with the given bucket name. The parameter **force_destroy** is used so that if the bucket has objects also it would be deleted. 
By default AWS doesn't allow to delete buckets if objects are in it.
```
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  force_destroy = true # This is done so that even if the bucket has objects it will be destroyed
}
```

Creating the dynamo DB table here. Passing the name from variables; Billing values are PROVISIONED and PAY_PER_REQUEST. Defaults to PROVISIONED. Hash key is used to make the attribute as primary key. This is a must and must be given. 
- Notice that we are not mentioning any other attributes here. DynamoDB doesn't require any other attributes other than the primary key. For more details see [here](https://stackoverflow.com/questions/50006885/terraform-dynamodb-all-attributes-must-be-indexed).

```
resource "aws_dynamodb_table" "my_table" {
  name           =  var.my_db_table
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Email"

  attribute {
    name = "Email"
    type = "S"  # String type for email
  }
}
```

This creates the role required by the lambda function which will be implemented here. 
```
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
```

Here we are attaching the policy by importing then and attaching the policies to the IAM role.
```
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
```

This code defines the lambda function we are about to use. Here we give it a name. The code should be zipped so that it can be uploaded to AWS Lambda. We also mention then particular version of python we are running and we are attaching the role which was implemented earlier. We also define the environment variables which we using in lambda function. This prevnts hardcoding and later if needed more ENV variables can be added as well.

Here as you can see, we have also added layers of PANDAS as we are using python modul. For 3.8 we are using the particular pandas library and the particular version.
```
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
```

Finally we add the S3 trigger function here. This allows the lambda to monitor the S3 bucket so that any file uploaded with the extension ".xlsx", (Emails.xlsx) which will check the dynamo DB. 
```
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
```

## Deployment
1. On the command line after exporting the AWS access ID and Secret Key, Run **Terraform init**.
2. Next , **Terraform plan**
3. This plan shows you the complete infra being built.
4. Finally run **Terraform apply**.
5. Check out the resources created and upload the file "Emails.xlsx" and see the email being sent. 
6. Finally after your done make sure to run **Terraform destroy** to destroy all infra so that your not billed.
