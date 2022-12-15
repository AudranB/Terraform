#!/bin/bash
sudo yum -y update && sudo yum -y upgrade
sudo yum -y install httpd
sudo systemctl start httpd
sudo touch /var/www/html/index.html
sudo cp ./FILE/index.html /var/www/html/index.html
sudo yum systemctl reload httpd