output "instance_id" {
  value = "${aws_db_instance.rds_database.*.id}"
}

output "instance_address" {
  value = "${aws_db_instance.rds_database.*.address}"
}

output "rds_dns" {
  value = "${aws_route53_record.rds_dns.fqdn}"
}
