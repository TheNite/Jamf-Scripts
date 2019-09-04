#!/bin/bash
# The script uses Parameters 4, 5, 6 and 7
# to pass the API write username, password, group names and groups ID, respectively to the script

currentUser () {
    /usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'
}

function getFVStatus {
    ##################### Possible Outcomes #####################
    # FileVault master keychain appears to be installed. (Will show if first even if filevault is off or on)
    # FileVault is On
    # FileVault is Off
    # Deferred enablement appears to be active for user
    # File Vault is currently being decrypted.
    # FileVault is currently being encrypted.
    ############################################################
    fdesetup status | tail -n 1
}

function displayDialog() {
 osascript <<EOT
    tell app "System Events"
      display dialog "$1" buttons {"OK"} default button 1 with icon caution with title "$(basename $0)"
      return  -- Suppress result
    end tell
EOT
}


function checkForRequirements() {
    # Check for zoomroom username
    if [[ $(currentUser) != "zoomroom" ]]; then
        displayDialog "Current username is not the standard username setup for zoom \nCurrent Username: $(currentUser)" 
        exit 1
    fi
    # Check for filevault Status
    if [[ $(getFVStatus) =~ .*On.* ]]; then
        displayDialog "$(getFVStatus).... Cannot continue"
        exit 1
    fi
    # Check hostname
    if [[ $(hostname) =~ .*conf.* ]]; then
        displayDialog "Hostname does not follow standards \nHostname: $(hostname)"
        exit 1
    fi

    kill "$caffeinatepid"
} 

jamfBinary=$(which jamf)

# Caffeinate computer
echo "Drinking some Red Bull so the Mac doesn't fall asleep"
caffeinate -d -i -m -s -u &
caffeinatepid=$!

#Display warning before continuing
displayDialog "Before continuing make sure the activation code is populated in the 'Room' Extension Attribute first and that the computer is added to ZoomRoom_ActivationCode group"
displayDialog "Automatic activation of Zoom Room will not work without the activation code being populated first"

checkForRequirements

#Start installation of policy
echo "Installing zoom room"
${jamfBinary} policy -event "install_software_zoomroom"

echo "Installing Bomgar"
${jamfBinary} policy -event "install_bomgar"

echo "Drank waaaayyyyy too much Red Bull"
kill "$caffeinatepid"

displayDialog "Setup complete.\n Make sure bomgar is installed and zoom room is working."
