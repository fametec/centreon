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


## Dump Database centreon
mysqldump --skip-add-drop-database --databases centreon > /tmp/dump_centreon.sql.gz 
rsync -avz /tmp/dump_centreon.sql.gz root@$IP_New_Centreon:/tmp

## Dump Database centreon_storage
mysqldump --skip-add-drop-database --databases centreon_storage > /tmp/dump_centreon_storage.sql
rsync -avz /tmp/dump_centreon_storage.sql root@$IP_New_Centreon:/tmp

## Script restore databases
cat <<EOF >> /tmp/script1.sh
#!/bin/bash
#Restore databases
mysql -v < /tmp/dump_centreon.sql
mysql -v < /tmp/dump_centreon_storage.sql
EOF

rsync -avz /tmp/script1.sh root@$IP_New_Centreon:/tmp
ssh root@$IP_New_Centreon "sh /tmp/script1.sh"


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
#cat << EOF >> /tmp/script2.sh
#DIR=\$(ls -1 /usr/share/centreon/installDir)
#mv /usr/share/centreon/installDir/\$DIR/ /usr/share/centreon/www/install
#EOF


#rsync -avz /tmp/script2.sh root@$IP_New_Centreon:/tmp
#ssh root@$IP_New_Centreon "sh /tmp/script2.sh"

# Fonte: 
# https://documentation.centreon.com/docs/centreon/en/latest/migration/upgradetoCentreon18.10.html
#
