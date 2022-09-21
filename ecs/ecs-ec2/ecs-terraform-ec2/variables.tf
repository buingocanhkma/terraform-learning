variable "key_name" {
  type        = string
  default = "anhbn"
  description = "The name for ssh key, used for aws_launch_configuration"
}

variable "cluster_name" {
  type        = string
  default = "codestar-app"
  description = "The name of AWS ECS cluster"
}

variable "ec2_iam_role" {
  type        = string
  default = "arn:aws:iam::007915373474:instance-profile/ecsInstanceRole"
  description = "The name of AWS ECS cluster"
}