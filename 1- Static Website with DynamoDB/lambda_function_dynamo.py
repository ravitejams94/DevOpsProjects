# import the json utility package since we will be working with a JSON object
import json
import boto3
import time

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('HelloWorldDatabase')

def lambda_handler(event, context):
    gmt_time = time.gmtime()
    now = time.strftime('%a, %d %b %Y %H:%M:%S +0000', gmt_time)

    name = event['firstName'] +' '+ event['lastName']
    # write name and time to the DynamoDB table using the object we instantiated and save response in a variable
    response = table.put_item(
        Item={
            'ID': name,
            'LatestGreetingTime':now
            })

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda, ' + name)
    }