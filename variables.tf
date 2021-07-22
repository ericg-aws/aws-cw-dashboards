### shared 

variable "project" {
  description = "Associated project or app"
  type        = string
}

variable "environment" {
  description = "Associated environment"
  type        = string
}

variable "region" {
  description = "Associated region"
  type        = string
}

### vpc module

variable "vpc_name_postfix" {
  description = "Name of VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}
variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list
  default     = ["us-east-1a", "us-east-1c"]
}
variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
}
variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
}
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}
variable "vpc_one_nat_gateway_per_az" {
  description = "Enable NAT gateway per AZ"
  type        = bool
  default     = true
}
variable "vpc_enable_dns_hostnames" {
  description = "Enable public DNS hostnames for VPC"
  type        = bool
  default     = true
}
variable "vpc_enable_dns_support" {
  description = "Enable DNS resolution"
  type        = bool
  default     = true
}

###  security group

variable "sgr_ingress_cidr_blocks" {
  description = "Source networks for incoming traffic"
  type        = list(string)
}

###  ssh key pair

variable "kpr_key_name" {
  description = "key pair name"
  type        = string
}
variable "kpr_public_key" {
  description = "PEM public key"
  type        = string
}

### ec2 

variable "ec2_analytics_small_ami_id" {
  description = "AMI instance ID"
  type        = string
}
variable "ec2_analytics_instance_count" {
  description = "Instance count"
  type        = number
}
variable "ec2_analytics_small_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "ec2_analytics_small_placement_group" {
  description = "ec2 placement group type"
  type        = string
}
