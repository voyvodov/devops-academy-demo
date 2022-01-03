
resource "aws_instance" "instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : [data.aws_security_group.default.id]
  key_name                    = var.key_name
  user_data_base64            = base64encode(var.user_data)
  associate_public_ip_address = var.public_ip

  root_block_device {
    volume_size = var.root_device.size
    volume_type = var.root_device.type == "" ? "gp2" : var.root_device.type
  }

  dynamic "ebs_block_device" {
    for_each = { for k, ebs in var.ebs_devices : k => ebs }
    content {
      device_name = ebs.value.name
      volume_size = ebs.value.size
      volume_type = ebs.value.type == "" ? "gp2" : ebs.value.type
    }
  }

  tags = {
    Name = var.instance_name == "" ? format("%s-%s", var.instance_prefix, data.aws_subnet.selected.availability_zone) : var.instance_name
  }
}


resource "ansible_host" "instance" {
  inventory_hostname = aws_instance.instance.id
  groups             = var.ansible_groups
  vars = {
    ansible_host = aws_instance.instance.public_ip != "" ? aws_instance.instance.public_ip : aws_instance.instance.private_ip
  }
  depends_on = [aws_instance.instance]
}
