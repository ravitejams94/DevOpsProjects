Script here is used to read the repo and list all the users who have access to the repo.

## Table of Contents
- [Prerequisites](#Prerequisites)
- [Usage](#usage)

## Prerequisites
- AWS account(Free Tier eligible)
- Shell scripting knowledge
- EC2 instance (Key-Pair Setup optional)
- Github Repo (Must have read access or your personal repo would work)

## Usage
1. Login to your AWS account and setup an EC2 instance(Ubuntu machine) with your key pair if setup, or else you can connect directly via AWS.
2. Once connected to your instance, first clone the following repository.

git clone https://github.com/ravitejams94/DevOpsProjects

cd Shell Scripting Projects/Github API

3. Make sure to export your username and github token first.

`export username="<github_username>"

`export token="<github_token>"

4. Make the script executable and then run it as shown below.

chmod +x list_users.sh

./list_users.sh <Repo_owner> <Repo_name>



