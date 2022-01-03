aws_region = "eu-central-1"
aws_profile = "tlrk"

vpc_networks = [
  {
    name = "academy1"
    cidr = "172.30.10.0/24"
    dns_zone = "academy.demo.local"
    compute_subnets = [
      "172.30.10.0/26",
      "172.30.10.64/26",
      "172.30.10.128/26",
    ]
    dmz_subnets = [
      "172.30.10.192/28",
      "172.30.10.208/28",
      "172.30.10.224/28",
    ]
  }
]