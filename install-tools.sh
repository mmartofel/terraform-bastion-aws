
sudo yum update -y
sudo yum install git -y
git --version

sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

sudo yum install aws
sudo yum install aws-cli

