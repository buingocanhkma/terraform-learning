resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "${coalesce(var.subnet_group_name, format("%s-%s-subnet", var.vpc_name, var.hostname))}"
  description = "${coalesce(var.subnet_group_description, format("%s %s subnet group", var.vpc_name, var.hostname))}"
  subnet_ids = ["${data.terraform_remote_state.networks.private_subnet_id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds-security-group" {
  name        = "${var.vpc_name}-${var.hostname}-rds-sg"
  description = "${var.vpc_name} ${var.hostname} security group"
  vpc_id      = "${data.terraform_remote_state.networks.vpc_id}"

  tags {
    Name = "${var.vpc_name}-${var.hostname}-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds-ingress" {
  type              = "ingress"
  from_port         = "${var.port}"
  to_port           = "${var.port}"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.networks.vpc_cidr_block}"]
  security_group_id = "${aws_security_group.rds-security-group.id}"
}


resource "aws_db_instance" "rds_database" {
  allocated_storage               = "${var.allocated_storage}"
  allow_major_version_upgrade     = "${var.allow_major_version_upgrade}"
  apply_immediately               = "${var.apply_immediately}"
  auto_minor_version_upgrade      = "${var.auto_minor_version_upgrade}"
  availability_zone               = "${var.availability_zone}"
  backup_retention_period         = "${var.backup_retention_period}"
  backup_window                   = "${var.backup_window}"
  copy_tags_to_snapshot           = "${var.copy_tags_to_snapshot}"
  count                           = "${var.count}"
  db_subnet_group_name            = "${aws_db_subnet_group.rds-subnet-group.id}"
  enabled_cloudwatch_logs_exports = "${var.enabled_cloudwatch_logs_exports}"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  final_snapshot_identifier       = "${coalesce(var.final_snapshot_identifier, format("%s-%s-snapshot", var.vpc_name, var.hostname))}"
  instance_class                  = "${var.instance_class}"
  identifier_prefix               = "${coalesce(var.identifier_prefix, format("%s-%s-", var.vpc_name, var.hostname))}"
  license_model                   = "${var.license_model}"
  maintenance_window              = "${var.maintenance_window}"
  multi_az                        = "${var.multi_az}"
  name                            = "${var.name}"
  option_group_name               = "${var.enable_custom_option_group ? coalesce(var.option_group_name, format("%s-%s-og", var.vpc_name, var.hostname)) : ""}"
  parameter_group_name            = "${aws_db_parameter_group.rds_parameter_group.id}"
  password                        = "${data.vault_generic_secret.rds-password.data["password"]}"
  port                            = "${var.port}"
  skip_final_snapshot             = "${var.skip_final_snapshot}"
  storage_encrypted               = "${var.storage_encrypted}"
  storage_type                    = "${var.storage_type}"

  tags {
    Name = "${var.vpc_name}-${var.hostname}-rds"
  }

  username = "${var.username}"

  vpc_security_group_ids = ["${aws_security_group.rds-security-group.id}"]

  lifecycle {
    ignore_changes = ["id", "identifier_prefix"]
  }

  depends_on = ["aws_db_subnet_group.rds-subnet-group"]
}
