#!/bin/bash
sudo yum -y update
hostnamectl set-hostname mariadb
# ----- Install AWS EFS Utilities ---------------
yum install -y amazon-efs-utils
# ----- Create the EFS Mount --------------------
mkdir /efs
mkdir /efs/mariadb
mount -t efs $efs_id:/ /efs
# ----- Edit fstab so EFS automatically loads on reboot ---
echo $efs_id:/ /efs efs defaults,_netdev 0 0 >> /etc/fstab
# ----- Install & Run Docker ---------------------
sudo amazon-linux-extras install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
docker run --name mariadb -e MYSQL_ROOT_PASSWORD=${root_password} -e MYSQL_USER=${user} -e MYSQL_PASSWORD=${password} -e MYSQL_DATABASE=${dbname} -p 3306:3306 -d -v /efs/mariadb:/var/lib/mysql docker.io/library/mariadb
