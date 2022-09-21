variable "allocated_storage" {
  default = "50"
}

variable "allow_major_version_upgrade" {
  default = true
}

variable "apply_immediately" {
  default = false
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "availability_zone" {
  default = "eu-central-1a"
}

variable "aws_region" {
  description = "The AWS region to deploy."
}

variable "backup_retention_period" {
  default = "30"
}

variable "backup_window" {
  default = "04:00-04:30"
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "count" {
  default = 0
}

variable "dns_zone_ttl" {
  default = "60"
}

variable "enable_custom_option_group" {
  default = false
}

variable "enabled_cloudwatch_logs_exports" {
  type = "list"
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "10.4"
}

variable "final_snapshot_identifier" {
  default = ""
}

variable "hostname" {}

variable "identifier" {
  default = ""
}

variable "identifier_prefix" {
  default = ""
}

variable "instance_class" {
  default = "db.t2.medium"
}

variable "instance_number_prefix" {
  default = "%02d"
}

variable "major_engine_version" {
  default = ""
}

variable "maintenance_window" {
  default = "sun:04:30-sun:05:30"
}

variable "multi_az" {
  default = "false"
}

variable "name" {
  default = ""
}

variable "networks_remote_state_key" {}

variable "options" {
  default = []
  type = "list"
}

variable "option_group_description" {
  default = ""
}

variable "option_group_name" {
  default = ""
}

variable "license_model" {
  default = ""
}

# variable "password" {}

variable "parameter_group_name" {
  default = ""
}

variable "parameter_group_description" {
  default = ""
}

variable "parameter_group_family_name" {
  default = ""
}

variable "parameter_group_params" {
  default = []
}


variable "port" {}

variable "public_dns_zone_remote_state_key" {
  default = "hli/route53_zones/public_zone/terraform.tfstate"
}

variable "remote_state_bucket" {}

variable "rds_creds_path" {
    default = "kv/dso/applications/confluence/rds"
}

variable "skip_final_snapshot" {
  default = true
}

variable "storage_encrypted" {
  default = true
}

variable "storage_type" {
  default = "gp2"
}

variable "subnet_group_description" {
  default = ""
}

variable "subnet_group_ids" {
  type    = "list"
  default = []
}

variable "subnet_group_name" {
  default = ""
}

variable "username" {}

variable "vpc_name" {}

variable "vpc_security_group_ids" {
  type    = "list"
  default = []
}

variable "zone_id" {
  default = ""
}

######### Vault Variables ##########
variable "vault_address" {
  default = "https://vault.cloud/"
}
variable "vault_token" {}
