resource "aws_security_group" "nexus_alb_security_group" {
  description = "${var.hostname} alb security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["${var.alb_https_port_cidr_blocks}"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  name        = "${var.hostname}_alb_security_group"

  tags {
    Name = "${var.vpc_name}-${var.hostname}-alb-sg"
  }

  vpc_id      = "${data.terraform_remote_state.networks.vpc_id}"
}
