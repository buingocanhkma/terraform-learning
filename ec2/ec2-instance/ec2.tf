########################## Create EC2 ###########################

resource "aws_instance" "prima" {
  ami = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id = "subnet-036edb0d3ba84c41f"
  key_name        = "anhbn"

  tags = {

    Name = "codestar-docker"
    
  }
}

output "ec2_public_dns" {
  description = "EC2 instance Public DNS"
  value       = aws_instance.prima.public_dns
  #sensitive   = true
}