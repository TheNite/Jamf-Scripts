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
Apps=("List of app here")

#Apps that are installed in the '/Applications/Utitlies/' directory
utilApps=("")

#Folders to add to the dock
userFolders=("")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

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

for app in "${Apps[@]}"; do
	echo ${app}
	$dockutil --add "$appFolder/${app}" --no-restart --allhomes
done

for app in "${utilApps[@]}"; do
	$dockutil --add "$utilAppFolder/${app}" --no-restart --allhomes
done

for folder in "${userFolders[@]}"; do
	$dockutil --add "~/${folder}" --no-restart --allhomes
done

# Cleanup

sleep $sleepTime

/usr/bin/killall Dock >/dev/null 2>&1

exit 0