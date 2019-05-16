#!/usr/bin/bash
now=`date +%Y%M%d%H%m%S`
#old_pwd - old password, it could be provided
# as the first incoming parameter to the script
old_pwd=$1
#new_pwd - new password to be encrypted, it could be provided
# as the second incoming parameter to the script
new_pwd=$2
#filelist_of_scripts - predefined file with the list of all scripts to be updated
filelist_of_scripts=./filelist_xml
#path_list - the list of folders where server.xml scripts to be updated are found
path_list=`cat ${filelist_of_scripts}`
#new_crypted_pwd - is made by Encryptor.sh
new_crypted_pwd=`./Encryptor.sh ${new_pwd}`

for script_name in ${path_list}
do
  echo "Start with File:       ${script_name}"
	echo "Copying script to backup file ..."
  cp ${script_name} ${script_name}_backup_pwd_change
	echo "Changing password in script"
#29301927e4e1ccb6aee75a1cefb11fdc - is encrypted old password
	sed -i "s/29301927e4e1ccb6aee75a1cefb11fdc/${new_crypted_pwd}/g" ${script_name}
done
