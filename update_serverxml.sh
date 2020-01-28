#!/bin/bash
#now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided as the second incoming parameter to the script
#821e5fd3a6186a2804e7ffd6d6272cde - is encrypted old password
old_pwd=$2
#new_pwd - new password, it could be provided as the third incoming parameter to the script
new_pwd=$3
#file_w_list - the full path for file with the list of files to be updated
file_w_list=$1
#"/u/debit/apps/tomcat/idt/server.xml.PROD /u/debit/apps/apache-tomcat/conf/server.xml"
#new_crypted_pwd - is made by Encryptor.sh like this =`./Encryptor.sh ${new_pwd}`
new_crypted_pwd=$new_pwd
file_list=`cat $file_w_list`

for script_name in $file_list
do
  if [ -f "$script_name" ]; then
    echo "Start with File:    ${script_name}"
    echo "    Copying script to backup file ..."
    makebak -u $script_name
#    cp $script_name ${script_name}_backup_${now}
    echo "    Changing password in script ..."
    if [ $(uname) == "SunOS" ]; then
#changing all the entries of old_pwd to new_pwd via creating temp file for Solaris SunOS
      sed "s/${old_pwd}/${new_crypted_pwd}/g" $script_name > ./temp_solaris.tmp && mv ./temp_solaris.tmp $script_name
    else
#changing all the entries of old_pwd to new_pwd in script
      sed -i "s/${old_pwd}/${new_crypted_pwd}/g" $script_name
    fi
    echo "Finished with File:  ${script_name}"
  fi
done
