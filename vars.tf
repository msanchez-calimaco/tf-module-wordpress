variable "instance_type" {
  description = "Type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}
variable "nickname" {
  type        = string
  description = "My Public IP Address"
}
variable "key" {
  description = "EC2 Key Pair Name"
  type        = string
}
variable "user" {
  description = "SQL User for WordPress"
  type        = string
}
variable "dbname" {
  description = "Database name for WordPress"
  type        = string
}
variable "password" {
  description = "User password for WordPress"
  type        = string
}
variable "root_password" {
  description = "User password for WordPress"
  type        = string
}
variable "domain_name" {
  description = "My Domain Name"
  type        = string
}