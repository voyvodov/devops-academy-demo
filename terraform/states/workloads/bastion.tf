
resource "ansible_group" "bastions" {
  inventory_group_name = "bastions"
  children = [
    for g in ansible_group.vpc_bastions : g.inventory_group_name
  ]
  vars = {

  }
}

resource "ansible_group" "vpc_bastions" {
  for_each             = data.terraform_remote_state.base.outputs.vpc_ids
  inventory_group_name = "bastion_${each.key}"
  vars = {
    ansible_user = "ubuntu"
    aws_vpc      = each.key
  }
}

resource "aws_security_group" "bastion" {
  for_each    = data.terraform_remote_state.base.outputs.vpc_ids
  name        = "allow_bastion_external_${each.key}"
  description = "Allow Bastions inbound traffic"
  vpc_id      = each.value

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_bastion_external_${each.key}"
  }
}

module "bastion" {
  for_each               = data.terraform_remote_state.base.outputs.vpc_ids
  ami_id                 = "ami-0d527b8c289b4af7f"
  source                 = "../../modules/vm"
  instance_prefix        = format("%s-bastion", each.key)
  instance_type          = "t2.micro"
  subnet_id              = element(data.terraform_remote_state.base.outputs.dmz_subnets[each.key], 0)
  vpc_security_group_ids = [aws_security_group.bastion[each.key].id]
  key_name               = aws_key_pair.ssh_key["bastion"].key_name
  root_device = {
    size = 8
    type = null
  }
  ansible_groups = [ansible_group.vpc_bastions[each.key].inventory_group_name]
  public_ip      = true
}
