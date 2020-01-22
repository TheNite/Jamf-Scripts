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
	# Apple macOS 10.14+ approved way of getting the current login user
	/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'	
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

# Checking to see if the Finder is running now before continuing. This can help
# in scenarios where an end user is not configuring the device.
# This is also a requirement for catalina to make sure things are run properly
FINDER_PROCESS=$(pgrep -l "Finder")
until [ "$FINDER_PROCESS" != "" ]; do
	echo "Finder process not found. Assuming device is at login screen."
	sleep 1
	FINDER_PROCESS=$(pgrep -l "Finder")
done

# Caffeinate computer so it doesn't follow as sleep
caffeinate -d -i -m -s -u &
caffeinatepid=$   ! 
writeToLog "Caffeinated computer: $caffeinatepid"

# double check user is not the setup user or root
while [[ $(loggedInUser) = "_mbsetupuser" ]] || [[ $(loggedInUser) = "root" ]]; do
	sleep 1
done

# Check current login user
writeToLog "Current login user: $(loggedInUser)"

# Update computer inventory so things run as current loggedin user
writeToLog "Update computer inventory"
writeToLog $(${jamfBinary} policy -event "update_Inventory") # update computer inventory

# Install Ceremony
writeToLog "Installing Ceremony"
writeToLog $(${jamfBinary} policy -event "install_ceremony")

writeToLog "Waiting 5 seconds before continuing"
sleep 5


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