#!/bin/bash
myname="ratnesh"
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo apt update -y
sudo apt install awscli -y
sudo apt install apache2 -y

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
echo "Apache2 is running"
else
echo "Apache2 is not running"
echo "Starting apache2"
sudo service apache2 start

fi

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
echo "Apache2 is enabled"
else
echo "Apache2 is not enabled"
echo "Enabling apache2"
sudo systemctl enable apache2
Sudo systemctl status apache2
fi

echo "Now compressed logs are stored into /tmp"

tar -czvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/access.log
tar -czvf /tmp/${myname}-httpd-logs1-${timestamp}.tar /var/log/apache2/error.log

echo "Now logs are copying to S3 bucket"
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://upgrad-ratnesh/${myname}-httpd-logs-${timestamp}.tar
aws s3 cp /tmp/${myname}-httpd-logs1-${timestamp}.tar s3://upgrad-ratnesh/${myname}-httpd-logs1-${timestamp}.tar

if [ -e /etc/cron.d/automation ]
then
        echo "Cron job exists"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job added"
fi
