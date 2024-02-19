import boto3
import pandas as pd
from botocore.exceptions import ClientError
from io import BytesIO
import os

BUCKET_NAME = os.environ['BUCKET_NAME']
S3_KEY = os.environ['S3_KEY']
REGION = os.environ['REGION']
MAIL_FROM = os.environ['MAIL_FROM']
MY_TABLE = os.environ['MY_TABLE']

def lambda_handler(event, context):
    # Create S3 and DynamoDB clients
    s3_client = boto3.client('s3', region_name=REGION)
    dynamodb = boto3.client('dynamodb', region_name=REGION)

    # S3 bucket and file details
    #s3_bucket = 'my-mass-email-bucket-name-test'
    #s3_key = 'Emails.xlsx'

    # Download the file from S3
    try:
        response = s3_client.get_object(Bucket=BUCKET_NAME, Key=S3_KEY)
        file_content = response['Body'].read()

        # Process Excel file content using pandas
        df = pd.read_excel(BytesIO(file_content))
        #body = ''

        # Iterate over rows and extract name and email values
        for index, row in df.iterrows():
            name, email = row['Name'], row['Email']
            process_email(name, email)
            #body += f"\nName :{name}\nEmail{email}"
            print("NAME is ", name)
            print("Email is", email)
    
        # Send email outside of loop
        #send_email("The ClientList", body)
        
    except ClientError as e:
        print("Error interacting with S3:", e)


def process_email(name, email):
    # Specify your AWS region
    aws_region = REGION

    # Create DynamoDB and SES clients
    dynamodb = boto3.client('dynamodb', region_name=REGION)
    ses_client = boto3.client('ses', region_name=REGION)

    # DynamoDB table name
    table_name = MY_TABLE

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

    # Create an SES client
    ses_client = boto3.client('ses', region_name=REGION)

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
            Source=MAIL_FROM,
            Destination={
                'ToAddresses': [to_email]
            },
            Message=message
        )
        print("Email sent! Message ID:", response['MessageId'])
    except ClientError as e:
        print("Error sending email:", e)

lambda_handler(None, None)
