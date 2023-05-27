#!/bin/bash

# Run terraform output command and store the result in a variable
terraform_output=$(terraform output -json)

# Extract the IP addresses from app_vm_public_addresses using jq
app1_ip=$(echo "$terraform_output" | jq -r '.app_vm_public_addresses.value.app1.public_ip_address')
app2_ip=$(echo "$terraform_output" | jq -r '.app_vm_public_addresses.value.app2.public_ip_address')

# Extract the IP addresses from db_vm_public_addresses using jq
db_ip=$(echo "$terraform_output" | jq -r '.db_vm_public_addresses.value.db.public_ip_address')

# Extract the DNS addresses from load_balancer_dns_name using jq
a2_front=$(echo "$terraform_output" | jq -r '.load_balancer_dns_name.value')

# Print the extracted IP addresses
echo "App IP: $app1_ip"
echo "App IP: $app2_ip"
echo "DB IP: $db_ip"
echo "A2 DNS: $a2_front"


# Write the IP addresses to the desired format
cat <<EOF > ../ansible/inventory.yml
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

# Write the DNS addresses to the root
cat <<EOF > ../../a2_front
$a2_front
EOF

