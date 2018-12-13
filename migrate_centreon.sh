#!/bin/bash
#
set -xv
# Migrar Centreon 18.10 para outro Host
# 
#

IP_New_Centreon='45.55.52.14'


# Testar conexao SSH
`ssh root@$IP_New_Centreon "exit"`
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

# Plugin
#rsync -avz /usr/lib64/nagios/plugins root@$IP_Nes_Centreon:/usr/lib64/nagios
#rsync -avz /usr/lib/nagios/plugins root@$IP_Nes_Centreon:/usr/lib64/nagios
#rsync -avz /usr/lib/centreon/plugins root@$IP_Nes_Centreon:/usr/lib/centreon


# Dump Database
mysqldump --skip-add-drop-database --all-databases > /tmp/dump.sql
rsync -avz /tmp/dump.sql root@$IP_New_Centreon:/tmp
ssh root@root@$IP_New_Centreon "mysql < /tmp/dump.sql"

# Stop mysqld
#ssh root@$IP_New_Centreon "service mysql stop"

# Synchronize data
#rsync -avz /var/lib/mysql/ root@$IP_New_Centreon:/var/lib/mysql/

# If you migrate your DMBS from 5.x to 10.x, it’s necessary to execute this command on the new server :
MVER=`ssh root@$IP_New_Centreon "mysqld -V | grep Ver | cut -d ' ' -f 4 | cut -d . -f 1"`
if [ $MVER -ne 5 ]
then
  ssh root@$IP_New_Centreon "mysql_upgrade"
fi


# Start the mysqld process on the new server:
#systemctl start mysqld

# Upgrading Centreon
ssh root@$IP_New_Centreon "mv /usr/share/centreon/installDir/$(echo "`ls -1 /usr/share/centreon/installDir | xargs`") /usr/share/centreon/www/install"

# Fonte: 
# https://documentation.centreon.com/docs/centreon/en/latest/migration/upgradetoCentreon18.10.html
#
