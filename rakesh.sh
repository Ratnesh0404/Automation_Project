#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
systemctl status apache2
sudo apt install awscli -y
myname=ratnesh
timestamp=$(date '+%d%m%Y-%H%M%S')
tar -czvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/access.log
tar -czvf /tmp/${myname}-httpd-logs1-${timestamp}.tar /var/log/apache2/error.log
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://upgrad-ratnesh/${myname}-httpd-logs-${timestamp}.tar
aws s3 cp /tmp/${myname}-httpd-logs1-${timestamp}.tar s3://upgrad-ratnesh/${myname}-httpd-logs1-${timestamp}.tar
