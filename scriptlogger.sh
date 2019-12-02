#!/bin/bash
# this Script will create a log file for IT scripts/app/etc.

logFile="/var/log/tapad/scripts.log"
currentTime="$(date +"%D %I:%M:%S %p")"

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

