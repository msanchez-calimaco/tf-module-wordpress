#!/bin/bash
sudo yum -y update
hostnamectl set-hostname wordpress
# ----- Install AWS EFS Utilities --------------------
yum install -y amazon-efs-utils
# ----- Create EFS Mount --------------------
mkdir /efs
mount -t efs ${efs_id}:/ /efs
# ----- Edit fstab so EFS automatically loads on reboot
echo ${efs_id}:/ /efs efs defaults,_netdev 0 0 >> /etc/fstab
# Install & Run Docker --------------------
sudo amazon-linux-extras install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
# ----- Install docker compose --------------------
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# ----- Docker run wordpress with assigning env variables  ------- 
docker run -d -e WORDPRESS_DB_HOST=${dbhost} -e WORDPRESS_DB_PASSWORD=${password} -e WORDPRESS_DB_USER=${user} -e WORDPRESS_DB_NAME=${dbname}  -v /efs/wordpress:/var/www/html -p 80:80 wordpress:latest
