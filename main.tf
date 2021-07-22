provider "aws" {
    region = var.region
}

locals {
  name_prefix = "${var.project}_${var.environment}"
}

locals {
  common_tags = {
    terraform           = "true"
    terraform_workspace = terraform.workspace
    project             = var.project
    environment         = var.environment
    auto-delete         = "no"
  }
}

module "vpc_01" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.2, < 4.0"
  name    = "${var.environment}_${var.vpc_name_postfix}"
  azs     = var.vpc_azs

  cidr            = var.vpc_cidr
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway    = var.vpc_enable_nat_gateway
  enable_dns_hostnames  = var.vpc_enable_dns_hostnames
  enable_dns_support    = var.vpc_enable_dns_support

  create_igw = "true"

  tags = local.common_tags
}

module "sgr_ssh" {
  source = "terraform-aws-modules/security-group/aws"
  version = ">= 4.3.0, < 5.0"
  name                = "general-access"
  description         = "Security group for SSH access from home office"
  vpc_id              = module.vpc_01.vpc_id

  ingress_cidr_blocks = var.sgr_ingress_cidr_blocks

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh port"
      self        = true
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "all ports"
      cidr_blocks = "0.0.0.0/0"
      self        = true
    }
  ]

  tags = local.common_tags
}
