#!/bin/bash
#
# Migrar Centreon 18.10 para outro Host
# 
#

IP_New_Centreon='159.65.37.229'


# Testar conexao SSH
`ssh root@$IP_New_Centreon "echo connected..."`
if [ $? -ne 0 ]
then 
  echo "Erro na conexao SSH, verifique se a chave foi enviada para o Host..."
  exit 1
fi



# Synchronizing the data
rsync -avz /etc/centreon root@$IP_New_Centreon:/etc
rsync -avz /etc/centreon-broker root@$IP_New_Centreon:/etc
rsync -avz /var/log/centreon-engine/archives/ root@$IP_New_Centreon:/var/log/centreon-engine
rsync -avz --exclude centcore/ logs/ /var/lib/centreon root@$IP_New_Centreon:/var/lib
rsync -avz /var/spool/centreon/.ssh root@$IP_New_Centreon:/var/spool/centreon


# Dump Database
mysqldump -A > /tmp/dump.sql

rsync -avz /tmp/dump.sql root@$IP_New_Centreon:/tmp
ssh root@root@$IP_New_Centreon "mysql < /tmp/dump.sql.gz"

# Stop mysqld
#ssh root@$IP_New_Centreon "service mysql stop"

# Synchronize data
#rsync -avz /var/lib/mysql/ root@$IP_New_Centreon:/var/lib/mysql/

# If you migrate your DMBS from 5.x to 10.x, it’s necessary to execute this command on the new server :
MVER=`ssh root@$IP_New_Centreon "mysqld -V | grep Ver | cut -d ' ' -f 4 | cut -d . -f 1"`
if [ $MVER -eq 5 ]
then
  ssh root@$IP_New_Centreon "mysql_upgrade"
fi


# Start the mysqld process on the new server:
#systemctl start mysqld

# Upgrading Centreon
ssh root@$IP_New_Centreon "mv /usr/share/centreon/installDir/install* /usr/share/centreon/www/install"

# Fonte: 
# https://documentation.centreon.com/docs/centreon/en/latest/migration/upgradetoCentreon18.10.html
#
