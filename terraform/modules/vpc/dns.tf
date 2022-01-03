resource "aws_route53_zone" "vpc_dns_zone" {
  name = var.dns_zone_name

  vpc {
    vpc_id = aws_vpc.current.id
  }
}

