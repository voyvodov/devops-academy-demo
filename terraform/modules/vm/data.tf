
data "aws_subnet" "selected" {
  id = var.subnet_id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_subnet.selected.vpc_id
  name   = "default"
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}
