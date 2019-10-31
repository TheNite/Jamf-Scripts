#!/bin/bash

# The Bomgar DMG should have been installed cached prior to this script running, but we should make sure...

sleep 5

# Attach the Disk Image
    hdiutil attach /Library/Application\ Support/JAMF/Waiting\ Room/bomgar-scc-w0edc30zifyh6y1ge1fgz6x888heex7zz5yzgi6c40hc90.dmg

# Run the installer
    /Volumes/bomgar-scc/Double-Click\ To\ Start\ Support\ Session.app/Contents/MacOS/sdcust

# Wait a minute for it to finish up
    sleep 60

# Unmount the disk image
    hdiutil detach /Volumes/bomgar-scc

# Wait for the unmount to complete
    sleep 5

# Delete the disk image
    rm -R /Library/Application\ Support/JAMF/Waiting\ Room/bomgar-scc-w0edc30zifyh6y1ge1fgz6x888heex7zz5yzgi6c40hc90.dmg

