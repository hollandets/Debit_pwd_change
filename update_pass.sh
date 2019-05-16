#!/usr/bin/bash
now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided
# as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#file_list - the list of files in /u/debit/lib/ to be updated
file_list=".dbpasswd_credrules .dbpasswd .credDbPasswd .dbpasswd_debit1"
#work_folder - the path to the folder for backuping initial scripts
work_folder=/u/debit/lib
#encrypt_key - ENCRYPTION_KEY
encrypt_key=/u/debit/lib

for script_name in $work_folder/${file_list}
do
  echo "Start with File:       ${script_name}"
  echo "Copying script to backup file ..."
  cp ${script_name} ${script_name}_backup_pwd_change
  echo "Changing password in script"
#decrypt old file and put its content to temporary file
  crypt $encrypt_key < ${script_name}_backup_pwd_change > ./temporary_file
#old_pwd - is an old password, change it to the new one
  sed -i "s/old_pwd/${new_pwd}/g" ./temporary_file
#encrypt new password
  cat ./temporary_file | crypt --encrypt $encrypt_key > ${script_name}
  rm ./temporary_file
done
