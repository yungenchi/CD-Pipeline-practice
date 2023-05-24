#!/bin/bash

# Read the JSON data from standard input
json_data=$(cat)

# Extract the public IP addresses using jq
app1_ip=$(echo "$json_data" | jq -r '.outputs.app_vm_public_addresses.value.app1.public_ip_address')
app2_ip=$(echo "$json_data" | jq -r '.outputs.app_vm_public_addresses.value.app2.public_ip_address')
db_ip=$(echo "$json_data" | jq -r '.outputs.db_vm_public_addresses.value.db.public_ip_address')

# Write the IP addresses to the desired format
cat <<EOF > inventory.yml
app_servers:
  hosts:
    app1:
      ansible_host: $app1_ip
    app2:
      ansible_host: $app2_ip
db_servers:
  hosts:
    db1:
      ansible_host: $db_ip
EOF


# Check if the variable is not null
if [ "$db_ip" != "null" ]; then
  echo "Inventory file 'inventory.yml' created."
else
  echo "Error occur when getting ip address"
fi