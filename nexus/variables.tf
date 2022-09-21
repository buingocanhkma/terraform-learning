########## ALB Variables ##########
variable "acl" {
  default     = "log-delivery-write"
  description = "ACL to apply to the S3 bucket"
  type        = "string"
}
variable "alb_https_port_cidr_blocks" {
  default = [
    "127.0.0.1/32",
  ]
  type = "list"
}
variable "alb_idle_timeout" {
  default = 60
}
variable "alb_logs_bucket" {}
variable "alb_logs_bucket_data_identifiers" {
  type = "list"
  default = [
    "054676820928", # eu-central-1	Europe (Frankfurt)
    "156460612806", # eu-west-1	Europe (Ireland)
    "652711504416", # eu-west-2	Europe (London)
    "009996457667", # eu-west-3	Europe (Paris)
    "897822967062", # eu-north-1	Europe (Stockholm)
  ]
  description = "https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html"
}
variable "alb_ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}
variable "certificate_arn" {}
variable "create_alb_logs_bucket" {
  default = false
}
variable "enable_nexus_alb" {
  default = false
}
variable "healthy_threshold" {
  default = 2
}
variable "nexus_alb_public_port" {
  default = 8081
}
variable "unhealthy_threshold" {
  default = 10
}
variable "interval" {
  default = 5
}
variable "timeout" {
  default = 4
}
variable "matcher" {
  default = "200-404"
}

########## EBS Variables ##########
variable "attach_ebs_volume" {
  default = false
}
variable "ebs_volume_size" {
  default = 100
}
variable "ebs_volume_type" {
  default = "gp2"
}

########## EFS Variables ##########
variable "attach_efs_volume" {
  default = false
}

variable "efs_mount_target_count" {
  default = false
}
variable "efs_volume_sg_name" {
  default = "nexus_efs_volume_security_group"
}

########## Instance Variables #########
variable "associate_public_ip_address" {
  default = false
}

variable "aws_region" {
  description = "The AWS region to deploy."
}
variable "count" {}
variable "dns_remote_state_key" {}
variable "hostname" {
  default = "nexus"
}
variable "instance_number_prefix" {
  default = "%02d"
}
variable "instance_type" {
  default = "t3.medium"
}
variable "image_id" {
    type = "map"
    default = {
        #Frankfurt
        eu-central-1 = "ami-04cf43aca3e6f3de3"
        #Ireland
        eu-west-1    = "ami-0ff760d16d9497662"
        #London
        eu-west-2    = "ami-0eab3a90fc693af19"
        #Paris
        eu-west-3    = "ami-0e1ab783dc9489f34"
  }
}
variable "key_name" {}
variable "networks_remote_state_key" {}
variable "private_domain" {}
variable "remote_state_bucket" {}
variable "vpc_name" {}

########## Security Group Variables ##########
variable "bastion_remote_state_key" {}
variable "enable_node_exporter_access" {
  default = 0
}
variable "icmp_cidr_blocks" {
  default = [
    "127.0.0.1/32",
  ]
  type = "list"
}
variable "prometheus_node_exporter_port" {
  default = 9100
}
variable "prometheus_sg_id" {
  default = "default_sg_id"
}
variable "http_port_cidr_blocks" {
  default = [
    "127.0.0.1/32",
  ]
  type = "list"
}
variable "nexus_alb_docker_group_port" {
  default = 8082
}
variable "nexus_alb_docker_private_port" {
  default = 8083
}

############# Tags Variables #############
variable "application" {
  default = "AZUK"
  type    = "string"
}
variable "environment" {
  default = "Pub"
  type    = "string"
}
variable "product" {
  default = "AZUK"
  type    = "string"
}

########## User_Data Variables ##########
variable "ansible_playbook_git_repo" {
  default = "https://gitlab.cloud/devsecops/ansible/nexus.git"
}
variable "ansible_playbook_git_repo_branch" {
  default = "master"
  description = "Ansible playbook git repo branch/tag to use"
}
variable "ansible_playbook_tmp_dir" {
  default = "/tmp/ansible_playbook"
}
variable "ansible_version" {
  default = "2.7"
}
variable "aws_environment" {}
variable "enable_puppet" {
  default = 1
}
variable "os" {
  default = "el"
}
variable "os_version" {
  default = 7
}
variable "puppet_environment" {
  default = "dev"
}
variable "puppet_version" {
  default = 6
}

######### vault Variables ##########
variable "terraform_encryption_key_path" {
  default = "kv/dso/infrastructure/terraform/encryption/dev"
}
variable "vault_address" {
  default = "https://vault.cloud/"
}
variable "vault_token" {}
