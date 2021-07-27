resource "aws_launch_template" "webbapp_lt" {
  name_prefix   = "${var.org_name}_${var.app_name}_${var.environment}_webapp_lt"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.webapp_disk_size
      volume_type = "gp3"
      encrypted   = true
      delete_on_termination = true
    }
  }
  user_data            = base64encode(data.template_cloudinit_config.webapp_bootstrap.rendered)
  iam_instance_profile { name = aws_iam_instance_profile.webapp_instance_profile.name }
  key_name                  = "${var.org_name}_${var.app_name}_${var.environment}_keypair.pem"
  vpc_security_group_ids    = [aws_security_group.webapp_sg.id]
  image_id      = var.webapp_instance_ami
  instance_type = var.webapp_instance_type
  tag_specifications {
    resource_type = "instance"
    tags          =   {
      Name  =   "${var.org_name}_${var.app_name}_${var.environment}_webapp_node"
      env = var.environment
      app = var.app_name
      created_by = "terraform"
    } 
  }
  tag_specifications {
    resource_type = "volume"
    tags          =   {
      Name  =   "${var.org_name}_${var.app_name}_${var.environment}_webapp_volume"
      env = var.environment
      app = var.app_name
      created_by = "terraform"
    } 
  }
  tags    =   {
    Name  =   "${var.org_name}_${var.app_name}_${var.environment}_lt"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }


}

resource "aws_autoscaling_group" "webapp_asg" {
  name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_asg"
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  vpc_zone_identifier = var.app_subnet_id
  launch_template {
    id      = aws_launch_template.webbapp_lt.id
    version = "$Latest"
  }
  tag {
    key = "Name"  
    value =  "${var.org_name}_${var.app_name}_${var.environment}_webapp"
    propagate_at_launch = true
  }
  tag {    
    key = "env"
    value = var.environment
    propagate_at_launch = true
  }
  tag {    
    key = "app"
    value = var.app_name
    propagate_at_launch = true
  }
  tag {    
    key = "created_by"
    value  = "terraform"
    propagate_at_launch = true
  }  
  lifecycle {
      ignore_changes = [
        launch_template
      ]
  }    
}

resource "aws_autoscaling_attachment" "asg_attachment_tg" {
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.id
  alb_target_group_arn   = aws_lb_target_group.webapp_tg.arn
  lifecycle {
      ignore_changes = [
        alb_target_group_arn,
        autoscaling_group_name
      ]
  }  
}