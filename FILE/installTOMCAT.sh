sudo apt update 
sudo apt install default-jdk -y 
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat 
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz 
sudo tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1 
sudo chown -R tomcat:tomcat /opt/tomcat/ 
sudo chmod -R u+x /opt/tomcat/bin 
sudo nano /opt/tomcat/conf/tomcat-users.xml 
sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo nano /etc/systemd/system/tomcat.service 
sudo systemctl daemon-reload 
sudo systemctl start tomcat.service 
sudo systemctl enable tomcat.service 
sudo systemctl status tomcat.service 