output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "appsubnets_ids"{
    value = aws_subnet.app_subnet.*.id
}

output "pubsubnets_ids"{
    value = aws_subnet.public_subnet.*.id
}