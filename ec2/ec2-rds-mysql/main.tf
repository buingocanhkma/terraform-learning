provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "education"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

################## SUB NET ###############################

resource "aws_db_subnet_group" "education" {
  name       = "education"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Education"
  }
}


################ SECURITY GROUP ###########################

resource "aws_security_group" "rds" {
  name   = "education_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "education_rds"
  }
}

resource "aws_security_group" "ec2" {
  name   = "education_ec2"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "education_ec2"
  }
}
###################### RDS ##########################

resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "mysql8.0"


}

resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "8.0.28"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}


###################### EC2 ##########################

resource "aws_instance" "education" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  key_name        = "anhbn"
  subnet_id = module.vpc.public_subnets[1]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  user_data = <<-EOF

      #!/bin/bash

      sudo su

      yum update -y

      yum install httpd -y

      systemctl start httpd

      systemctl enable httpd

      echo "<html><h1> Welcome to CodeStar. Happy Learning from $(hostname -f)...</p> </h1></html>" >> /var/www/html/index.html
      
      yum install git -y
      yum install mysql -y
      
      cd /home/ec2-user/
      
      git clone https://github.com/joaogsleite/php-mysql-website.git
      
      cd php-mysql-website/
      cp -r web ../html
      cp -r ../html /var/www/
      EOF  
  
  tags = {

    Name = "education-ec2"
    
  }
}