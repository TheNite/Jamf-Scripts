#!/bin/bash
# This script will delete a current installation of iTerm2

iTerm2="/Applications/iTerm.app"
jamf=$(which jamf)


function check4iTerm() {
	if [ -e $iTerm2 ]; then
		echo "iTerm found"
		echo "Killing iTerm"
		pkill "iTerm"
		rm -rf $iTerm2
	else
		echo "iTerm not found on the computer"
		exit 1
	fi
}

function displayDialog() {
 osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon caution with title "$(basename $0)"
      return  -- Suppress result
    end tell
EOT
}
#Display Warning
displayDialog "Due to recent security flaws with older verisons iTerm2 we will be removing it and installing the latest version.\n\nPlease make sure you save your work now, we will be removing iTerm in 10 minutes." &

#Wait 10 minutes
sleep 600

#Remove iTerm
check4iTerm

#Install iTerm
${jamf} policy -event "install_iterm2"

#update inventory
${jamf} recon

