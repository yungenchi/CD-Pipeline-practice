#!/bin/bash

# Read the URL from a file
url=$(cat a2_front)

# Make the curl request and store the response in a variable
response=$(curl -s "$url")

# Check if the response contains the text "Foo app" and output true/false
if echo "$response" | grep -q "Foo app"; then
  echo "The app is already deployed"
  echo "Exiting the program...(with error code)"
  exit 1 
else
  echo "false"
fi