# resource "aws_route53_zone" "environment_private" {
#   name = var.domain_name

#   tags = {
#     Name = "${var.org_name}-${var.app_name}-${var.environment}-main"
#     env = var.environment
#     app = var.app_name
#     created_by = "terraform"
#   }
# }