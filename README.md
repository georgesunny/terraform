# Terraform
This repository contain the infrastructure creation for sample webapp application

## Write, Plan, Apply:
Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.

## Install terraform:
https://learn.hashicorp.com/tutorials/terraform/install-cli

## Prerequisites
Set the AWS CLI, with a profile name
```sh
aws configure --profile=<name>
```
Create the zip file for ansible folder and place in home location of terraform

## Contents

#### Components
* network module
    This will create basic network to deploy the webapp infrastructure

* webapp
    this is the main module which will create the webapp application infratructure, this contains
    * acm - for self signed certificate
    * alb - application load balancer to load balance the webapp
    * iam - role attached to webapp instances
    * webapp sg - security group to allow trafic to webapp
    * webapp conatins autoscaling group and launch template.
* Ansible
    This folder containes ansible play book to install nginx server and required html file to render when alb dns name is hit in browser

#### Getting Started

set environmental variables
```sh
#environment variables
aws_profile = "vpn-test"
environment = "dev"
app_name = "common"
region = "eu-west-2"
org_name = "main"

#network variables
cidr = {
  vpc                 = "10.10.0.0/16"
  app_subnet_1        = "10.10.0.0/20"
  app_subnet_2        = "10.10.16.0/20"
  app_subnet_3        = "10.10.32.0/20"
  public_subnet_1     = "10.10.48.0/20"
  public_subnet_2     = "10.10.64.0/20"
  public_subnet_3     = "10.10.80.0/20"
}

az_count = 2
ngw_count = 1

webapp_instance_ami = "ami-03ac5a9b225e99b02"
webapp_instance_type = "t3.micro"
webapp_disk_size = "8"

```
save the environmental variables to a file say dev.env.tfvars

1. Terraform Init
```sh
terraform init --var-file=<filename>
```
2. Terraform Plan
```sh
terraform plan --var-file=<filename>
```
3. Terraform apply
```sh
terraform apply --var-file=<filename>
```

Wait for "apply complete!"
Outputs:

webapp = "dns name of loadbalancer"

hit the dns name in browser to view the webapp 

#### Thank You