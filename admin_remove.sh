#!/bin/sh

adminUsers=$(dscl . -read Groups/admin GroupMembership | cut -c 18-)

writeToLog() {
	if [[ "$(/usr/bin/id -u)" -eq 0 ]]; then
		#Check if file exist
		if [[ -f "$logFile" ]];then
			echo $currentTime $1 >> $logFile
		else
			echo "Creating log file in $logFile"
			touch $logFile	
			echo $currentTime $1 >> $logFile
		fi
	else
		echo "Root access not found"
	fi
}


for user in $adminUsers
do
    if [ "$user" != "root" ]  && [ "$user" != "sysadminmanaged" ]
    then 
        dseditgroup -o edit -d $user -t user admin
        if [ $? = 0 ]; then writeToLog "Removed user $user from admin group"; fi
    else
       writeToLog "Admin user $user left alone"
    fi
done