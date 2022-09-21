module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  #version        = "2.38.0"
  version        = "3.14.4"
  name           = "codestar_ecs_lab"
  cidr           = "10.10.0.0/16"
  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  tags = {
    "env"       = "dev"
    "createdBy" = "anhbn3"
  }

}

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}