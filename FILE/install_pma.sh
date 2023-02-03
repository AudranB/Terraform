#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo apt-get install -y phpmyadmin php-mbstring
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
sudo phpenmod mbstring
sudo systemctl restart apache2



#sudo apt install composer -y
#sudo apt install cmdtest
#git clone https://github.com/phpmyadmin/phpmyadmin.git