resource "aws_db_option_group" "rds_option_group" {
  count                    = "${var.enable_custom_option_group}"
  name                     = "${coalesce(var.option_group_name, format("%s-%s-og", var.vpc_name, var.hostname))}"
  option_group_description = "${coalesce(var.option_group_description, format("%s-%s-option-group", var.vpc_name, var.hostname))}"
  engine_name              = "${var.engine}"
  major_engine_version     = "${var.major_engine_version}"
  option                   = "${var.options}"

}
