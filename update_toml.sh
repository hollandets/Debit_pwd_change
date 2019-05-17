#!/bin/bash
now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided
# as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#path_list - the list of folders where toml scripts to be updated are found
path_list="/u/debit/apps/dnl /u/debit/apps/plan-store"
#old_crypted_pwd - is made by go-common programm
old_crypted_pwd=$old_pwd
#new_crypted_pwd - is made by go-common programm
#new_crypted_pwd=`encrypt -data "${new_pwd}"`
new_crypted_pwd=$new_pwd

for script_name in ${path_list}/config-prod.toml
do
  if [ -f "$script_name" ]; then
    echo "Start with File:       ${script_name}"
    echo "Copying script to backup file ..."
    cp ${script_name} ${script_name}_backup_${now}
    echo "Changing password in script"
#BnowqUKf - is encrypted old password
    sed -i "s/${old_crypted_pwd}/${new_crypted_pwd}/g" ${script_name}
  fi
done
