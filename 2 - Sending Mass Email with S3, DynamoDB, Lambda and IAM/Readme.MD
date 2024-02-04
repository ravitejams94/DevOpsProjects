
# Sending Mass emails with S3, DynamoDB, Lambda and IAM

- Difficulty : Easy-Medium (⭐⭐)
- Time : 2 Hours(⏲️)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#Prerequisites)
- [Installation](#installation)
- [Commands](#commands)
- [Challenges](#challenges)
  
## Introduction
We will setup the following 
- Setup an S3 bucket with custom name and one xlsx file.
- Setup SES to validate emails.
- Setup a DynamoDB table with custom name.
- Create a lambda function with python code used to access both the bucket and the dynamoDB table.
- Modify the IAM permissions so that the lambda has the right policies attached.

  
## Prerequisites
  
## Walkthrough

### Setting up the S3 bucket.
1. Open up your Amazon account and login.
2. Go to S3 and create a custom bucket with any name. Ex: "Test-Bucket"
3. Create a file with the name "Emails.xlsx" (This name will be used later in the code)
This file need to have "Name" and "Email" column with some random names and legitimate emails.
Keep in mind the Emails as these have to be validated with Amazon SES.


  



