data "aws_iam_policy_document" "alb_logs_bucket_data" {
  statement {
    actions   = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    principals {
      identifiers = "${var.alb_logs_bucket_data_identifiers}"
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.alb_logs_bucket}/*",
      "arn:aws:s3:::${var.alb_logs_bucket}"
    ]
    sid       = "NexusALBLogs"
  }
}

data "template_file" "user_data" {
  count    = "${var.count}"
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    ansible_playbook_git_repo        = "${var.ansible_playbook_git_repo}"
    ansible_playbook_git_repo_branch = "${var.ansible_playbook_git_repo_branch}"
    ansible_playbook_tmp_dir         = "${var.ansible_playbook_tmp_dir}"
    ansible_version                  = "${var.ansible_version}"
    aws_environment                  = "${var.aws_environment}"
    enable_puppet                    = "${var.enable_puppet}"
    hostname                         = "${var.hostname}${format(var.instance_number_prefix, count.index+1)}.${var.private_domain}"
    os                               = "${var.os}"
    os_version                       = "${var.os_version}"
    private_domain                   = "${var.private_domain}"
    puppet_environment               = "${var.puppet_environment}"
    puppet_version                   = "${var.puppet_version}"
    terraform_encryption_key         = "${data.vault_generic_secret.terraform_encryption_key.data["value"]}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.bastion_remote_state_key}"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "dns_zone" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.dns_remote_state_key}"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "networks" {
  backend = "s3"
  
  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.networks_remote_state_key}"
    region = "${var.aws_region}"
  }
}

data "vault_generic_secret" "terraform_encryption_key" {
  path = "${var.terraform_encryption_key_path}"
}
