output "alb_dns_name" {
    value = "${aws_lb.nexus_alb.*.dns_name}"
}
output "efs_file_system_id" {
    value = "${module.nexus.efs_file_system_id}"
}
output "efs_mount_target_dns" {
    value = "${module.nexus.efs_mount_target_dns}"
}
output "efs_mount_target_network_interface_id" {
    value = "${module.nexus.efs_mount_target_network_interface_id}"
}
output "efs_mount_target_ip" {
    value = "${module.nexus.efs_mount_target_ip}"
}
output "efs_volume_dns" {
    value = "${module.nexus.efs_volume_dns}"
}
output "instance_dns" {
    value = "${module.nexus.instance_dns}"
}
output "instance_id" {
    value = "${module.nexus.instance_id}"
}
output "instance_private_ip" {
    value = "${module.nexus.private_ip}"
}
output "instance_public_ip" {
    value = "${module.nexus.public_ip}"
}
output "instance_subnet_id" {
    value = "${module.nexus.instance_subnet_id}"
}
output "sg_id" {
    value = "${aws_security_group.nexus_security_group.id}"
}
