#!/bin/bash
now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided
# as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#file_list - the list of files in /u/debit/lib/ to be updated
file_list="/u/debit/lib/.dbpasswd_pair2 /u/debit/lib/.dbpasswd_fincredrules /u/debit/lib/.newdbpasswd_credrules /u/debit/lib/.dbpasswd_credrules_debitapp03 /u/debit/lib/.dbpasswd_credrules_aws_prod /u/debit/lib/.dbpasswd_aws_prod /u/debit/lib/.credDbPasswd /u/debit/lib/.dbpasswd_credrules_aws11 /u/debit/lib/.dbpasswd_aws11 /u/debit/lib/.credDbPasswd_aws11 /u/debit/lib/.dbpasswd_credrules /u/debit/lib/.dbpasswd"
#encrypt_key - ENCRYPTION_KEY
encrypt_key=/u/debit/lib

for script_name in ${file_list}
do
  if [ -f "$script_name" ]; then
    echo "Start with File:       ${script_name}"
    echo "Copying script to backup file ..."
    cp ${script_name} ${script_name}_backup_${now}
    echo "Changing password in script"
#decrypt old file and put its content to temporary file
    crypt $encrypt_key < ${script_name}_backup_${now} > ./temporary_file
#old_pwd - is an old password, change it to the new one
    sed -i "s/${old_pwd}/${new_pwd}/g" ./temporary_file
#encrypt new password
    cat ./temporary_file | crypt --encrypt $encrypt_key > ${script_name}
    rm ./temporary_file
  fi
done
