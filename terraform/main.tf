provider "aws" {
  region     = "${var.es_region}"     //"us-east-1"
  access_key = "${var.es_access_key}" //"AKIAIHQJSFOAPFYD7FCQ"
  secret_key = "${var.es_secret_key}" //"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"
}

module "elasticsearch" {
  source        = "../elasticsearch"
  vpc_id        = "${var.es_vpc_id}"
  environment   = "${var.es_env}"
  public_key    = "${var.es_public_key}"
  user          = "${var.es_image_user}"             //"ubuntu"
  private_key   = "${file("${var.es_private_key}")}"
  subnet_id     = "${var.es_master_subnet_id}"       //"subnet-bef3f3f6"
  count         = "${var.master_node_count}"
  instance_type = "${var.es_master_instance_type}"

  ami               = "${var.es_master_ami_id}" //"ami-43a15f3e"
  availability_zone = "${var.es_master_az}"
}
