
# Sending Mass emails with S3, DynamoDB, Lambda and IAM

- Difficulty : Easy-Medium (⭐⭐)
- Time : 2 Hours(⏲️)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#Prerequisites)
- [Walkthrough](#walkthrough)
- [Challenges](#challenges)
  
## Introduction
We will setup the following 
- Setup an S3 bucket with custom name and one xlsx file.
- Setup SES to validate emails.
- Setup a DynamoDB table with custom name.
- Create a lambda function with python code used to access both the bucket and the dynamoDB table.
- Modify the IAM permissions so that the lambda has the right policies attached.

  
## Prerequisites
- AWS account
- Basic AWS knowledge
- Beginner Python code understanding
  
## Walkthrough

### Setting up the S3 bucket.
1. Open up your Amazon account and login.
2. Go to S3 and create a custom bucket with any name. Ex: "sendingmailbucketlist"
3. Create a file with the name "Emails.xlsx" (This name will be used later in the code)
This file need to have "Name" and "Email" column with some random names and legitimate emails.
Keep in mind the Emails as these have to be validated with Amazon SES.

### Setting up Amazon SES
1. Make sure your logged into your AWS account.
2. Search for "SES" (Simple Email service)
3. Click on **Verified Identities**.
4. Click on **Create Identity**.
5. Select **Email address** and enter the email address from the list "Emails.xlsx" file. Once you have done that a mail will be sent to those mail addresses which have to be validated by clicking a link in that email from Amazon. If this step is skipped or link is not clicked, then mails won't be sent at all so this step is important. 
6. Validate as many emails as possible. (For this tutorial purpose, 2 emails were used here)

### Creating DynamoDB Table.
1. Staying Logged in, Search for DynamoDB.
2. Click on **Create Table** and give it a name. For Ex: "NameEmailTable" (This name will be used later)
3. Give it the partition key name as "Email" and set it as String. (Emails will be unique)
4. Leave the settings as default and click on **Create table**.

### Writing the Lambda Python Code
1. Search for Lambda in AWS. 
2. Once your in Lambda click on **Create Function**
3. Give it a name. Ex:"SendEmailTest" is the name used here.
4. Choose runtime as "Python3"
5. Leave the rest of the settings as it is and click on **Create Function**
6. In the Code source copy the following code below

```
import boto3
import pandas as pd
from botocore.exceptions import ClientError
from io import BytesIO

def lambda_handler(event, context):
    # Specify your AWS region
    aws_region = 'AWS_REGION'

    # Create S3 and DynamoDB clients
    s3_client = boto3.client('s3', region_name=aws_region)
    dynamodb = boto3.client('dynamodb', region_name=aws_region)

    # S3 bucket and file details
    s3_bucket = 'BUCKET_NAME'
    s3_key = 'Emails.xlsx'

    # Download the file from S3
    try:
        response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
        file_content = response['Body'].read()

        # Process Excel file content using pandas
        df = pd.read_excel(BytesIO(file_content))

        # Iterate over rows and extract name and email values
        for index, row in df.iterrows():
            name, email = row['Name'], row['Email']
            process_email(name, email)
            print("NAME is ", name)
            print("Email is", email)

    except ClientError as e:
        print("Error interacting with S3:", e)

def process_email(name, email):
    # Specify your AWS region
    aws_region = 'AWS_REGION'

    # Create DynamoDB and SES clients
    dynamodb = boto3.client('dynamodb', region_name=aws_region)
    ses_client = boto3.client('ses', region_name=aws_region)

    # DynamoDB table name
    table_name = 'NameEmailTable'

    # Check if the email already exists in DynamoDB
    try:
        response = dynamodb.get_item(
            TableName=table_name,
            Key={
                'Email': {'S': email}
            }
        )

        item = response.get('Item')
        if item:
            # Email already exists
            if 'Processed' in item:
                # If 'Processed' attribute is present, it means the email has been processed before
                send_email('Duplicate Entry', 'This email already exists.', email)
            else:
                # If 'Processed' attribute is not present, it means it's the first time processing the email
                dynamodb.update_item(
                    TableName=table_name,
                    Key={
                        'Email': {'S': email}
                    },
                    UpdateExpression='SET Processed = :val',
                    ExpressionAttributeValues={
                        ':val': {'BOOL': True}
                    }
                )
                send_email('Entry Added', f'Hello {name}, your entry has been added to the table.', email)
        else:
            # Email doesn't exist, generate a new ID and add to DynamoDB
            dynamodb.put_item(
                TableName=table_name,
                Item={
                    'Email': {'S': email},
                    'Name': {'S': name},
                    'Processed': {'BOOL': True}
                }
            )
            send_email('Entry Added', f'Hello {name}, your entry has been added to the table.', email)

    except ClientError as e:
        print("Error interacting with DynamoDB:", e)

def send_email(subject, body, to_email):
    # Specify your AWS region
    aws_region = 'AWS_REGION'

    # Create an SES client
    ses_client = boto3.client('ses', region_name=aws_region)

    # Specify the sender's email address
    from_email = 'SENDERS_EMAIL'

    # Create the email message
    message = {
        'Subject': {
            'Data': subject
        },
        'Body': {
            'Text': {
                'Data': body
            }
        }
    }

    # Send the email
    try:
        response = ses_client.send_email(
            Source=from_email,
            Destination={
                'ToAddresses': [to_email]
            },
            Message=message
        )
        print("Email sent! Message ID:", response['MessageId'])
    except ClientError as e:
        print("Error sending email:", e)

lambda_handler(None, None)
```

Replace the following values:
- AWS_REGION - The Region you are in
- BUCKET_NAME - Custom name of the bucket (sendingmailbucketlist)
- SENDERS_EMAIL - Senders email validated by AWS SES

7. Once copied click on **Deploy**
8. Since pandas is being used here, lambda functions needs to add this as a layer. In the same page where this code was copied done, scroll down till you find **Layers**. Click on **Add a Layer**
9. Choose **AWS Layers** and select **AWSSDKLayers**. Click on Add.
10. Trigger has to be added, so in the main page click on **Add Trigger**.
11. Select the Source as **S3**. Select the given bucket name, under the Event type select only the **PUT** option as the lambda function should trigger when something is uploaded into the bucket. For suffix select as, **.xlsx** which is the extension of our file "Emails.xlsx". Also, check the box of the "Recursive Invocation". This states that same S3 bucket is not used for both input and output.
12. Click on **Add**. Now Trigger now has been set so whenever email is added to the file and the file "Emails.xlsx" is uploaded to the bucket, the lambda function will trigger.

Here after adding once we click on **Test**, some errors will pop up. This is mainly due to lack of permissions which we will add in the next step.

### Adding the IAM Permissions
1. Once you have finished writing the Lambda code, permissions need to be added to it. Near the code source click on **Configuration**.
2. Click on **Permissions** and click the Role name. This will open up a new tab which has the policy role attached to the lambda function. 
3. Here 3 permissions are to be added:-

  - Under Permissions, click on **Add Permissions** and select **Attach Policies**. The first policy to attach here is the **AmazonSESFullAccess**. This allows the lambda function to access the AWS SES so that it can send email to the mail addresses in the xlsx.
  - The second policy to attach is Inline policy. Under Permissions, click on **Add Permissions** and select **Create Inline Policy**. Click on **JSON** and copy the following code below.
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::BUCKET_NAME",
				"arn:aws:s3:::BUCKET_NAME/*"
			]
		}
	]
}
```
BUCKET_NAME - Replace it with the actual bucket name. This policy is used to access the bucket and the objects inside the bucket. This is a bucket specific policy.
  - The third and final policy to attach is the DynamoDB read and write policy. Another Inline policy as above in the JSON copy the following code.
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"dynamodb:PutItem",
				"dynamodb:GetItem"
			],
			"Resource": "arn:aws:dynamodb:AWS_REGION:AWS_ACCOUNT_ID:table/DYNAMO_DB_NAME"
		}
	]
}
```
Replace the following values.
AWS_REGION - The region of your AWS. 
ACCOUNT_ID - Account ID. Found in the drop down at the top right at account name.
DYNAMO_DB_NAME - The name of the Dynamo DB table created.

4. Once these policies have been attached, your lambda function is ready to go. Upload the file "Emails.xlsx" and see how the lambda function triggers.

## Challenges

1. To make this more interesting, how would we deploy this cross region?
2. Is there a workaround to not verifying each and every single mail? If there are 1000's then it can be physically daunting task to verify all the emails.
