#!/bin/bash

# Read the URL from a file
url=$(cat a2_front)

# Make the curl request and store the response in a variable
response=$(curl -s "$url")

# Check if the response contains the text "Foo app" and return true/false
if echo "$response" | grep -q "Foo app"; then
  echo "true"
  exit 0
else
  echo "false"
  exit 0
fi