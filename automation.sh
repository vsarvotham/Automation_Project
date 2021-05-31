#!/bin/bash

chmod  +x  /root/Automation_Project/automation.sh
sudo su
sudo apt update -y

s3_bucketName="s3-sarvothaman"
myname = "Sarvo"

#installs Apache if not there already, if already there will update
apt-get install -y apache2
#check Apache status
systemctl status apache2


timestamp=$(date '+%d%m%Y-%H%M%S')

#create archive of access logs
tar cvzf /tmp/${myname}-httpd-logs-$timestamp.tar /var/log/apache2/access.log /var/log/apache2/error.log

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar