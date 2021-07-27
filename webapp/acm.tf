resource "tls_private_key" "webapp_self" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "webapp_self" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.webapp_self.private_key_pem

  subject {
    common_name  = "www.webapp_self.com"
    organization = "webapp Examples, Inc"
  }

  validity_period_hours = 72
  dns_names = ["www.webapp_self.com"]
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "webapp_self_cert" {
  private_key      = tls_private_key.webapp_self.private_key_pem
  certificate_body = tls_self_signed_cert.webapp_self.cert_pem
}