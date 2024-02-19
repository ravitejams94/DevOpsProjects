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