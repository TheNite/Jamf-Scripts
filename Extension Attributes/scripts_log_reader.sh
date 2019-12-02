#!/bin/bash

# This script will read the last 100 files from the scripts.log file
# the scripts.log file is a file that we will be using moving forward to log actions of a script. 

logs=$(tail -f -n 100 "/var/log/scripts.log")
echo "<result>$logs</result>"