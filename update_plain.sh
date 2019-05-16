#!/usr/bin/bash
now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided
# as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password not to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#path_list - the list of folders where scripts to be updated are found
path_list="/u/ixc/orawork /u/ixc/orawork/Whitelist /u/debit/bin"

for path in $path_list
do
  echo "Start with Folder:     ${path}"
  find $path -maxdepth 1 -type f | xargs grep "${old_pwd}" | grep -i "PASSW.*D.*${old_pwd}" | sed 's/:.*//' | sort -u > ./temporary_file
  echo "Copying script to backup file ..."
  while read script_name
  do
    cp ${script_name} ${script_name}_backup_pwd_change
  done < ./temporary_file
  echo "Changing password in script"
  cat ./temporary_file | xargs sed -i "s/${old_pwd}/${new_pwd}/g"
  rm ./temporary_file
done
