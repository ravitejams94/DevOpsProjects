
# Sending Mass emails with S3, DynamoDB, Lambda and IAM (TERRAFORM IMPLEMENTATION)

- Difficulty : Easy-Medium (⭐⭐)
- Time : 2 Hours(⏲️)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#Prerequisites)
- [Walkthrough](#walkthrough)
- [Challenges](#challenges)
  
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
  
## Flowchart
![Flowchart](https://github.com/ravitejams94/DevOpsProjects/blob/main/2%20-%20Sending%20Mass%20Email%20with%20S3%2C%20DynamoDB%2C%20Lambda%20and%20IAM/Mass%20Email.png)

## Walkthrough
Here we will go through the files used for this one by one.

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

We are importing the modules here. These modules contain the policies which will be attached to IAM.
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

