data "aws_availability_zones" "available" {
  state = "available"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "all" {}
data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #version => "2.64.0"
  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr_block
  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)
  intra_subnets   = slice(var.intra_subnet_cidr_blocks, 0, 2)
  enable_dns_support   = true
  enable_dns_hostnames = true
  single_nat_gateway   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  tags = {
    Name  = "${var.environment}-VPC"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}