#!/bin/bash

# Use terraform to create app and db ec2 instance
echo "----------Use terraform to create app and db ec2 instance----------"
cd infra
yes yes | terraform apply
cd ..

echo "----------Disable host key checking to aviod answer yes to new connection----------"
cd ansible
# Disable host key checking to aviod answer yes to new connection
export ANSIBLE_HOST_KEY_CHECKING=False

echo "----------Create the inventory.yml with ip_address getting from terraform.tfstate----------"
# Create the inventory.yml with ip_address getting from terraform.tfstate
cat ../infra/terraform.tfstate | bash get_public_ips.sh

echo "----------Use ansible to set-up db ec2 docker----------"
# Use ansible to set-up db ec2 docker
ansible-playbook db-playbook.yml -i inventory.yml --private-key ~/.ssh/tf_key

echo "----------Use ansible to set-up app ec2 docker----------"
# Use ansible to set-up app ec2 docker
ansible-playbook app-playbook.yml -i inventory.yml --private-key ~/.ssh/tf_key