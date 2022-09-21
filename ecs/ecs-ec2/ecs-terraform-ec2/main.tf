terraform {
  #required_version = "~> 0.12.6"

  required_providers {
    # https://github.com/terraform-providers/terraform-provider-aws/releases/latest
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key = "AKIAQDV6LAORPA2ESIFD"
  secret_key = "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"
}
