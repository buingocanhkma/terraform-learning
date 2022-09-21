module "nexus" {
  application                  = "${var.application}"
  associate_public_ip_address  = "${var.associate_public_ip_address}"
  aws_region                   = "${var.aws_region}"
  count                        = "${var.count}"
  dns_zone_id                  = "${data.terraform_remote_state.dns_zone.zone_id}"
  domain                       = "${var.private_domain}"
  environment                  = "${var.environment}"
  hostname                     = "${var.hostname}"
  instance_type                = "${var.instance_type}"
  image_id                     = "${var.image_id}"
  key_name                     = "${var.key_name}"
  networks_remote_state_key    = "${var.networks_remote_state_key}"
  product                      = "${var.product}"
  remote_state_bucket          = "${var.remote_state_bucket}"
  source                       = "git::https://oauth2:n4eXCeto3izAtScbwXhQ@gitlab.allianzuk.cloud/devsecops/infratools/terraform_modules/ec2_instance.git"
  subnet_id                    = "${data.terraform_remote_state.networks.private_subnet_id}"
  user_data                    = "${data.template_file.user_data.*.rendered}"
  vpc_name                     = "${var.vpc_name}"

  vpc_security_group_ids       = [
    "${aws_security_group.nexus_security_group.id}",
  ]

  #EBS Volume Variables
  attach_volume = "${var.attach_ebs_volume}"
  volume_size   = "${var.ebs_volume_size}"
  volume_type   = "${var.ebs_volume_type}"

  #EFS Volume Variables
  attach_efs_volume            = "${var.attach_efs_volume}"
  efs_mount_target_count       = "${var.efs_mount_target_count}"
  efs_mount_target_dns_records = "${var.efs_mount_target_count}"
  efs_volume_sg_name           = "${var.efs_volume_sg_name}"
  nfs_in_port_security_groups  = "${aws_security_group.nexus_security_group.id}"
  vpc_id                       = "${data.terraform_remote_state.networks.vpc_id}"
}
