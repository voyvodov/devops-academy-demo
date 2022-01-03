variable "aws_region" {
  description = "AWS region in which we'll operate."
  type        = string
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}


variable "main_tags" {
  type    = map(string)
  default = {}
}

variable "key_pairs" {
  type    = map(string)
  default = {}
}

variable "workers" {
  type = list(object({
    count    = number
    vpc_name = string
  }))
}

