#!/bin/bash
now=`date +%Y%M%d%H%m%S`
#BnowqUKf - is encrypted old password
#old_pwd - old password, it could be provided as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#path_list - the list of folders where toml scripts to be updated are found
path_list="/u/debit/apps/dnl/config-prod.toml /u/debit/apps/plan-store/config-prod.toml"

for script_name in ${path_list}
do
  if [ -f "$script_name" ]; then
    echo "Start with File:       ${script_name}"
    echo "Copying script to backup file ..."
    cp ${script_name} ${script_name}_backup_${now}
    echo "Changing password in script"
    sed -i "s/${old_pwd}/${new_pwd}/g" ${script_name}
  fi
done
