
## BUILDING A STATIC WEBSITE WITH DYNAMO DB BACKEND

Here lies the code and the logic behind creating this “Hello World” Website. Before starting make sure you clone the source code and have an AWS account. This app will:-
- Create a simple web app
- Connect the app to a backend which is serverless
- Create interactivity with web app with an API
- Post the form written data into database

The following resources are being used:- 
+ AWS Amplify - Building the frontend app
+ AWS API Gateway - Develop the required API’s.
+ DynamoDB - NoSQL Database 
+ AWS Lambda - Serverless service that lets you run the code. (Python)
+ IAM - Policies which will be attached to Lambda functions so that they can perform actions on the DynamoDB.

**Part 1 - Setting up the front-end using AWS Amplify**


1. Download the source code from the repo here.
1. Have a look at the index.html file. This is what will be the front end part of the website. Zip only this file. (Index.zip)
In AWS, head over to AWS Amplify. (You can use any region; Once you pick one make sure you pick the same region for all others; Picking us-east-1)
Click on Get Started and then under Amplify Hosting click Get Started.
Select Deploy without Git Provider.
Click Continue and under AppName give it a name (DemoWebsite) (Can be any name)
For Environment select Dev, then select Drag n Drop.
Upload or drag the Index.zip file here. Click on Save and Deploy.
To verify this click on Domain Management on the left side and copy and paste the URL given. You should be able to see the website here.

**Part 2 - Creating and modifying Lambda Function**


Head over to AWS Lambda. Make sure you are in the same region which you picked earlier.
Pick Create function. Give it a custom name HelloWorldFunction. Select Python (3.10) (Pick a version) 
Open lambda_function.py of the source code. Copy and paste the content of that code to Code Source.
Save the changes and click on Deploy.
Choose the Test button and click on Configure Test Event. Give it a custom name.
Copy and paste the following JSON value into the 
{“firstName”:”Sammy, “lastName”:”Westside”}
Save it . Test it. Under the Test tab you will be able to see the results of the test.
EXECUTION RESULT: SUCCEEDED.


**PART 3 - Link LAMBDA to Web App**

Head to API Gateway Console.
Choose API Type as REST API and select Build.
Create New API and give it the name HelloWorldAPI.
Leave the settings as default and select on Create API.
Once selected in the left pane click on Resources , API:HelloWorldAPI.
Ensure the "/" resource is selected.
From the Actions dropdown menu, select Create Method.
Select POST from the new dropdown that appears, then select the checkmark.
Select Lambda Function for the Integration type.
Enter HelloWorldFunction in the Lambda Function field.
Choose the blue Save button.
You will see a message letting you know you are giving the API you are creating permission to call your Lambda function. Choose the OK button.
With the newly created POST method selected, select Enable CORS from the Action dropdown menu.
Leave the POST checkbox selected and choose the blue Enable CORS and replace existing CORS headers button. Choose Replace Existing Values.
In Actions dropdown, Select Deploy API.
Select New stage and give it a name. WebDemo.
Choose Deploy. Make sure you note the URL given here. (Invoke URL)

**PART 4 - Create DynamoDB Table.**

Head into the Amazon DynamoDB console.
Make sure you create your table in the same region you picked earlier.
Choose the Create table button.
Under Table name, enter HelloWorldDatabase.
In the Partition key field, enter ID. The partition key is part of the table's primary key.
Choose the Create table button.
In the list of tables, select the table name, HelloWorldDatabase.
In the General information section, show Additional info by selecting the down arrow.
Copy the ARN name which will be needed later.

Here now we have to give our Lambda function permission to write to this table.
Head back into AWS Lambda.
Select the HelloWorldFunction which was created earlier.
To add the policy (Permissions), head into Configuration and select Permissions.
In the Execution role box, under Role name, choose the link. A new browser tab will open.
In the Permissions policies box, open the Add permissions dropdown and select Create inline policy.
Select the JSON tab.
Paste the following policy mentioned in source code lambda_policy.json. Take care to replace the YOUR TABLE ARN HERE with your table arn which we copied earlier.
The policy will allow Lambda function to write into the table. (and more)
Choose the Review Policy button.
Next to Name, enter HelloWorldPolicy.
Choose the Create Policy button.

Earlier we had a simple Lambda function. Now we modify the function to write into the table. 
Select the AWS Lambda function created and select the Code tab.
Copy the code from lambda_function_dynamo.py and paste it here. (Note here in the code the dynamo db table name is hardcoded; you can pass it as environment variable as well)
Click Deploy.
Test the same as we had done earlier with different first and last Names. You will see that they have succeeded. Everytime your lambda function executes, the new values will be written to the DynamoDB table.

**PART 5 - RUNNING IT ALL TOGETHER**

Head over to the index.html file which is present in source code.
Modify the YOUR API URL with the API URL created from Invoke URL.
Save and re-zip this index.html file and upload the same to AWS Amplify as done earlier.
Under Domain Choose URL. Run the URL and enter any first and last name and click on Send. This calls the Lambda API which inturn inserts the names into the dynamoDB table and a popup comes up
Check the dynamoDB table and see if the values have been inserted. 



