resource "aws_route53_record" "rds_dns" {
  # count      = "${var.count}"
  # zone_id    = "${var.zone_id}" # If it's required to be passed in
  zone_id = "${data.terraform_remote_state.public_dns_zone.zone_id}"

  name = "${var.hostname}-rds"
  type = "CNAME"
  ttl  = "${var.dns_zone_ttl}"

  depends_on = [
    "aws_db_instance.rds_database",
  ]

  records = [
    "${element(aws_db_instance.rds_database.*.address, count.index)}",
  ]

  lifecycle {
    ignore_changes = ["allow_overwrite"]
  }
}
