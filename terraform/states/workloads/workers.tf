locals {

}

resource "ansible_group" "workers" {
  inventory_group_name = "workers"
  children = [
    for g in ansible_group.vpc_workers : g.inventory_group_name
  ]
  vars = {
  }
}


resource "ansible_group" "vpc_workers" {
  for_each             = data.terraform_remote_state.base.outputs.vpc_ids
  inventory_group_name = "workers_${each.key}"
  vars = {
    aws_vpc      = each.key
    ansible_user = "ubuntu"
    bastion      = module.bastion[each.key].instance_ip
  }
}


resource "aws_security_group" "workers" {
  for_each    = data.terraform_remote_state.base.outputs.vpc_ids
  name        = "allow_bastion_to_workers_${each.key}"
  description = "Allow SSH traffic from bastion to workers"
  vpc_id      = each.value

  ingress {
    description     = "SSH from bastions"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion[each.key].id]
  }

  egress {
    description = "Allow secure internet (HTTPS)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow non-secure internet (HTTP)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_bastion_to_workers_${each.key}"
  }
}

module "workers" {
  # Get all defined workers, for each of them check the count property
  # In a range create a list of map with base info like index, vpc, and name
  # This will "flatten" the list of worker maps into a list of all possible workers.
  # E.g. a list of [{count: 3}, {count: 10}] will result in a list of 13 elements.
  for_each = {
    for idx, i in flatten(
      [for w in var.workers :
        [for c in range(w.count) : {
          vpc   = w.vpc_name,
          name  = format("%s-wrk-%02d", w.vpc_name, c + 1)
          index = c + 1
          }
        ]
      ]
    ) : idx => i
  }
  ami_id        = "ami-0d527b8c289b4af7f"
  source        = "../../modules/vm"
  instance_name = format("%s-wrk%02d", each.value.vpc, each.value.index)
  instance_type = "t2.micro"
  # Distribute instances between AZ/subnets for each VPC (by using vpc property of the map)
  subnet_id              = element(data.terraform_remote_state.base.outputs.compute_subnets[each.value.vpc], each.value.index % length(data.terraform_remote_state.base.outputs.compute_subnets[each.value.vpc]))
  vpc_security_group_ids = [aws_security_group.workers[each.value.vpc].id]
  key_name               = aws_key_pair.ssh_key["compute"].key_name
  root_device = {
    size = 8
    type = null
  }
  ansible_groups = [ansible_group.vpc_workers[each.value.vpc].inventory_group_name]

}


