variable "bucket_name" {
  description = "Unique name of the bucket for Mass Email"
  type        = string
}

variable "region" {
  description = "Region you want to run the bucket in"
  type        = string
}

variable "file_name" {
  description = "Name of the file to be uploaded"
  type        = string
}

variable "pandas_account_id"{
  description = "AWS account ID of the owner of the Lambda layer 'AWSSDKPandas-Python38' version '15'"
  type        = string
}

variable "mail_from" {
  description = "Sender e-mail id"
  type        = string
}

variable "my_db_table" {
  description = "Name of the dynamo DB table"
  type        = string
}