resource "aws_s3_bucket_public_access_block" "webapp_s3" {
  bucket = aws_s3_bucket.webapp_s3.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "webapp_s3" {
  bucket = "${var.org_name}-${var.app_name}-${var.environment}-webapp-s3"
  acl    = "private"
  server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
            sse_algorithm     = "AES256"
        }
    }
  }
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_s3"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}


resource "aws_s3_bucket_object" "ansible_scripts" {
  bucket            = aws_s3_bucket.webapp_s3.id
  key               = "ansible.zip"
  source            = "ansible.zip"
}