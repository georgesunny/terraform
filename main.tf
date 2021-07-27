module "network" {
  source = "./network"

  environment = var.environment
  app_name = var.app_name
  org_name = var.org_name
  region = var.region

  cidr = var.cidr
  az = var.az
  az_count = var.az_count
  ngw_count = var.ngw_count
}

module "webapp" {
  source = "./webapp"

  environment = var.environment
  app_name = var.app_name
  org_name = var.org_name
  region = var.region

  webapp_instance_ami = var.webapp_instance_ami
  webapp_instance_type = var.webapp_instance_type
  webapp_disk_size = var.webapp_disk_size

  vpc_id = module.network.vpc_id
  vpc_cidr = var.cidr["vpc"]
  app_subnet_id = module.network.appsubnets_ids
  pub_subnet_id = module.network.pubsubnets_ids
  s3_bucket_name = aws_s3_bucket.webapp_s3.id
  # hosted_zone_id = aws_route53_zone.environment_private.zone_id
  # domain_name = var.domain_name
}