resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "${coalesce(var.parameter_group_name, format("%s-%s-pg", var.vpc_name, var.hostname))}"
  description = "${coalesce(var.parameter_group_description, format("%s-%s-parameter-group", var.vpc_name, var.hostname))}"
  family      = "${var.parameter_group_family_name}"

  parameter = ["${var.parameter_group_params}"]

  tags {
    Name = "${var.vpc_name}-${var.hostname}-parameter-group"
  }

  lifecycle {
    create_before_destroy = true
  }
}
