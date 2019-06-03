#!/bin/bash
now=`date +%Y%m%d%H%M%S`
#old_pwd - old password, it could be provided as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password, it could be provided as the second incoming parameter to the script
new_pwd=$2
#file_list - the list of files in /u/debit/lib/ to be updated
file_list="/u/debit/lib/.dbpasswd_debit1 /u/debit/lib/.dbpasswd_credrules /u/debit/lib/.dbpasswd.debitapp01 /u/debit/lib/.debitapp01.dbpasswd /u/debit/lib/.debitapp02.dbpasswd /u/debit/lib/.debitapp04.dbpasswd /u/debit/lib/.debitapp03.dbpasswd /u/debit/lib/.debitapp01.dbpasswd_hold /u/debit/lib/.debitapp02.dbpasswd_hold /u/debit/lib/.debitapp03.dbpasswd_hold /u/debit/lib/.debitapp04.dbpasswd_hold /u/debit/lib/.debitapp01.dbpasswd_jbird /u/debit/lib/.credDbPasswd /u/debit/lib/.dbpasswd"
#encrypt_key - ENCRYPTION_KEY
encrypt_key=/u/debit/lib

for script_name in $file_list
do
  if [ -f "$script_name" ]; then
    echo "Start with File:    ${script_name}"
    echo "    Copying script to backup file ..."
    cp $script_name ${script_name}_backup_${now}
    echo "    Changing password in script ..."
#decrypt old file and put its content to temporary file
    crypt $encrypt_key < ${script_name}_backup_${now} > ./temporary_file
    if [ $(uname) == "SunOS" ]; then
#changing all the entries of old_pwd to new_pwd via creating temp file for Solaris SunOS
      sed "s/${old_pwd}/${new_pwd}/g" ./temporary_file > ./temp_solaris.tmp && mv ./temp_solaris.tmp ./temporary_file
#encrypt new password for Solaris SunOS
      cat ./temporary_file | crypt $encrypt_key > ${script_name}
    else
#changing all the entries of old_pwd to new_pwd in decrypted temporary file
      sed -i "s/${old_pwd}/${new_pwd}/g" ./temporary_file
#encrypt new password file for Linux
      cat ./temporary_file | crypt --encrypt $encrypt_key > ${script_name}
    fi
    rm ./temporary_file
    echo "Finished with File:  ${script_name}"
  fi
done
