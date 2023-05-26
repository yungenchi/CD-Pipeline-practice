#!/bin/bash

# Delete EC2 Instances
instance_names=("app1 server for A2" "app2 server for A2" "db server for A2")

for name in "${instance_names[@]}"
do
  instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" --query "Reservations[].Instances[].InstanceId" --output text)

  if [[ -n "$instance_id" ]]; then
    echo "Instance Name: $name"
    echo "Instance ID: $instance_id"

    aws ec2 terminate-instances --instance-ids "$instance_id"

    echo "Instance termination initiated."
    echo
  else
    echo "Instance with Name '$name' not found."
    echo
  fi
done


# Delete Key Pair
key_name="admin-key"
delete_key_output=$(aws ec2 delete-key-pair --key-name "$key_name" 2>&1)

if [[ $? -eq 0 ]]; then
  echo "Key Pair '$key_name' deleted successfully."
else
  echo "Failed to delete Key Pair '$key_name'. Error message: $delete_key_output"
fi

echo



# Delete Security Group
security_group_name="vms_for_a2"
delete_sg_output=$(aws ec2 delete-security-group --group-name "$security_group_name" 2>&1)

if [[ $? -eq 0 ]]; then
  echo "Security Group '$security_group_name' deleted successfully."
else
  echo "Failed to delete Security Group '$security_group_name'. Error message: $delete_sg_output"
fi

echo


# Delete Target Group
target_group_arn=$(aws elbv2 describe-target-groups | jq -r '.TargetGroups[0].TargetGroupArn')

echo "Target Group ARN: $target_group_arn"

aws elbv2 delete-target-group --target-group-arn "$target_group_arn"

echo "Target Group deleted."
