resource "aws_subnet" "compute_subnets" {
  count                   = length(var.compute_subnets)
  vpc_id                  = aws_vpc.current.id
  cidr_block              = trimspace(element(var.compute_subnets, count.index))
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format(
        "compute-%s",
        element(data.aws_availability_zones.available.names, count.index),
      )
    },
    {
      "Service" = "compute-net"
    },
    var.main_tags,
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "dmz_subnets" {
  count                   = length(var.dmz_subnets)
  vpc_id                  = aws_vpc.current.id
  cidr_block              = trimspace(element(var.dmz_subnets, count.index))
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false


  tags = merge(
    {
      "Name" = format(
        "dmz-%s",
        element(data.aws_availability_zones.available.names, count.index),
      )
    },
    {
      "Service" = "dmz-net"
    },
    var.main_tags,
  )
}

