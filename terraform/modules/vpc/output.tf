output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.current.id
}

output "compute_subnets" {
  description = "List of IDs of created compute networks"
  value       = aws_subnet.compute_subnets.*.id
}

output "dmz_subnets" {
  description = "List of IDs of created database networks"
  value       = aws_subnet.dmz_subnets.*.id
}

output "dns_zone_id" {
  value       = aws_route53_zone.vpc_dns_zone.id
  description = "The Route53 zone id created for private resolving."
}

