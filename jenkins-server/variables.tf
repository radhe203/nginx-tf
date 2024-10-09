variable "cidr" {
  description = "vpc cidr"
}

variable "public_cidr" {
  description = "public subnets cidr for vpc"
  type        = list(string)
}

variable "ec2_instance" {
  type = string
}

variable "key_name" {
  type = string
}