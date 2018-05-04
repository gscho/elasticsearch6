resource "aws_security_group" "elasticsearch-kibana" {
  name        = "hab_elasticsearch_kibana"
  description = "Elasticsearch-Kibana"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 9638
    to_port   = 9638
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9300
    to_port   = 9300
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9638
    to_port   = 9638
    protocol  = "udp"
    self      = true
  }

  ingress {
    from_port = 9200
    to_port   = 9200
    protocol  = "tcp"
    self      = true
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
    Name  = "Elasticsearch-Kibana Security Group"
    X-Env = "${var.environment}"
  }
}

data "template_file" "es_master_config" {
  template = "${file("${path.module}/templates/es_master.toml.tpl")}"

  vars {
    minimum_master_nodes = "${floor(("${var.master_node_count}")/2) + 1}"
  }
}

resource "aws_instance" "elasticsearch_master" {
  connection {
    user        = "${var.master_image_user}"
    private_key = "${var.master_private_key}"
  }

  key_name                    = "${var.master_key_name}"
  subnet_id                   = "${var.master_subnet_id}"
  count                       = "${var.master_node_count}"
  instance_type               = "${var.master_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch-kibana.id}"]
  associate_public_ip_address = true
  ami                         = "${var.master_ami_id}"
  availability_zone           = "${var.master_az}"
  user_data                   = "${file("${path.module}/config/user_data.sh")}"

  provisioner "habitat" {
    peer         = "${aws_instance.elasticsearch_master.0.private_ip}"
    use_sudo     = true
    service_type = "systemd"

    service {
      name      = "gscho/elasticsearch"
      topology  = "leader"
      group     = "cluster"
      user_toml = "${data.template_file.es_master_config.rendered}"
    }
  }

  tags {
    Name  = "${format("Elasticsearch Master %03d", count.index +1)}"
    X-Env = "${var.environment}"
  }
}

data "template_file" "es_data_config" {
  template = "${file("${path.module}/templates/es_data.toml.tpl")}"

  vars {
    minimum_master_nodes = "${floor(("${var.master_node_count}")/2) + 1}"
  }
}

resource "aws_instance" "elasticsearch_data" {
  connection {
    user        = "${var.data_image_user}"
    private_key = "${var.data_private_key}"
  }

  key_name                    = "${var.data_key_name}"
  subnet_id                   = "${var.data_subnet_id}"
  count                       = "${var.data_node_count}"
  instance_type               = "${var.data_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch-kibana.id}"]
  associate_public_ip_address = true
  ami                         = "${var.data_ami_id}"
  availability_zone           = "${var.data_az}"
  user_data                   = "${file("${path.module}/config/user_data.sh")}"

  provisioner "habitat" {
    peer         = "${aws_instance.elasticsearch_master.0.private_ip}"
    use_sudo     = true
    service_type = "systemd"

    service {
      name      = "gscho/elasticsearch"
      topology  = "leader"
      group     = "cluster"
      user_toml = "${data.template_file.es_data_config.rendered}"
    }
  }

  tags {
    Name  = "${format("Elasticsearch Data %03d", count.index +1)}"
    X-Env = "${var.environment}"
  }
}

resource "aws_instance" "kibana" {
  connection {
    user        = "${var.kibana_image_user}"
    private_key = "${var.kibana_private_key}"
  }

  key_name                    = "${var.kibana_key_name}"
  subnet_id                   = "${var.kibana_subnet_id}"
  count                       = "${var.kibana_node_count}"
  instance_type               = "${var.kibana_instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch-kibana.id}"]
  associate_public_ip_address = true
  ami                         = "${var.kibana_ami_id}"
  availability_zone           = "${var.kibana_az}"

  provisioner "habitat" {
    peer         = "${aws_instance.elasticsearch_master.0.private_ip}"
    use_sudo     = true
    service_type = "systemd"

    service {
      name     = "core/kibana"
      topology = "standalone"

      bind {
        alias   = "elasticsearch"
        service = "elasticsearch"
        group   = "cluster"
      }
    }
  }

  tags {
    Name  = "${format("Kibana %03d", count.index +1)}"
    X-Env = "${var.environment}"
  }
}
