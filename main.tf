###############################################################################
# Providers
###############################################################################
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}

###############################################################################
# Terraform main config
###############################################################################
terraform {
  required_version = ">= 1.1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54"
    }
  }
}

###############################################################################
# Data Sources
###############################################################################
data "aws_availability_zones" "available" {}

###############################################################################
# Sample VPC
###############################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Single NAT gateway

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = var.environment
  }
}

###############################################################################
# S3
###############################################################################
module "s3_bucket" {
  source = "./s3_bucket_module/"

  s3_bucket_name = "sftp-middle-office-antonio"
  app_name       = "middle-office-sftp-server-antonio"
}

###############################################################################
# Security Group
###############################################################################
module "security_group_ec2" {
  source = "./security_group_module/"

  name        = "test-sftp-server-sg"
  description = "Security group for SFTP VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow connections from everywhere on port 22"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Environment = var.environment
  }
}
