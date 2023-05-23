terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = file(var.path_to_ssh_public_key)
}

locals {
  vms = {
    app = {},
    db  = {}
  }
  allowed_cidrs_for_db = var.allow_all_ip_addresses_to_access_database_server ? ["0.0.0.0/0"] : ["${var.my_ip_address}/32"]
}

resource "aws_instance" "servers" {
  for_each = local.vms

  lifecycle {
    create_before_destroy = true
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name        = aws_key_pair.admin.key_name
  security_groups = [aws_security_group.vms.name]

  tags = {
    Name = "${each.key} server for A2"
  }
}

resource "aws_security_group" "vms" {
  name = "vms_for_a2"

  # SSH
  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP in
  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL in
  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.allowed_cidrs_for_db
  }

  # HTTPS out
  egress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # PostgreSQL out
  egress {
    from_port   = 0
    to_port     =5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vm_public_addresses" {
  value = { for role_name, vm in aws_instance.servers : role_name => {
    public_hostname   = vm.public_dns,
    public_ip_address = vm.public_ip
    }
  }
}
