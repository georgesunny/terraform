  data "template_file" "webapp_bootstrap" {
    template          = file("${path.module}/webapp_bootstrap.sh")

    vars = {
      env                           = var.environment
      region                        = var.region
      s3_bucket_name                = var.s3_bucket_name
    }
  }

    data "template_cloudinit_config" "webapp_bootstrap" {
    gzip           = false
    base64_encode  = false

    part {
      content      = data.template_file.webapp_bootstrap.rendered
      content_type = "text/x-shellscript"
    }
  }