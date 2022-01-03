locals {
  dmz_subnets = flatten([
    for vpc, subnets in data.terraform_remote_state.base.outputs.dmz_subnets : [
      for subnet_key, subnet in subnets : {
        vpc_key = vpc
        subnet  = subnet
      }
    ]
  ])
  compute_subnets = flatten([
    for vpc, subnets in data.terraform_remote_state.base.outputs.compute_subnets : [
      for subnet_key, subnet in subnets : {
        vpc_key = vpc
        subnet  = subnet
      }
    ]
  ])

}
