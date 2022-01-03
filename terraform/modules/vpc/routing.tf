
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.current.id

  tags = (merge(
    tomap({ "Name" = format("%s-dmz", var.vpc_name) }),
    var.main_tags
  ))
}

resource "aws_route_table" "vpc_dmz" {
  vpc_id = aws_vpc.current.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
  tags = (merge(
    tomap({ "Name" = format("%s-dmz", var.vpc_name) }),
    var.main_tags
  ))
}

resource "aws_route_table_association" "vpc_dmz" {
  count          = length(var.dmz_subnets)
  subnet_id      = aws_subnet.dmz_subnets[count.index].id
  route_table_id = aws_route_table.vpc_dmz.id
}


### Private networks routing ###

# We'll create IPs and NAT gateways as much as we have DMZ networks.
# They will take care for private networks traffic, however, they needs to be placed in DMZ!
resource "aws_eip" "private_net_gw" {
  count = length(var.dmz_subnets)
  vpc   = true
  depends_on = [
    aws_internet_gateway.internet_gw
  ]
}

resource "aws_nat_gateway" "private_net_gw" {
  count         = length(var.dmz_subnets)
  allocation_id = element(aws_eip.private_net_gw.*.allocation_id, count.index)
  subnet_id     = element(aws_subnet.dmz_subnets.*.id, count.index)

  tags = (merge(
    tomap({ "Name" = format("%s-%s-gw", var.vpc_name, element(aws_subnet.dmz_subnets.*.availability_zone, count.index)) }),
    var.main_tags
  ))

}

resource "aws_route_table" "vpc_private" {
  count  = length(var.dmz_subnets)
  vpc_id = aws_vpc.current.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private_net_gw.*.id, count.index)
  }

  tags = (merge(
    tomap({ "Name" = format("%s-%s-private", var.vpc_name, element(aws_subnet.dmz_subnets.*.availability_zone, count.index)) }),
    var.main_tags
  ))
}

# This is a little bit magic, we'll associations again by the number
# of DMZ networks, however, will associate compute network in the same AZ.
# This will require to have at least the number of compute networks as DMZ.
resource "aws_route_table_association" "vpc_private" {
  count          = length(var.dmz_subnets)
  subnet_id      = one([for s in aws_subnet.compute_subnets : s.id if s.availability_zone == element(aws_subnet.dmz_subnets.*.availability_zone, count.index)])
  route_table_id = element(aws_route_table.vpc_private.*.id, count.index)
}
