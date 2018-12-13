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
yum -y install centos-release-scl


# Centreon repository
curl -sSL 'http://yum.centreon.com/standard/18.10/el7/stable/noarch/RPMS/centreon-release-18.10-2.el7.centos.noarch.rpm' -o /tmp/centreon-release-18.10-2.el7.centos.noarch.rpm
yum -y install --nogpgcheck /tmp/centreon-release-18.10-2.el7.centos.noarch.rpm



# Installing Centreon central server with database
yum -y install centreon
systemctl restart mysql


# Installing Centreon central server without database
# yum -y install centreon-base-config-centreon-engine

# Installing MySQL on the dedicated server
# yum -y install centreon-database
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



# Pos Install 
# 1 Welcome to Centreon Setup
#curl http://localhost/centreon/install/steps/step.php?action=nextStep

# 2 Dependency check up
#curl http://localhost/centreon/install/steps/step.php?action=nextStep

# 3 Monitoring engine information
#curl -d install_dir_engine='/usr/share/centreon-engine' -d centreon_engine_stats_binary='/usr/sbin/centenginestats' -d monitoring_var_lib='/var/lib/centreon-engine' -d centreon_engine_connectors='/usr/lib64/centreon-connector' -d centreon_engine_lib='/usr/lib64/centreon-engine' -d centreonplugins='/usr/lib/centreon/plugins/' http://localhost/centreon/install/steps/process/process_step3.php

# 4 Broker module information
#curl -d centreonbroker_etc='/etc/centreon-broker' -d centreonbroker_cbmod='/usr/lib64/nagios/cbmod.so' -d centreonbroker_log='/var/log/centreon-broker' -d centreonbroker_varlib='/var/lib/centreon-broker' -d centreonbroker_lib='/usr/share/centreon/lib/centreon-broker' http://localhost/centreon/install/steps/process/process_step4.php

# 5 Admin information
#curl -d admin_password='q1w2Q!W@' -d confirm_password='q1w2Q!W@' -d firstname="Admin" -d lastname="Centreon" -d email="root@localhost" http://localhost/centreon/install/steps/process/process_step5.php 

# 6 Database information
#curl -d address='localhost' -d port='3306' --form root_password='' -d db_configuration='centreon' -d db_storage='centreon_storage' -d db_user='centreon' -d db_password='q1w2Q!W@' -d db_password_confirm='q1w2Q!W@' http://localhost/centreon/install/steps/process/process_step6.php

# 7 Installation
#curl http://localhost/centreon/install/steps/step.php?action=nextStep

# 8 Modules installation
#curl -d centreon-pp-manager='checked' -d centreon-license-manager='checked' http://localhost/centreon/install/steps/step.php?action=nextStep

# 9 
#curl http://localhost/centreon/install/steps/step.php?action=nextStep


