
output "compute_subnets" {
  value = {
    for vpc_key, vpc in module.vpc : vpc_key => vpc.compute_subnets
  }
}

output "dmz_subnets" {
  value = {
    for vpc_key, vpc in module.vpc : vpc_key => vpc.dmz_subnets
  }
}

output "vpc_ids" {
  value = {
    for vpc_key, vpc in module.vpc : vpc_key => vpc.vpc_id
  }
}
