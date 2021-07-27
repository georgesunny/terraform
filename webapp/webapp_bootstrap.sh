#!/bin/bash

set -x

yum install -y epel-release
sudo amazon-linux-extras install epel -y
yum install -y ansible python-pip wget jq zip unzip
sudo yum install amazon-cloudwatch-agent -y

pip install awscli --upgrade --ignore-installed six
chmod +x /bin/aws

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent

aws s3 sync s3://${s3_bucket_name}/ /opt/ --region ${region}
cd /opt/
unzip ansible.zip
chown ansible:ansible /opt/ansible -R
cd /opt/ansible
ansible-playbook playbook.yml