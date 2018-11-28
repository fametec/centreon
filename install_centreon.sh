#!/bin/bash
#
# Script para instalar o Centreon 18.10 
# Testado com um Standard Droplet 1GB-1CPU-25GB na DigitalOcean, 
# Use o link https://m.do.co/c/255eab96dfbb para criar uma conta.
# 


# Desativando SELinux
setenforce 0
sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config


# Criar Swap
dd if=/dev/zero of=/swap.raw bs=1M count=1024
chmod 0600 /swap.raw
mkswap /swap.raw
echo '/swap.raw swap swap defaults 0 0' >> /etc/fstab
swapon /swap.raw



# Software collections repository installation
yum install centos-release-scl


# Centreon repository
wget http://yum.centreon.com/standard/18.10/el7/stable/noarch/RPMS/centreon-release-18.10-2.el7.centos.noarch.rpm -O /tmp/centreon-release-18.10-2.el7.centos.noarch.rpm
yum -y install --nogpgcheck /tmp/centreon-release-18.10-2.el7.centos.noarch.rpm



# Installing Centreon central server with database
yum -y install centreon
systemctl restart mysql


# Installing Centreon central server without database
# yum install centreon-base-config-centreon-engine

# Installing MySQL on the dedicated server
# yum install centreon-database
# systemctl restart mysql


# Add innodb_file_per_table=1 
cat <<EOF > /etc/my.cnf.d/99-centreon.ini
[mysqld]
innodb_file_per_table=1
EOF

# Database management system
mkdir -p  /etc/systemd/system/mariadb.service.d/
echo -ne "[Service]\nLimitNOFILE=32000\n" | tee /etc/systemd/system/mariadb.service.d/limits.conf
systemctl daemon-reload
systemctl restart mysql


# PHP timezone
echo "date.timezone = America/Fortaleza" > /etc/opt/rh/rh-php71/php.d/php-timezone.ini


# Restart httpd
systemctl restart httpd


# Disable firewalld
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld


# Launching services during system bootup
systemctl enable httpd
systemctl enable snmpd
systemctl enable snmptrapd
systemctl enable rh-php71-php-fpm
systemctl enable centcore
systemctl enable centreontrapd
systemctl enable cbd
systemctl enable centengine


# Concluding the instalation
systemctl start rh-php71-php-fpm
systemctl start httpd
systemctl start mysqld
systemctl start cbd
systemctl start snmpd
systemctl start snmptrapd



