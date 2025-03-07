#!/bin/bash
set -e

# Update the system
sudo yum update -y >> /var/log/install-tools.log 2>&1

# Install git
sudo yum install git -y >> /var/log/install-tools.log 2>&1
git --version >> /var/log/install-tools.log 2>&1

# Install additional utilities and terraform
sudo yum install -y yum-utils shadow-utils >> /var/log/install-tools.log 2>&1
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo >> /var/log/install-tools.log 2>&1
sudo yum -y install terraform >> /var/log/install-tools.log 2>&1

# Install AWS CLI
sudo yum install aws-cli -y >> /var/log/install-tools.log 2>&1