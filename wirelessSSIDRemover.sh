#!/bin/sh

ssid=""
wservice=`networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)'`
device=`networksetup -listallhardwareports | awk "/$wservice/,/Ethernet Address/" | awk 'NR==2' | cut -d " " -f 2`
current=`networksetup -getairportnetwork "$device" | sed -e 's/^.*: //'`

networksetup -removepreferredwirelessnetwork "$device" "$ssid"

if [[ "$current" -eq "$ssid" ]] then
    networksetup -setairportpower "$device" off
    networksetup -setairportpower "$device" on
fi
