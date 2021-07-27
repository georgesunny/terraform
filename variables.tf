## Environmental Variables
variable "aws_profile" {
  default = "vpn-test"
}
variable "environment" {
  default = "dev"
}
variable "app_name" {
  default = "common"
}
variable "org_name" {
  default = "main"
}
variable "region" {
  description = "The target AWS region"
}

## Network Variables
variable "cidr" {
  default = {
    vpc                 = "10.10.0.0/16"
    app_subnet_1        = "10.10.0.0/20"
    app_subnet_2        = "10.10.16.0/20"
    app_subnet_3        = "10.10.32.0/20"
    public_subnet_1     = "10.10.48.0/20"
    public_subnet_2     = "10.10.64.0/20"
    public_subnet_3     = "10.10.80.0/20"
  }
}
variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than wu-west-2 is used"
  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}
variable "az_count" {
  description = "The number of AZ's in the given region."
}
variable "ngw_count"{
  description = "NAT Gateway Count"
}

## WebApp Variables
variable "webapp_instance_ami" {
    default = "ami-03ac5a9b225e99b02"
}
variable "webapp_instance_type" {
    default = "t3.small"
}
variable "webapp_disk_size" {
  default = "8"
}

# variable "domain_name" {
#   default = "webapp.main-common.io"
# }