########################## Create EC2 ###########################

resource "aws_instance" "codestar-lab" {
  ami = "ami-08d4ac5b634553e16"
  instance_type = "t2.micro"
  subnet_id = "subnet-036edb0d3ba84c41f"
  key_name        = "anhbn"
 
  user_data = <<-EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt install unzip -y
      sudo apt install net-tools -y
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install

      sudo apt install nginx -y
      cd /var/www/html
        
      #cai dat docker, docker-compose
        

      sudo apt-get install \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
            
      curl -fsSL https://get.docker.com -o get-docker.sh
      DRY_RUN=1 sh ./get-docker.sh
      sudo sh get-docker.sh
      sudo usermod -aG docker ubuntu
        
      sudo apt-get install docker-ce docker-ce-cli containerd.io -y
        
        
      sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
        
      sudo chmod 666 /var/run/docker.sock
        
      # cai dat web-server
      echo "<html>" > index.html
        
      echo "<h1>Welcome to CodeStar</h1>" >> index.html
      echo "<h4>You are running instance from this IP (This is for testing purpose only, you should not public this to user):</h4>"
        
      echo "<br>Private IP: " >> index.html
      curl http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
        
      echo "<br>Public IP: " >> index.html
      curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html 
        
      echo "</html>" >> index.html
      
      #Thiet lap aws key
      sudo su
      exit
      sudo su ubuntu
      
      #install Cloudwatch agent
      wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
      sudo rpm -U ./amazon-cloudwatch-agent.rpm
      sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard 1 1 1 2 3 1 1 1 1 2 1 2 2 2 
      sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
      
      #update aws key
      cd /home/ubuntu/
      #echo "AWS_ACCESS_KEY_ID='AKIAQDV6LAORPA2ESIFD'">>env.sh
      #echo "AWS_ACCESS_KEY_SECRET='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'">>env.sh
      #echo "AWS_REGION='us-east-1'">>env.sh
      #echo "AWS_OUTPUT='json'">>env.sh
      touch env.sh
      sudo chown ubuntu:ubuntu env.sh
      echo "aws configure set aws_access_key_id AKIAQDV6LAORPA2ESIFD" >> /home/ubuntu/env.sh
      echo "aws configure set aws_secret_access_key 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" >> /home/ubuntu/env.sh
      echo "aws configure set region us-east-1" >> /home/ubuntu/env.sh
      echo "aws configure set output json" >> /home/ubuntu/env.sh
      chmod a+x /home/ubuntu/env.sh
      /home/ubuntu/./env.sh
  EOF
 
  tags = {

    Name = "codestar-docker-awscli"
    
  }
}

output "ec2_public_dns" {
  description = "EC2 instance Public DNS"
  value       = aws_instance.codestar-lab.public_dns
  #sensitive   = true
}

output "ec2_public_ip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.codestar-lab.public_ip
  #sensitive   = true
}