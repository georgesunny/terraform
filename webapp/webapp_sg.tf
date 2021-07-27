resource "aws_security_group" "webapp_sg" {
  name        = "${var.org_name}-${var.app_name}_${var.environment}_webapp_sg"
  description = "Allow http traffic to webapp servers"
  vpc_id      = var.vpc_id
  
  ingress {
    description = "Incoming internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Incoming internal traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups  = [aws_security_group.webapp_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org_name}-${var.app_name}_${var.environment}_webapp_sg"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

resource "aws_security_group" "webapp_lb_sg" {
  name        = "${var.org_name}-${var.app_name}_${var.environment}_webapp_lb_sg"
  description = "Allow http traffic to webapp servers"
  vpc_id      = var.vpc_id
  
  ingress {
    description = "Incoming http traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Incoming https traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.org_name}-${var.app_name}_${var.environment}_webapp_lb_sg"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}