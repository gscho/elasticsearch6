variable "region" {
  default = "us-east-1"
}

variable "access_key" {}

variable "secret_key" {}

variable "vpc_id" {
  default = "vpc-5ef5af27"
}

variable "environment" {
  default = "dev"
}

variable "master_subnet_id" {
  default = "subnet-bef3f3f6"
}

variable "master_instance_type" {
  default = "t2.medium"
}

variable "master_ami_id" {
  default = "ami-43a15f3e"
}

variable "master_az" {
  default = "us-east-1a"
}

variable "master_node_count" {
  default = 1
}

variable "data_node_count" {
  default = 2
}

variable "data_subnet_id" {
  default = "subnet-bef3f3f6"
}

variable "data_instance_type" {
  default = "t2.medium"
}

variable "data_ami_id" {
  default = "ami-43a15f3e"
}

variable "data_az" {
  default = "us-east-1a"
}
