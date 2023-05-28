#!/bin/bash

# Update aws credential
cat aws_credentials > ~/.aws/credentials 

# Update key pair
cp key ~/.ssh/key
cp key.pub ~/.ssh/key.pub

# Use terraform to create app and db ec2 instance
echo "----------Use terraform to create app and db ec2 instance----------"
cd infra
terraform init # For the backend terraform state
yes yes | terraform apply
# Update DNS and ip
bash get_ip.sh
cd ..

echo "----------Disable host key checking to aviod answer yes to new connection----------"
cd ansible
# Disable host key checking to aviodbash set_up.sh answer yes to new connection
export ANSIBLE_HOST_KEY_CHECKING=False

echo "----------Use ansible to set-up db ec2 docker----------"
# Use ansible to set-up db ec2 docker
ansible-playbook db-playbook.yml -i inventory.yml --private-key ~/.ssh/key

echo "----------Use ansible to set-up app ec2 docker----------"
# Use ansible to set-up app ec2 docker
ansible-playbook app-playbook.yml -i inventory.yml --private-key ~/.ssh/key

cd ..