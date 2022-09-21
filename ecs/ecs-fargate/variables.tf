variable "app_count" {
  type = number
  default = 1
}

variable "access_key" {
    description = "Access key to AWS console"
}

variable "secret_key" {
    description = " Secret key to AWS console"
}

variable "region" {
    description = "Region of AWS VPC"
}