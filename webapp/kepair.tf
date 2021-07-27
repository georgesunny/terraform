resource "tls_private_key" "environment_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "environment_keypair" {
  key_name = "${var.org_name}_${var.app_name}_${var.environment}.pem"
  public_key      = tls_private_key.environment_key.public_key_openssh
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}.pem"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
   }
}

resource "aws_secretsmanager_secret" "environment_pem_key" {
  name = "${var.org_name}_${var.app_name}_${var.environment}.pem"
  description = "Environment pem file"
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}.pem"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
   }

}

resource "aws_secretsmanager_secret_version" "secret_key_value" {
  secret_id     = aws_secretsmanager_secret.environment_pem_key.id
  secret_string = tls_private_key.environment_key.private_key_pem
}