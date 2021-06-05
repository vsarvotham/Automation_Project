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
fileSize =$( ( du -l /tmp/${myname}-httpd-logs-$timestamp.tar | cut -f1 ) ) 

inventoryFile="/var/www/html/inventory.html"
if test -f "$inventoryFile";
then
    echo "$inventoryFile has found."
    contentRow="<tr><td>httpd-logs</td><tr><td> ${timestamp} </td><tr><td>tar</td><tr><td> ${fileSize} </td></tr>"
    echo contentRow >> $inventoryFile
else
    echo "$inventoryFile has not been found"
    headerRow = "<table><tr><td>Log Type</td><tr><td>Date Created</td><tr><td>Type</td><tr><td>Size</td></tr></table>"
    touch /var/www/html/inventory.html
    echo headerRow > /var/www/html/inventory.html
fi


cat "<b>Log Type "
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

cronFile = "/etc/cron.d/automation"
if test -f "$cronFile";
then
    echo "$cronFile has found."
    #do nothing
else
    echo "$cronFile has not been found"
    echo "* * * * * root /root/Automation_Project/automation.sh" >> cronFile
fi
