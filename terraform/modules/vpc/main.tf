/****************************************************
Module VPC

 Create VPC module with:
 - dedicated compute network
 - dedicated database network
 - optional VPC connection
 - optional peering to VPC, which is connected through VPN
 - optional DNS resdolution between connected VPCs

See [Inputs](#Inputs) variables for more details

__Note:__ Do not put pre-shared key in source control;
provide it as environment variable **TF_VAR_VPN_PSK** on terraform execution

Usage: Use in invenroty
```terraform
  module "vpc" "new_vpc" {
    source "path/to/modules/vpc"
    ... parameters here ...
  }
 ```
*******************************************************/

data "aws_availability_zones" "available" {
}

resource "aws_vpc" "current" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      "Name" = var.vpc_name
    },
    var.main_tags,
  )
}

resource "aws_key_pair" "ssh_keypair" {
  count      = length(var.key_pairs)
  key_name   = var.key_pairs[count.index]["key_name"]
  public_key = var.key_pairs[count.index]["public_key"]
}

