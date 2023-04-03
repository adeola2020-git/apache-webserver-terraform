#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl status httpd
cd /var/www/html
echo "<html><body><h1>Hello World on $(hostname -f)</h1></body></html>" > index.html
# curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html
# echo "</h1></body></html>" >> index.html