# VPC
module "vpc" {
  source = "./network"
  cidr = "10.0.0.0/16"
  vpc_name = var.vpc_name
}

module "eks" {
  source  = "./cluster"
  vpc_id = module.vpc.vpc_id
  cluster-name = var.cluster-name
  eks_subnets = [module.vpc.public_subnet]
  subnet_ids = module.vpc.public_subnet
  # subnet_ids = flatten([module.vpc.public_subnet, module.vpc.private_subnet])
}