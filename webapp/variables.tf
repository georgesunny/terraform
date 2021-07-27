## Environmental Variables
variable "environment" {}
variable "app_name" {}
variable "org_name" {}
variable "region" {}

## WebApp Variables
variable "webapp_instance_ami" {}
variable "webapp_instance_type" {}
variable "webapp_disk_size" {}

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "app_subnet_id" {}
variable "pub_subnet_id" {}
variable "s3_bucket_name" {}
# variable "domain_name" {}