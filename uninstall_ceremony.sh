#!/bin/bash

################################
# Script to uninstall Ceremony #
################################

jamfBinary=$(/usr/bin/which jamf)
jamfLog="/var/log/jamf.log"
logFile="/var/log/scripts.log"
currentTime="$(date +"%D %I:%M:%S %p")"
scriptName=$(basename -- "$0")
doneFile="/Users/Shared/.CeremonyDone"
caffeinatePID=$(ps -A | grep -m1 caffeinate | awk '{print $1}')

checkForRoot() {
	if [[ "$(/usr/bin/id -u)" -eq 0 ]]; then # check for root access
		echo "Root access found"
	else
		echo "Root access not found"
		exit 1
	fi
}

writeToLog() {
		if [[ -f "$logFile" ]];then #Check if file exist
			echo $@
			echo $currentTime $scriptName: $@ >> $logFile
		else
			touch $logFile	
			echo $@
			echo $currentTime $scriptName "Created log file....." >> $logFile
			echo $currentTime $scriptName $@ >> $logFile
		fi
}

# Used to trick Ceremony app monitoring (ghost packages)
writeToJamfLog() {
	touch $jamfLog
	writeToLog "JAMF-LOG: $1"
	echo $currentTime $scriptName $@ >> $jamfLog
}

writeToLog "Quiting ceremony"
osascript -e 'quit app "Ceremony"'

writeToLog "Unloading and removing Ceremony LaunchDaemon"
launchctl unload /Library/LaunchDaemons/com.amaris.ceremony.launch.plist
rm -f /Library/LaunchDaemons/com.amaris.ceremony.launch.plist

writeToLog "Deleting Ceremony"
rm -rf "/Library/Application Support/Ceremony"

rm -rf $doneFile

kill $caffeinatePID

exit 0