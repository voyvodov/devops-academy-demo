variable "vpc_name" {
  description = "Set VPC name"
}

variable "cidr_block" {
  description = "[CIDR] Network IP/size for this VPC"
  type        = string
}

variable "compute_subnets" {
  description = "[CIDR] List of networks for each availability zone; used for general-purpose computing"
  type        = list(string)
}

variable "dmz_subnets" {
  description = "[CIDR] List of networks for each availability zone; used for isolation of edge/dmz traffic"
  type        = list(string)
  default     = []
}

variable "dns_zone_name" {
  description = "DNS zone name"
  type        = string
}

variable "key_pairs" {
  type        = list(map(string))
  description = "List of key pairs to set in the VPC. Each element is a map with keys `key_name` and `public_key`."
  default     = []
}

variable "main_tags" {
  description = "Map of additional tags which will be applied to all resources."
  type        = map(string)
  default     = {}
}

