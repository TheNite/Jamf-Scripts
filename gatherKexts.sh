#!/bin/sh
# Gather list of User Approved Kernel Extensions. 20180313 DM

folder="Path to Folder"
file=checkKEXTs.csv

# Create folder
/bin/mkdir -p ${folder}
/usr/sbin/chown root:admin ${folder}
/bin/chmod 755 ${folder}

/usr/bin/sqlite3 -csv /var/db/SystemPolicyConfiguration/KextPolicy "select team_id,bundle_id from kext_policy" > ${folder}/${file}

printf "Wrote all current user approved kexts on this computer to \n$folder\n"

exit 0
