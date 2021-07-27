##VPC##
resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr["vpc"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_vpc"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Network Access Control Layer(NACL)##
resource "aws_default_network_acl" "nacl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_nacl"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
  lifecycle {
      create_before_destroy = true
      ignore_changes = [
        subnet_ids
      ]
  }
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.cidr["vpc"]
    from_port  = 0
    to_port    = 0
  }
  #Opening port range so that AWS services can communicate each other
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  #Opening port range so that AWS services can communicate each other
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = -1
    rule_no    = 130
    action     = "allow"
    cidr_block = var.cidr["vpc"]
    from_port  = 0
    to_port    = 0
  }
}

##Internet Gateway##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}-igw"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Elastic IP for Nat Gateway##
resource "aws_eip" "eip_ngw" {
  vpc   = true
  count = var.ngw_count
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_ngw_eip"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Nat Gateway##
resource "aws_nat_gateway" "ngw" {
  allocation_id = element(aws_eip.eip_ngw.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]
  count         = var.ngw_count
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_ngw"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##App Subnet Route Table##
resource "aws_route_table" "app_subnet_rt" {
  vpc_id = aws_vpc.vpc.id
  count  = var.az_count
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_app_subnet_routetable"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Route to Internet Using Nat Gateway in App Subnet Route Table##
resource "aws_route" "appsubnet_route" {
  count                  = var.az_count
  route_table_id         = element(aws_route_table.app_subnet_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id,var.ngw_count == 1 ? 0 : count.index)
  depends_on             = [aws_route_table.app_subnet_rt]
}

##App Subnet##
resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = lookup(var.cidr, "app_subnet_${count.index+1}")
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = var.az_count
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_app_subnet"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Route Table Association App Subnet##
resource "aws_route_table_association" "app_subnet_rt_association" {
  subnet_id      = element(aws_subnet.app_subnet.*.id, count.index+1)
  route_table_id = element(aws_route_table.app_subnet_rt.*.id, count.index)
  count          = var.az_count
}

##Public Subnet Route Table##
resource "aws_route_table" "pub_subnet_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_public_subnet_routetable"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Public Subnet##
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = lookup(var.cidr, "public_subnet_${count.index+1}")
  availability_zone = "${var.region}${lookup(var.az, "az${count.index+1}")}"
  count             = var.az_count
  tags = {
    Name = "${var.org_name}_${var.app_name}_${var.environment}_public_subnet"
    env = var.environment
    app = var.app_name
    created_by = "terraform"
  }
}

##Route Table Association Public Subnet##
resource "aws_route_table_association" "public" {
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.pub_subnet_rt.id
  count          = var.az_count
}