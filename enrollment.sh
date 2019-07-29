#!/bin/bash

#########################################################
#														#
# Script to be used with ghostpackages for splashbuddy. #
# enrollment.sh 										#
#														#
# this script will call jamf polcies based on their.    #
# custom trigger										#
#														#
#########################################################

currentUser () {
	/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'
}

echo "Checking if user account has been created"

while [[ $(currentUser) = "_mbsetupuser" ]]; do
	sleep 1
done

echo "User account created"
echo "Current username:" $(currentUser)

jamfBinary=$(which jamf)
doneFile="/Users/Shared/.SplashBuddyDone"

echo "Drinking some Red Bull so the Mac doesn't fall asleep"
caffeinate -d -i -m -s -u &
caffeinatepid=$!

# Start installing policies from jamf
echo "Installing Symantech"
${jamfbinary} policy -event "sb_install_symantech"

echo "Installing Chrome"
${jamfbinary} policy -event "sb_install_chrome"

echo "Installing 1Password"
${jamfbinary} policy -event "sb_install_slack"

echo "Installing Zoom Client"
${jamfbinary} policy -event "sb_install_google_filestream"

echo "Installing Slack"
${jamfbinary} policy -event "sb_install_pycharm"

echo "Installing HomeBrew"
${jamfbinary} policy -event "sb_install_homebrew"

echo "Installing Google FileStream"
${jamfbinary} policy -event "sb_install_postman"

echo "Setting up HomeBrew Packages"
${jamfbinary} policy -event "sb_install_homebrew_packages"

echo "Setting up Tapad's Dock"
${jamfbinary} policy -event "sb_install_office365"

echo "Install DevTools"
${jamfbinary} policy -event "sb_install_devtools"

echo "Creating IT Admin acocunt"
${jamfbinary} policy -event "sb_set_dock"

echo "Pulling down policies"
${jamfbinary} policy -event "sb_security_polcies"

echo "Cleaning up enrollment"
${jamfbinary} policy -event "sb_enrollment_end"

echo "Creating done file"
touch "$doneFile"

echo "Updating Inventory"
${jamfbinary} policy -event "updateInventory"

echo "Quitting SplashBuddy"
osascript -e 'quit app "SplashBuddy"'

echo "Unloading and removing Splashbuddy LaunchDaemon"
launchctl unload /Library/LaunchDaemons/io.fti.splashbuddy.launch.plist
rm -f /Library/LaunchDaemons/io.fti.splashbuddy.launch.plist

echo "Deleting SplashBuddy"
rm -rf "/Library/Application Support/SplashBuddy"

echo "Drank waaaayyyyy too much Red Bull"
kill "$caffeinatepid"

echo "Logging user out to force FileVault encryption"
kill -9 `pgrep loginwindow`