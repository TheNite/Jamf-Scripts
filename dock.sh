#!/bin/bash

# Configure the dock for a new user
# Script to to be use during the splash buddy setup on jamf
# This will also allow new hires to remove any of the default apps if they wish so.
# This script assumes the brew package "Dockutil" is installed as per the enrollment of the computer
# Run this Script with splashbuddy

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Arrays of Apps
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Apps that are installed in the '/Applications/' directory
Apps=("Firefox.app" "Slack.app" "Sublime Text.app" "1Password 7.app" "Messages.app" "Github Desktop.app" "PostMan.app" "xcode.app" "App store.app")

#Default systems that are installed in the '/Applications/Utitlies/' directory
system_utilities_apps=("Terminal.app")

#System defautl apps that are installed in the '/Applications/' OR for Catalina in '/System/Applications/' directory
system_default_apps=("System Preferences.app")

#Folders to add to the dock
user_folders=("Downloads")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 macos_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')

dockutil=/usr/local/bin/dockutil
sleepTime=2

#FolderLocations
appFolder="/Applications"
utilAppFolder="$appFolder/Utilities"

#Remove all current dock items
$dockutil --remove all --no-restart --allhomes

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Add apps to docks
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function dockutil_catalina {
	for app in "${Apps[@]}"; do
		echo ${app}
		$dockutil --add "$appFolder/${app}" --no-restart --allhomes
	done

	for app in "${system_default_apps[@]}"; do
		echo ${app}
		$dockutil --add "/System/Applications/${app}" --no-restart --allhomes
	done

	for app in "${system_utilities_apps[@]}"; do
		echo ${app}
		$dockutil --add "/System/$utilAppFolder/${app}" --no-restart --allhomes
	done

	for folder in "${userFolders[@]}"; do
		$dockutil --add "~/${folder}" --no-restart --allhomes
	done
}

function dockutil_all() {
	for app in "${Apps[@]}"; do
		echo ${app}
		$dockutil --add "$appFolder/${app}" --no-restart --allhomes
	done

	for app in "${system_utilities_apps[@]}"; do
		$dockutil --add "$utilAppFolder/${app}" --no-restart --allhomes
	done

	for folder in "${userFolders[@]}"; do
		$dockutil --add "~/${folder}" --no-restart --allhomes
	done
}

# Cleanup

if [[ "$macos_vers" -ge 15 ]]; then
	dockutil_catalina
else
	dockutil_all
fi

sleep $sleepTime

/usr/bin/killall Dock >/dev/null 2>&1

exit 0