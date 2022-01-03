variable "ami_id" {
  type = string
}

variable "instance_name" {
  type    = string
  default = ""
}

variable "instance_prefix" {
  type    = string
  default = ""
}
variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "root_device" {
  type = object({
    size = number
    type = string
  })
}

variable "ebs_devices" {
  type = list(object({
    size = number
    type = string
    name = string
  }))
  default = []
}

variable "public_ip" {
  type    = bool
  default = false

}

variable "ansible_groups" {
  type    = list(string)
  default = ["all"]
}
