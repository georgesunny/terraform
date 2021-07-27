resource "aws_iam_instance_profile" "webapp_instance_profile" {
  name  = "${var.org_name}_${var.app_name}_${var.environment}_webapp_instance_profile"
  role = aws_iam_role.webapp_role.name
}

resource "aws_iam_policy" "ec2_access_policy" {
  name   = "${var.org_name}-${var.app_name}-${var.environment}-ec2-access-policy"
  description = "Ec2 Permission - Terraform Managed"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:Put*",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_access_policy" {
  role       = aws_iam_role.webapp_role.name
  policy_arn = aws_iam_policy.ec2_access_policy.arn
}

resource "aws_iam_role" "webapp_role" {
  name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_webapp_role"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.webapp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}