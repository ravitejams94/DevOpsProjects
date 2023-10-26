import json
def lambda_handler(event, context):

# extract values from the event object we got from the Lambda service
    name = event['firstName'] +' '+ event['lastName']
    
    return {
    'statusCode': 200,
    'body': json.dumps('Hello from Lambda, ' + name)
    }