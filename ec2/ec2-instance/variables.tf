variable "access_key" {
    description = "Access key to AWS console"
}

variable "secret_key" {
    description = " Secret key to AWS console"
}

variable "region" {
    description = "Region of AWS VPC"
}

## VPC Variables

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_1a" {
    description = "CIDR for the Public Subnet 1a"
    default = "10.0.1.0/24"
}

variable "public_subnet_1b" {
    description = "CIDR for the Public Subnet 1b"
    default = "10.0.2.0/24"
}

variable "iam_role" {
    description = "CIDR for the Public Subnet 1b"
    default = "AmazonSSMRoleForInstancesQuickSetup"
}