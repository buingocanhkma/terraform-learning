Nexus Instance Module
Terraform module to deploy a generic Nexus instance with:

EBS Volume
EFS volume


Required Variables


attach_ebs_volume: Boolean variable to add EBS storage

aws_region: AWS region

certificate_arn: AWS SSL cert ARN to use with application LB

efs_mount_target_count: this value should match the number of Gitlab instances to deploy

count: Number of instance to deploy

dns_remote_state_key: Remote state key of DNS zone

key_name: Keypair name

networks_remote_state_key: Network remote state key

private_domain: Environment private domain

remote_state_bucket: Environment remote state s3 bucket

vpc_name: Name of the VPC

bastion_remote_state_key: Remote state key of bastion server

icmp_cidr_blocks: VPC CIDR block to allow ping

https_port_cidr_blocks: CIDR block to allow https access

aws_environment: Name of AWS environment


Optional Variables


hostname: ECS instance hostname. Default = jira

instance_number_prefix: Default to 2 digits prefix - %02d"

instance_type: Type of EC2 instance to deploy. Default = "t2.large"

ansible_playbook_git_repo: Git/Gitlab repository of bastion ansible playbook

ansible_playbook_tmp_dir: Temporary dir of Gitlab Ansible playbook


Outputs

efs_mount_target_id
efs_mount_target_dns
efs_mount_target_ip
efs_volume_dns
instance_dns
instance_private_ip
instance_public_ip
alb_dns_name


Dependencies
None

To Do
Currently, we are not using Datacentre license. Once, we have Datacentre license we can make this module fully HA by adding:

Add second instance
Update EFS mounts to share data/configs


License


Author Information
anhbn3 - Ngoc Anh