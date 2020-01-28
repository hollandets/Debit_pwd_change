#!/bin/bash
#now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided as the second incoming parameter to the script
old_pwd=$2
#new_pwd - new password not to be encrypted, it could be provided
# as the third incoming parameter to the script
new_pwd=$3
#file_w_list - the full path for file with the list of folders where scripts to be updated are found
file_w_list=$1
#path_list - the list of folders where scripts to be updated are found
#"/export/home/oracle/SQL /export/home/oracle/pingeneration /u/oracle/scripts /u/oracle/scripts/monitor /u/oracle/SQL /u/oracle/reporting/debit /u/ixc/jjbtmp /u/ixc/orawork /u/ixc/orawork/Whitelist /u/ixc/bin/MoneyGram /u/debit/bin /u/debit/lib /u/ops/lib"
path_list=`cat $file_w_list`

for path in $path_list
do
  echo "Start with Folder:     ${path}"
#search for files in the folder where old_pwd seems to be written as plain text
#put the found list to the temporary file
  find $path -maxdepth 1 -type f | xargs grep -I "${old_pwd}" 2>&1 | grep -i "${old_pwd}" | sed 's/:.*//' | sort -u > ./temporary_file
#loop for every found file to backup it and change the password
  while read script_name
  do
    makebak -u $script_name
#    cp $script_name ${script_name}_backup_${now}
    echo "  File ${script_name} has just been backuped"
    echo "    Changing password in script ..."
    if [ $(uname) == "SunOS" ]; then
#changing all the entries of old_pwd to new_pwd via creating temp file for Solaris SunOS
      sed "s/${old_pwd}/${new_pwd}/g" $script_name > ./temp_solaris.tmp && mv ./temp_solaris.tmp $script_name
    else
#changing all the entries of old_pwd to new_pwd in script
      sed -i "/s/${old_pwd}/${new_pwd}/g" $script_name
    fi
  done < ./temporary_file
  rm ./temporary_file
  echo "Finished with Folder:  ${path}"
done
