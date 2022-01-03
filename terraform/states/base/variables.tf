variable "aws_region" {
  description = "AWS region in which we'll operate."
  type        = string
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}

variable "vpc_networks" {
  description = "List of objects describing VPCs to be created"
  type = list(object({
    name            = string
    cidr            = string
    dns_zone        = string
    compute_subnets = list(string)
    dmz_subnets     = list(string)
  }))
}

variable "main_tags" {
  type    = map(string)
  default = {}
}
