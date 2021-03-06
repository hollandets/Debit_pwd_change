#!/bin/bash
now=`date +%Y%m%d%H%M%S`
#old_pwd - old password, it could be provided as the first incoming parameter to the script
#BnowqUKf - is encrypted old password
old_pwd=$1
#new_pwd - new password, it could be provided as the second incoming parameter to the script
new_pwd=$2
#file_list - the list of files to be updated are found
file_list="/u/debit/apps/dnl/config-prod.toml /u/debit/apps/plan-store/config-prod.toml /u/debit/apps/employee-plan/config-prod.toml"

for script_name in $file_list
do
  if [ -f "$script_name" ]; then
    echo "Start with File:    ${script_name}"
    echo "    Copying script to backup file ..."
    cp $script_name ${script_name}_backup_${now}
    echo "    Changing password in script ..."
    if [ $(uname) == "SunOS" ]; then
#changing all the entries of old_pwd to new_pwd via creating temp file for Solaris SunOS
      sed "s/${old_pwd}/${new_pwd}/g" $script_name > ./temp_solaris.tmp && mv ./temp_solaris.tmp $script_name
    else
#changing all the entries of old_pwd to new_pwd in script
      sed -i "s/${old_pwd}/${new_pwd}/g" $script_name
    fi
    echo "Finished with File:  ${script_name}"
  fi
done
