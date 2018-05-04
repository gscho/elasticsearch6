provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_key_pair" "elasticsearch-kibana" {
  key_name   = "elasticsearch-kibana"
  public_key = "${file("./es.pub")}"
}

module "elasticsearch-kibana" {
  source               = "elasticsearch-kibana"
  vpc_id               = "${var.vpc_id}"
  environment          = "${var.environment}"
  master_image_user    = "ubuntu"
  master_private_key   = "${file("./es.pem")}"
  master_key_name      = "${aws_key_pair.elasticsearch-kibana.id}"
  master_subnet_id     = "${var.master_subnet_id}"
  master_instance_type = "${var.master_instance_type}"
  master_ami_id        = "${var.master_ami_id}"
  master_az            = "${var.master_az}"
  master_node_count    = "${var.master_node_count}"

  data_image_user    = "ubuntu"
  data_private_key   = "${file("./es.pem")}"
  data_key_name      = "${aws_key_pair.elasticsearch-kibana.id}"
  data_subnet_id     = "${var.data_subnet_id}"
  data_instance_type = "${var.data_instance_type}"
  data_ami_id        = "${var.data_ami_id}"
  data_az            = "${var.data_az}"
  data_node_count    = "${var.data_node_count}"

  kibana_image_user    = "ubuntu"
  kibana_private_key   = "${file("./es.pem")}"
  kibana_key_name      = "${aws_key_pair.elasticsearch-kibana.id}"
  kibana_subnet_id     = "${var.kibana_subnet_id}"
  kibana_instance_type = "${var.kibana_instance_type}"
  kibana_ami_id        = "${var.kibana_ami_id}"
  kibana_az            = "${var.kibana_az}"
}
