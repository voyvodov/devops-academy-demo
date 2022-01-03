
module "vpc" {
  for_each        = { for vpc in var.vpc_networks : vpc.name => vpc }
  source          = "../../modules/vpc"
  vpc_name        = each.value.name
  cidr_block      = each.value.cidr
  dns_zone_name   = each.value.dns_zone
  compute_subnets = each.value.compute_subnets
  dmz_subnets     = each.value.dmz_subnets
  main_tags       = var.main_tags
}
