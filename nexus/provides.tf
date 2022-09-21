provider "aws" {
  region = "${var.aws_region}"
}

provider "vault" {
  address = "${var.vault_address}"
  token   = "${var.vault_token}"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}
