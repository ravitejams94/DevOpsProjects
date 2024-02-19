
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
### 
1. Open up your Amazon account and login.
2. Go to S3 and create a custom bucket with any name. Ex: "sendingmailbucketlist"
3. Create a file with the name "Emails.xlsx" (This name will be used later in the code)
This file need to have "Name" and "Email" column with some random names and legitimate emails.
Keep in mind the Emails as these have to be validated with Amazon SES.
