## This Template creates the Elastic container service
## with attached application loadblancer.
##

module "alb" {
  source               = "./modules/loadblancer/application_loadblancer"
  #source               = "https://github.com/karan6190/terraform-aws-ecs/tree/master/modules/loadblancer/application_loadblancer"
  ENV                  = "dev" # Product Environment
  VPC_NAME             = "fusion" # Product Name
  appname              = "ecs-demo" # Application Name
  vpc_id               = "${module.main-vpc.vpc_id}"
  public-subnet-1      = "${module.main-vpc.public_subnets-1}"
  public-subnet-2      = "${module.main-vpc.public_subnets-2}"
  #certificate_arn     = "xxxxxxxxxxxxxxxxxxxxxxxx"
}

module "ecs" {
  source               = "./modules/ecs"
  ENV                  = "dev" # Product Environment
  VPC_NAME             = "fusion" # Product Name
  vpc_id               = "${module.main-vpc.vpc_id}"
  public-subnet-1      = "${module.main-vpc.public_subnets-1}"
  public-subnet-2      = "${module.main-vpc.public_subnets-2}"
  appname              = "ecs-demo" # Application Name
  min_size             = "1" # default 1, Minimum no of Instance node (ASG)
  max_size             = "4" # default 4, Maximum no of Instance node (ASG)
  desired_capacity     = "2" # default 2, number of Amazon EC2 instances that should be running
  keyname              = "anhbn"# key Name
  pubkey               = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9JgYeOQ2BIb16xl0YsoofyaDCVpmzfaMzsxhUitEq2Rs3Bkud37ItLSGNqjhf2EkzK0f6NnBtiBXg2b018jny2R3ncNxIGQ0OZ3WxJagS2TdLP9V9apL6AvM92kwSpvNOe5RvOyGC8hMbM8lV46MupA/ALq7YRTNUzw4R7Ew8QcALj/beKNJn7ookp2XkdNbrl0ayOF1kDbMAbfOv9kOKgY20+KxZx3jutwPi1McLL+kgV2VEm67RAd5bxDQtlG0zeSZhs/uttYDPGA/eOKpm52Y7s+re9vPMiJjAsHP7RTGX2jFfg7EflgF1LCi2ayjeLWQ2olxsPLZqU2SJbdrv anhbn" # Public key
  instance_type        = "t2.micro" # default t2.micro
  applicationPort      = "80" # Application port no (for security group)
  target_group         = "${module.alb.tagetGroup}"
  container_name       = "demo-ecs-container" # Container Name
  container_port       = "80"
  ecs_task_family      = "nginx" # Task defination name
  container_definitions= "${file("container_definition.json")}"
  desired_count        = "2" # default 1
  launch_type          = "EC2" # valid values are EC2 and FARGATE, default is EC2
  iam_policy_name      = "ecs-policy"     #Policy Name
  iam_instance_profile = "ecs-profile"    # Instance profile Name
  iam_role             = "fusion-dev-ecs" # Role Name
}

