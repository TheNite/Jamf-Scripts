#!/bin/bash

#Apple approve way of getting current user until 10.15
function loggedInUser() {
	/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'
}

## Check that a user is currently logged in before contiuning
while [[ "$(loggedInUser)" == "_mbsetupuser" ]]; do
	printf "No Logged in user found\nSleeping 2 seconds\n"
	sleep 2
done

jamfbinary=$(/usr/bin/which jamf)
doneFile="/Users/Shared/.SplashBuddyDone"

echo "Drinking some Red Bull so the Mac doesn't fall asleep"
caffeinate -d -i -m -s -u &
caffeinatepid=$!

# Start installing policies from jamf
echo "Installing CB Defense"
${jamfbinary} policy -event "sb_install_cb_defense"

echo "Installing Chrome"
${jamfbinary} policy -event "sb_install_chrome"

echo "Installing 1Password"
${jamfbinary} policy -event "sb_install_1password"

echo "Installing Zoom Client"
${jamfbinary} policy -event "sb_install_zoom_client"

echo "Installing Slack"
${jamfbinary} policy -event "sb_install_slack"

echo "Installing HomeBrew"
${jamfbinary} policy -event "sb_install_brew"

echo "Installing Google FileStream"
${jamfbinary} policy -event "sb_install_google_filestream"

echo "Setting up HomeBrew Packages"
${jamfbinary} policy -event "sb_install_brew_packages"

echo "Setting up Tapad's Dock"
${jamfbinary} policy -event "sb_set_dock"

echo "Pulling down FileVault 2 configuration"
${jamfbinary} policy -event "sb_requireFV2"

echo "Creating IT Admin acocunt"
${jamfbinary} policy -event "sb_account_admin"

echo "Finishing up enrollment"
${jamfbinary} policy -event "sb_finish_enrollment"

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

