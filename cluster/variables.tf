variable "cluster-name" {}

variable "vpc_id" {
  description = "VPC ID "
}

variable "eks_subnets" {
  description = "Master subnet ids"
  type = list
}

variable "subnet_ids" {
  type = list
  # default = []
  description = "List of all subnet in cluster"
}


variable "endpoint_public_access" {
  type = bool
  default = true
}

variable "endpoint_private_access" {
  type = bool
  default = false
}