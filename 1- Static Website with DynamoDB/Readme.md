
## BUILDING A STATIC WEBSITE WITH DYNAMO DB BACKEND

Here lies the code and the logic behind creating this “Hello World” Website. Before starting make sure you clone the source code and have an AWS account. This app will:-
- Create a simple web app
- Connect the app to a backend which is serverless
- Create interactivity with web app with an API
- Post the form written data into database

### Flowchart

![alt text](https://github.com/ravitejams94/DevOpsProjects/blob/main/1-%20Static%20Website%20with%20DynamoDB/Flowchart.png)


The following resources are being used:- 
+ [AWS Amplify](https://aws.amazon.com/amplify/) - Building the frontend app
+ [AWS API Gateway](https://aws.amazon.com/api-gateway/) - Develop the required API’s.
+ [DynamoDB](https://aws.amazon.com/dynamodb/) - NoSQL Database managed by AWS
+ [AWS Lambda](https://aws.amazon.com/lambda/) - Serverless service that lets you run the code. (Python)
+ [IAM](https://aws.amazon.com/iam/) - Policies which will be attached to Lambda functions so that they can perform actions on the DynamoDB.

**Part 1 - Setting up the front-end using AWS Amplify**


1. Download the source code.
1. Have a look at the **index.html** file. This is what will be the front end part of the website. Zip only this file. (**Index.zip**)
1. In AWS, head over to **AWS Amplify**. (You can use any region; Once you pick one make sure you pick the same region for all others; **Picking us-east-1**)
1. Click on **Get Started** and then under Amplify Hosting click **Get Started**.
1. Select **Deploy without Git Provider**.
1. Click Continue and under AppName give it a name (**DemoWeb**) (Can be any name)
1. For Environment select Dev, then select **Drag n Drop**.
1. Upload or drag the **Index.zip** file here. Click on **Save and Deploy**.
1. To verify this click on **Domain Management** on the left side and copy and paste the **URL** given. You should be able to see the website here.

**Part 2 - Creating and modifying Lambda Function**

1. Head over to **AWS Lambda**. Make sure you are in the same region which you picked earlier.
1. Pick **Create function**. Give it a custom name **HelloWorldFunction**. Select Python (3.10) (Pick a version) 
1. Open **lambda_function.py** of the source code. Copy and paste the content of that code to Code Source.
1. Save the changes and click on **Deploy**.
1. Choose the Test button and click on **Configure Test Event**. Give it a custom name.
1. Copy and paste the following JSON value into the 
> {“firstName”:”Sammy, “lastName”:”Westside”}
7. Save it . Test it. Under the Test tab you will be able to see the results of the test.
> EXECUTION RESULT: SUCCEEDED.


**PART 3 - Link LAMBDA to Web App**

1. Head to **API Gateway Console**.
1. Choose API Type as **REST API** and select **Build**.
1. Create New API and give it the name **HelloWorldAPI**.
1. Leave the settings as default and select on **Create API**.
1. Once selected in the left pane click on Resources , **API:HelloWorldAPI**.
1. Ensure the "/" resource is selected.
1. From the **Actions** dropdown menu, select **Create Method**.
1. Select **POST** from the new dropdown that appears, then select the **checkmark**.
1. Select **Lambda Function** for the Integration type.
1. Enter **HelloWorldFunction** in the Lambda Function field.
1. Choose the **Save** button.
1. You will see a message letting you know you are giving the API you are creating permission to call your Lambda function. Choose the **OK** button.
1. With the newly created POST method selected, select **Enable CORS** from the Action dropdown menu.
1. Leave the POST checkbox selected and choose the **Enable CORS** and **replace existing CORS headers** button. Choose Replace Existing Values.
1. In Actions dropdown, Select **Deploy API**.
1. Select New stage and give it a name. **WebDemo**.
1. Choose Deploy. Make sure you note the URL given here. (**Invoke URL**)

**PART 4 - Create DynamoDB Table.**

1. Head into the **Amazon DynamoDB console**.
1. Make sure you create your table in the same region you picked earlier.
1. Choose the **Create table** button.
1. Under Table name, enter **HelloWorldDatabase**.
1. In the Partition key field, enter **ID**. The partition key is part of the table's primary key.
1. Choose the **Create table** button.
1. In the list of tables, select the table name, **HelloWorldDatabase**.
1. In the General information section, show **Additional info** by selecting the down arrow.
1. Copy the **ARN** name which will be needed later.


**PART 5 - Giving Lambda Function Permission with IAM**

1. Head back into **AWS Lambda**.
1. Select the **HelloWorldFunction** which was created earlier.
1. To add the policy (Permissions), head into **Configuration** and select **Permissions**.
1. In the **Execution role** box, under **Role** name, choose the link. A new browser tab will open.
1. In the Permissions policies box, open the **Add permissions** dropdown and select **Create inline policy**.
1. Select the **JSON tab**.
1. Paste the following policy mentioned in source code **lambda_policy.json**. Take care to replace the **YOUR TABLE ARN HERE** with your table arn which we copied earlier.
1. The policy will allow **Lambda function** to write into the table. (and more)
1. Choose the **Review Policy** button.
1. Next to Name, enter **HelloWorldPolicy**.
1. Choose the **Create Policy** button.

**PART 6 - Updating Lambda Function to write to the DynamoDB**
1. Select the **AWS Lambda function** created and select the Code tab.
1. Copy the code from **lambda_function_dynamo.py** and paste it here. (Note here in the code the dynamo db table name is hardcoded; you can pass it as environment variable as well)
1. Click **Deploy**.
1. Test the same as we had done earlier with different first and last Names. You will see that they have succeeded. Everytime your lambda function executes, the new values will be written to the DynamoDB table.

**PART 7 - RUNNING IT ALL TOGETHER**

1. Head over to the **index.html** file which is present in source code.
1. Modify the **YOUR API URL** with the API URL created from Invoke URL.
1. Save and re-zip this **index.html** file and upload the same to AWS Amplify as done earlier.
1. Under Domain Choose **URL**. Run the URL and enter any first and last name and click on **Send**. This calls the Lambda API which inturn inserts the names into the dynamoDB table and a popup comes up
1. Check the **dynamoDB table** and see if the values have been inserted.
