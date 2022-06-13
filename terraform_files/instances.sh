#!bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install httpd -y 
sudo systemctl start httpd 
sudo systemctl enable httpd 
sudo chmod 777 echo "welcome to the YASSIR site" > /var/www/html/index.html