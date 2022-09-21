variable "ENV" {
  description = "Type of Environment like Prod, Dev, Staging"
  default     = "dev"
}

variable "AWS_REGION" {
  description = "Region where you have to Provision Infrastructure"
  default     = "us-east-1"
}

variable "VPC_NAME" {
  description = "Product Name"
}

variable "az1" {
  description = "Availability zone 1"
  default     = "us-east-1a"
}

variable "az2" {
  description = "Availability zone 2"
  default     = "us-east-1b"
}
