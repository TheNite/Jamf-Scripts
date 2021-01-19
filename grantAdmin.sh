#!/bin/bash

currentUser=$(who | awk '/console/{print $1}')
echo $currentUser

/usr/sbin/dseditgroup -o edit -a $currentUser -t user admin

exit 0
