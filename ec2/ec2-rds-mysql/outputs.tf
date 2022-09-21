output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.education.address
  #sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.education.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.education.username
  #sensitive   = true
}

output "ec2_publicip" {
  description = "EC2 instance Public IP"
  value       = aws_instance.education.public_ip
  #sensitive   = true
}

output "ec2_public_dns" {
  description = "EC2 instance Public DNS"
  value       = aws_instance.education.public_dns
  #sensitive   = true
}
