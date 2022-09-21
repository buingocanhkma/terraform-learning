resource "aws_security_group" "nexus_security_group" {
  description = "${var.hostname} security group"
  name        = "${var.hostname}_security_group"

  tags {
    Application = "${var.application}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}-${var.hostname}-sg"
    Product     = "${var.product}"
  }

  vpc_id      = "${data.terraform_remote_state.networks.vpc_id}"
}

#### Egress rules
resource "aws_security_group_rule" "egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.nexus_security_group.id}"
  to_port           = 0
  type              = "egress"
}

#### Ingress rules
resource "aws_security_group_rule" "ingress_internal_http" {
  cidr_blocks       = ["${var.http_port_cidr_blocks}"]
  from_port         = "${var.nexus_alb_public_port}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.nexus_security_group.id}"
  to_port           = "${var.nexus_alb_public_port}"
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_alb_http" {
  from_port                = "${var.nexus_alb_public_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.nexus_alb_security_group.id}"
  security_group_id        = "${aws_security_group.nexus_security_group.id}"
  to_port                  = "${var.nexus_alb_public_port}"
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_docker_group" {
  from_port                 = "${var.nexus_alb_docker_group_port}"
  protocol                  = "tcp"
  source_security_group_id  = "${aws_security_group.nexus_alb_security_group.id}"
  security_group_id         = "${aws_security_group.nexus_security_group.id}"
  to_port                   = "${var.nexus_alb_docker_group_port}"
  type                      = "ingress"
}

resource "aws_security_group_rule" "ingress_private_docker" {
  from_port                = "${var.nexus_alb_docker_private_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.nexus_alb_security_group.id}"
  security_group_id        = "${aws_security_group.nexus_security_group.id}"
  to_port                  = "${var.nexus_alb_docker_private_port}"
  type                     = "ingress"
}

# ingress ssh
resource "aws_security_group_rule" "ingress_ssh_bastion" {
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.nexus_security_group.id}"
  source_security_group_id = "${data.terraform_remote_state.bastion.sg_id}"
  to_port                  = 22
  type                     = "ingress"
}

# ingress ping
resource "aws_security_group_rule" "ingress_ping" {
  cidr_blocks       = ["${var.icmp_cidr_blocks}"]
  from_port         = "-1"
  protocol          = "icmp"
  security_group_id = "${aws_security_group.nexus_security_group.id}"
  to_port           = "-1"
  type              = "ingress"
}

# (Optional) Only if prometheus-node-exporter is enabled for monitoring
resource "aws_security_group_rule" "prometheus-node-exporter" {
  count                    = "${var.enable_node_exporter_access ? 1 : 0}"
  from_port                = "${var.prometheus_node_exporter_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.nexus_security_group.id}"
  source_security_group_id = "${var.prometheus_sg_id}"
  to_port                  = "${var.prometheus_node_exporter_port}"
  type                     = "ingress"
}
