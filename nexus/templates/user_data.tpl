#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting.

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo sed -i "s/search.*/search ${private_domain}/g" /etc/resolv.conf
echo "${hostname}" | sudo tee /etc/hostname
sudo hostname "${hostname}"
sudo yum -y install git

if [ "${enable_puppet}" -eq 1 ]
then
    sudo yum -y install ntp ntpdate
    sudo ntpdate 0.centos.pool.ntp.org
    sudo timedatectl set-timezone Europe/London
    sudo systemctl start ntpd
    sudo systemctl enable ntpd
    sudo setenforce 0
    sudo rpm -Uvh https://yum.puppet.com/puppet${puppet_version}/puppet${puppet_version}-release-${os}-${os_version}.noarch.rpm
    sudo yum -y install puppet-agent
    sudo ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
    sudo /opt/puppetlabs/bin/puppet config set server puppet01.${private_domain} --section main
    sudo systemctl stop puppet
    sudo systemctl enable puppet
    sudo puppet agent -t --environment ${puppet_environment}
else
    sudo echo "${terraform_encryption_key}" | sudo tee /root/.terraform_encryption_key > /dev/null
    sudo yum --enablerepo=extras -y install epel-release
    sudo yum -y install python-pip
    sudo pip install --upgrade pip
    sudo pip install ansible=="${ansible_version}"
    git clone --branch "${ansible_playbook_git_repo_branch}" --depth 1 "${ansible_playbook_git_repo}" "${ansible_playbook_tmp_dir}"
    ansible-galaxy install -r "${ansible_playbook_tmp_dir}"/roles/roles_requirement.yml --force --no-deps --ignore-errors -p "${ansible_playbook_tmp_dir}"/roles/
    sudo ansible-playbook "${ansible_playbook_tmp_dir}"/main.yml -i "${ansible_playbook_tmp_dir}"/inventories/"${aws_environment}"/hosts
    sudo rm -rf "${ansible_playbook_tmp_dir}"
fi
