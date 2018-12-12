#!/bin/bash

set -xv
# Pos Install 
# 1 Welcome to Centreon Setup
#curl -d action="form_step1" -d next="Next" -d submit="Next" http://localhost/centreon/install/install.php
curl http://localhost/centreon/install/steps/step.php?action=nextStep
read

# 2 Dependency check up
#curl -d action="form_step2" -d next="Next" -d submit="Next" http://localhost/centreon/install/install.php
curl http://localhost/centreon/install/steps/step.php?action=nextStep
read

# 3 Monitoring engine information
#curl -d action="form_step3" -d submit="Next" -d submit="Next" http://localhost/centreon/install/install.php
curl -d install_dir_engine='/usr/share/centreon-engine' -d centreon_engine_stats_binary='/usr/sbin/centenginestats' -d monitoring_var_lib='/var/lib/centreon-engine' -d centreon_engine_connectors='/usr/lib64/centreon-connector' -d centreon_engine_lib='/usr/lib64/centreon-engine' -d centreonplugins='/usr/lib/centreon/plugins/' http://localhost/centreon/install/steps/process/process_step3.php
read

# 4 Broker module information
#curl -d action="form_step4" -d submit="Next" http://localhost/centreon/install/install.php
curl -d centreonbroker_etc='/etc/centreon-broker' -d centreonbroker_cbmod='/usr/lib64/nagios/cbmod.so' -d centreonbroker_log='/var/log/centreon-broker' -d centreonbroker_varlib='/var/lib/centreon-broker' -d centreonbroker_lib='/usr/share/centreon/lib/centreon-broker' http://localhost/centreon/install/steps/process/process_step4.php
read

# 5 Admin information
#curl -d action="form_step5" -d admin_password='q1w2Q!W@' -d confirm_password='q1w2Q!W@' -d firstname="Admin" -d lastname="Centreon" -d email="root@localhost" -d next="Next" http://localhost/centreon/install/install.php 
curl -d admin_password='q1w2Q!W@' -d confirm_password='q1w2Q!W@' -d firstname="Admin" -d lastname="Centreon" -d email="root@localhost" http://localhost/centreon/install/steps/process/process_step5.php
read

# 6 Database information
#curl -d action="form_step6" -d address="localhost" -d port="3306" -d root_password='' -d db_configuration="centreon" -d db_storage="centreon_storage" -d db_user="centreon" -d db_password='q1w2Q!W@' -d db_password_confirm='q1w2Q!W@' -d next="Next" http://localhost/centreon/install/install.php
#curl -d address='localhost' -d port='3306' -d root_password='' -d db_configuration='centreon' -d db_storage='centreon_storage' -d db_user='centreon' -d db_password='q1w2Q!W@' -d db_passwordd_confirm='q1w2Q!W@' http://localhost/centreon/install/steps/process/process_step6.php
curl -d address='localhost' -d port='3306' --form root_password='' -d db_configuration='centreon' -d db_storage='centreon_storage' -d db_user='centreon' -d db_password='q1w2Q!W@' -d db_password_confirm='q1w2Q!W@' http://localhost/centreon/install/steps/process/process_step6.php
read

# 7 Installation
#curl -d action="form_step7" -d next="Next" -d submit="Next" http://localhost/centreon/install/install.php
curl http://localhost/centreon/install/steps/step.php?action=nextStep
read

# 8 Modules installation
#curl -d installModules="Install" http://localhost/centreon/install/install.php
#curl -d next="Next" -d submit="Next" http://localhost/centreon/install/install.php
curl -d centreon-pp-manager='checked' -d centreon-license-manager='checked' http://localhost/centreon/install/steps/step.php?action=nextStep
read

# 9 
#curl  http://localhost/centreon/install/steps/step.php?action=nextStep
curl http://localhost/centreon/install/steps/step.php?action=nextStep
read





