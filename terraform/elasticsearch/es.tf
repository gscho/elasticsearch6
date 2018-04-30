resource "aws_security_group" "elasticsearch" {
  name        = "hab_elasticsearch_sg"
  description = "Elasticsearch"
  vpc_id      = "${var.es_vpc_id}"     //"vpc-5ef5af27"

  ingress {
    from_port = 9638
    to_port   = 9638
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 9638
    to_port   = 9638
    protocol  = "udp"
    self      = true
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9631
    to_port     = 9631
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 9638
    to_port     = 9638
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "Elasticsearch Security Group"
    X-Env = "${var.es_env}"
  }
}

resource "aws_instance" "elasticsearch_master" {
  key_name                    = "${var.es_master_key_name}"
  subnet_id                   = "${var.es_master_subnet_id}"               //"subnet-bef3f3f6"
  count                       = "${var.es_master_node_count}"
  instance_type               = "${var.es_master_instance_type}"           //"t2.medium"
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch.id}"]
  associate_public_ip_address = true
  ami                         = "${var.es_master_ami_id}"                  //"ami-43a15f3e"
  availability_zone           = "${var.es_master_az}"                      //"us-east-1a"
  user_data                   = "${file("config/user_data.sh")}"

  provisioner "habitat" {
    peer         = "${aws_instance.elasticsearch_master.0.private_ip}"
    use_sudo     = true
    service_type = "systemd"

    service {
      name      = "gscho/elasticsearch"
      topology  = "leader"
      group     = "cluster"
      user_toml = "${file("./es.toml")}"
    }
  }

  tags {
    Name  = "${format("Elasticsearch Master %03d", count.index +1)}"
    X-Env = "${var.es_env}"
  }
}

resource "aws_instance" "elasticsearch_data" {
  connection {
    user        = "${var.es_image_user}"             //"ubuntu"
    private_key = "${file("${var.es_private_key}")}"
  }

  key_name                    = "${aws_key_pair.elasticsearch.id}"
  subnet_id                   = "${var.es_data_subnet_id}"
  count                       = "${var.es_data_node_count}"
  instance_type               = "${var.es_data_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch.id}"]
  associate_public_ip_address = true
  ami                         = "${var.es_data_ami_id}"
  availability_zone           = "${var.es_data_az}"
  user_data                   = "${file("config/user_data.sh")}"

  provisioner "habitat" {
    peer         = "${aws_instance.es.0.private_ip}"
    use_sudo     = true
    service_type = "systemd"

    service {
      name      = "gscho/elasticsearch"
      topology  = "leader"
      group     = "cluster"
      user_toml = "${file("./es.toml")}"
    }
  }

  tags {
    Name  = "${format("Elasticsearch Data %03d", count.index +1)}"
    X-Env = "${var.es_env}"
  }
}
