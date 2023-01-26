#!/bin/bash
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install apache2
sudo systemctl start apache2
sudo touch /var/www/html/index.html
sudo cp ./FILE/index.html /var/www/html/index.html
sudo apt systemctl reload apache2