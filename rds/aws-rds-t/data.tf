data "terraform_remote_state" "networks" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.networks_remote_state_key}"
    region = "${var.aws_region}"
  }
}

data "vault_generic_secret" "rds-password" {
  path = "${var.rds_creds_path}"
}

data "terraform_remote_state" "public_dns_zone" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.public_dns_zone_remote_state_key}"
    region = "${var.aws_region}"
  }
}
