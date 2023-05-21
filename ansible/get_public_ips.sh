#!/bin/bash

# Read the JSON data from standard input
json_data=$(cat)

# Extract the public IP addresses using jq
app_ip=$(echo "$json_data" | jq -r '.outputs.vm_public_addresses.value.app.public_ip_address')
db_ip=$(echo "$json_data" | jq -r '.outputs.vm_public_addresses.value.db.public_ip_address')

# Write the IP addresses to the desired format
cat <<EOF > inventory.yml
app_servers:
  hosts:
    app1:
      ansible_host: $app_ip
db_servers:
  hosts:
    db1:
      ansible_host: $db_ip
EOF

echo "Inventory file 'inventory.yml' created."
