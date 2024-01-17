#!/bin/bash

##############################
#
# Author    : Ravi Teja
# Date      : 15 Jan, 2024
# Name      : list_users.sh 
# Function  : This lists all the users of a particular git repo
# Usage     : /list_users.sh <repo_owner> <repo_name>
# Pre reqs  : Make sure to export the Username and token of github account 
###############################

helper{}

# Github API URL
API_URL="https://api.github.com" 

# Github Username and token
USERNAME=$username
TOKEN=$token

# Repo and user information to be given as arguments
REPO_OWNER=$1
REPO_NAME=$2

# Function to make get request
function get_github_api_call {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a get request to Github 
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access
function get_list_users {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    
    # Fetch the list of collaborators on the repository
    collaborators="$(get_github_api_call "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the collaborators
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

function helper {
    cmd_args=2
    if [ $# -ne $cmd_args]; then
        echo "Please execute the script with 2 arguments - Repo_owner and Repo_name"

}

echo "Listing users with read access"
get_list_users 
