provider "aws" {
  region = local.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
    "kubernetes.io/cluster/dev-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/dev-cluster" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/dev-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
