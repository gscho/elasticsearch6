variable "vpc_id" {}

variable "environment" {
  default = "dev"
}

variable "master_image_user" {
  default = "ubuntu"
}

variable "master_private_key" {}

variable "master_key_name" {
  default = "elasticsearch"
}

variable "master_subnet_id" {}

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

variable "data_image_user" {
  defult = "ubuntu"
}

variable "data_private_key" {}

variable "data_key_name" {}

variable "data_subnet_id" {}

variable "data_instance_type" {
  default = "t2.medium"
}

variable "data_ami_id" {
  default = "ami-43a15f3e"
}

variable "data_az" {
  default = "us-east-1a"
}

variable "data_node_count" {
  default = 2
}
