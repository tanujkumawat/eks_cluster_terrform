#VPC
variable "create_vpc" {
  default = " "
}

variable "vpc_name" {}

variable "cidr" {
  description = "The CIDR block for the VPC."
}


