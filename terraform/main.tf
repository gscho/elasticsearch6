provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_key_pair" "elasticsearch" {
  key_name   = "elasticsearch"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDegRe6I9ytSXkxKfcqcQju8j0N1HqP4/sGlP7WjbMs4a2eDWb+yLjhpNtal7bheQ59nXS7WW2qN87DEWnN2WJbeRv9eRAk4dQX8cLMdmKHGSNJsD+PJ3BnWlBqht/lg3lQnklHKVuGJoYZpn+6BzD5Pz7CPvA7Bxo6BBIgrTgDgMj3u4IpXAD967u4tGLofI12P8p46vsLdCwe3wNfhSj2f462CYwt6d5qWwRx4un5uuOU3w2n0BBatAVupOKibajwrqznQ2spMmmn9Sb9njST1R+dmDJbqsRTjXBFneFhzUAfrZb16dh0yJ220uEzNOWTk6rlbITxYUkaqnJ31yt/ gschofield@Gregorys-MacBook-Pro.local"
}

module "elasticsearch" {
  source               = "elasticsearch"
  vpc_id               = "${var.vpc_id}"
  environment          = "${var.environment}"
  master_image_user    = "ubuntu"
  master_private_key   = "${file("./es.pem")}"
  master_key_name      = "${aws_key_pair.elasticsearch.id}"
  master_subnet_id     = "${var.master_subnet_id}"
  master_instance_type = "${var.master_instance_type}"
  master_ami_id        = "${var.master_ami_id}"
  master_az            = "${var.master_az}"
  master_node_count    = "${var.master_node_count}"

  data_image_user    = "ubuntu"
  data_private_key   = "${file("./es.pem")}"
  data_key_name      = "${aws_key_pair.elasticsearch.id}"
  data_subnet_id     = "${var.data_subnet_id}"
  data_instance_type = "${var.data_instance_type}"
  data_ami_id        = "${var.data_ami_id}"
  data_az            = "${var.data_az}"
  data_node_count    = "${var.data_node_count}"
}
