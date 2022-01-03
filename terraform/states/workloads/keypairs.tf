
resource "aws_key_pair" "ssh_key" {
  for_each        = { for name, key in var.key_pairs : name => key }
  key_name_prefix = each.key
  public_key      = each.value
}


