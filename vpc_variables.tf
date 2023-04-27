variable "region" {
  description = "The region Terraform deploys your instances"
  type        = string
}
variable "your_name" {
  description = "your_name"
  type        = string
}
variable "environment" {
  description = "environment"
  type        = string
}
variable "ssh_location" {
  type        = string
  description = "My Public IP Address"
}
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
}
variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
}
variable "intra_subnet_count" {
  description = "Number of private subnets"
  type        = number
}
variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}
variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
  ]
}
variable "intra_subnet_cidr_blocks" {
  description = "Available cidr blocks for database subnets"
  type        = list(string)
  default = [
    "10.0.201.0/24",
    "10.0.202.0/24",
    "10.0.203.0/24",
    "10.0.204.0/24",
    "10.0.205.0/24",
    "10.0.206.0/24",
    "10.0.207.0/24",
    "10.0.208.0/24"
  ]
}




