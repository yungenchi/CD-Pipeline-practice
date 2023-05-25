# COSC2759 Assignment 2

## Student details

- Full Name: **Yung-En Chi**
- Student ID: **s3864916**

## Overall Set-Up
- Set-up flow chart:

![overall](https://github.com/rmit-computing-technologies/DevOps_A2/assets/77286183/35f1b24c-b647-4454-b57b-56bffc1159cc)

Here is a overall set up flow chart that represent the step of how application is auto deploy. The step is same as in the _set_up.sh_.
By running _set_up.sh_ the steps of deployment will be automatically proceed.
- There are in total three ec2 instance be set-up, two of them are for the app front-end server, one of them is for the. db server instance. Both the app and db server takes the approach of running the docker image on the instances to host the servers.


## Creation & set-up of servers (Terraform)
The creation and set-up of servers rules are done by terraform.
All the terraform set-up code is in the dirctory in ~/misc/infra. 
With in the ~/misc/infra, use the command to run all tf file to set up all the servers:
```
terraform apply
```

#### Creation of instance
I use terraform to deploy three ec2 instance on AWS. Two of them are for running the app server, one of them are for running the db server. The instraction of creating the three ec2 instance is in _main.tf_ where the names is set up as local variable as vms_app:{app1, app2}, and vms_db:{db}
#### Security group set-up

![SG ports](https://github.com/rmit-computing-technologies/DevOps_A2/assets/77286183/bb1f51a5-8487-4904-88c3-e3adffdc6398)

Above is an simple chart about the connection of a normal process of how accessing the application will be like. Note that this is just a simple illustration of how the generall port would use, it does not explain the detail how loadbalancer works. The illustration of load balancer will be explain at the section below

For the inbound rules, SSH (22) , HTTP (80) , PostgreSQL (5432) are opened. 
For the output rules HTTPS (443), PostgreSQL (5432) are opened.
SSH is for when managing the two types of instance, 
HTTP is for accessing from the web to the app instances, 
PostgreSQL inbound rules open is for accessing the db,
Postgre outbound rules is open for app to connect to the db host.

To keep it simple, I only create one security group for the both type of servers. 
#### Load balancer set up

![lb](https://github.com/rmit-computing-technologies/DevOps_A2/assets/77286183/b858770f-bfb3-488f-b0d9-f336f5ea5bab)

Above is the relation graph of the set up of load balancer.
When user enter the DNS name/ip address of the load blancer (eg. http://a2-front-1509149884.us-east-1.elb.amazonaws.com), the listener of the load balancer will forward to the taget group (ie. a2-front). The taget group have two attachment ec2 instance, so the access is going to be forward to one of the instance.


