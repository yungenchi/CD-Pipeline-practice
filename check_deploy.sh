#!/bin/bash

# Read the URL from a file
url=$(cat a2_front)

# Make the curl request and store the response in a variable
response_app=$(curl -s "$url")
response_db=$(curl -s "$url"/foos)

# Check if the response contains both "Foo app" and "Big Big Foo" and return true/false
if echo "$response_app" | grep -q "Foo app" && echo "$response_db" | grep -q "Big Big Foo"; then
  echo "Already deployed"
  exit 0
else
  echo "Not yet deployed"
  exit 1
fi