#!/bin/bash

########################################################################
# This script will is to simulate ghost packages with ceremony         #
# it will also install all apps that are necessary for a new employee, #
# using jamf policy triggers. 									       #
########################################################################

jamfBinary=$(/usr/bin/which jamf)
jamfLog="/var/log/jamf.log"
logFile="/var/log/scripts.log"
currentTime="$(date +"%D %I:%M:%S %p")"
scriptName=$(basename -- "$0")
doneFile="/Users/Shared/.CeremonyDone"

loggedInUser() {
	/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'
}

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

#Check current root status
checkForRoot

# Caffeinate computer so it doesn't follow as sleep
caffeinate -d -i -m -s -u &
caffeinatepid=$! 
writeToLog "Caffeinated computer: $caffeinatepid"

# Check current login user
writeToLog "Checking login user is not root or _mbsetupuser 1 before contining. Current user: $(loggedInUser)"


while [[ $(loggedInUser) = "_mbsetupuser" ]] || [[ $(loggedInUser) = "root" ]]; do
	sleep 1
done

writeToLog "Current login user: $(loggedInUser)"

<< 'Comment1'
# Install Ceremony
writeToLog "Installing Ceremony"
writeToLog $(${jamfBinary} policy -event "install_ceremony")
Comment1

##### Start of ceremony visuals #####


writeToLog "Starting application installation using jamf"

writeToJamfLog "Fake:Installing CBDefense-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_cbdefense")
writeToJamfLog "Fake:Successfully installed CBDefense-1.0.0.pkg.."

writeToJamfLog "Fake:Installing GoogleChrome-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_chrome")
writeToJamfLog "Fake:Successfully installed GoogleChrome-1.0.0.pkg.."

writeToJamfLog "Fake:Installing Slack-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_slack")
writeToJamfLog "Fake:Successfully installed Slack-1.0.0.pkg.."

writeToJamfLog "Fake:Installing 1Password-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_1password")
writeToJamfLog "Fake:Successfully installed 1Password-1.0.0.pkg.."

writeToJamfLog "Fake:Installing homebrew-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_homebrew")
writeToJamfLog "Fake:Successfully installed homebrew-1.0.pkg.."

writeToJamfLog "Fake:Installing Zoom-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event "install_zoomclient")
writeToJamfLog "Fake:Successfully installed Zoom-1.0.0.pkg.."

writeToJamfLog "Fake:Installing office365-1.0.0.pkg..."
writeToLog $(${jamfBinary} policy -event	"install_office365")
writeToJamfLog "Fake:Successfully installed office365-1.0.0.pkg.."


#### Final Install of jamf policies & application

writeToJamfLog "Fake:Installing setupfinish-1.0.0.pkg..."

writeToLog "Installing Google file stream"
writeToLog $(${jamfBinary} policy -event "install_google_filestream") # install google filestream

writeToLog "Installing homebrew packages"
writeToLog $(${jamfBinary} policy -event "install_homebrew_packages") # install homebrew packages

writeToLog "enforcing filevault2"
writeToLog $(${jamfBinary} policy -event "enforce_FV2") # enforce filevault

writeToLog "Setting up standard dock..."
writeToLog $(${jamfBinary} policy -event "set_dock") # set standard dock

writeToLog "Update computer inventory"
writeToLog $(${jamfBinary} policy -event "update_Inventory") # update computer inventory

writeToJamfLog "Fake:Successfully installed setupfinish-1.0.0.pkg.."

#### #### End Ceremonry visuals. #### ####

##### Ceremony post-install management

writeToLog "Creating Ceremony done file at $doneFile"
touch $doneFile

writeToLog "Quiting ceremony"
osascript -e 'quit app "Ceremony"'

writeToLog "Unloading and removing Ceremony LaunchDaemon"
launchctl unload /Library/LaunchDaemons/com.amaris.ceremony.launch.plist
rm -f /Library/LaunchDaemons/com.amaris.ceremony.launch.plist

writeToLog "Deleting Ceremony"
rm -rf "/Library/Application Support/Ceremony"

# Stop caffeinate 
writeToLog "Kill caffeinate pid $caffeinatepid"
kill "$caffeinatepid"

# Log out user
writeToLog "Logging user out to force FileVault encryption"
kill -9 `pgrep loginwindow`


exit 0