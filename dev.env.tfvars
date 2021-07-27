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