#!/bin/bash

serial_number=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')

ComputerName="COMP${serial_number:(-6)}"

echo $ComputerName

scutil --set HostName $ComputerName
scutil --set LocalHostName $ComputerName
scutil --set ComputerName $ComputerName

dscacheutil -flushcache