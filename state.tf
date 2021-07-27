terraform {
  backend "s3" {
    bucket    = "dev-main-infra-common"
    key       = "terraform/dev"
    encrypt   = true
    region    = "eu-west-2"
    profile   = "vpn-test"
  }
}