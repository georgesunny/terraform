#!/bin/bash

set -x

yum install -y epel-release
amazon-linux-extras install epel -y
yum install -y ansible python-pip wget jq zip unzip


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

aws s3 sync s3://${s3_bucket_name}/ /opt/ --region ${region}
cd /opt/
unzip ansible.zip

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
yum install amazon-cloudwatch-agent -y

sudo su - ec2-user <<EOF
ansible-playbook /opt/ansible/playbook.yml
echo "@reboot sleep 60 && ansible-playbook /opt/ansible/playbook.yml" > /tmp/ansible_load
crontab /tmp/ansible_load
rm -f /tmp/ansible_load
EOF