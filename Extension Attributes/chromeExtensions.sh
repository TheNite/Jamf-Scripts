#!/bin/bash

<<COMMENT1
Displays Name, Version and ID of installed Google Chrome Extensions for current or last user.

By default, data is displayed as:

Name: Extension Name
Version: Extension Version
ID: Extension ID.

However, if further data analysis is needed, an alternate output is available:

Name;Version;ID

The default output looks much prettier in the JSS, but the alternative output may be more useful.  

To use the alternate output, simply comment out line:

echo -e "Name: $reportedName \nVersion: $version \nID: $extID \n"

And uncomment line:

echo -e "$reportedName;$version;$extID"
COMMENT1

# Setting IFS Env to only use new lines as field seperator 
IFS=$'\n'

currentUser=`ls -l /dev/console | awk {' print $3 '}`
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`

if [[ "$currentUser" = "" || "$currentUser" = "root" ]]
	then userHome=`/usr/bin/dscl . -read /Users/$lastUser NFSHomeDirectory | awk -F ": " '{print $2}'`
	else userHome=`/usr/bin/dscl . -read /Users/$currentUser NFSHomeDirectory | awk -F ": " '{print $2}'`
fi

createChromeExtList ()
{
for manifest in $(find "$userHome/Library/Application Support/Google/Chrome/Default/Extensions" -name 'manifest.json')
	do 
		name=$(cat $manifest | grep '"name":' | awk -F "\"" '{print $4}')
		if [[ `echo $name | grep "__MSG"` ]]
			then
				msgName="\"`echo $name | awk -F '__MSG_|__' '{print $2}'`\":"
				if [ -f $(dirname $manifest)/_locales/en/messages.json ]
					then reportedName=$(cat $(dirname $manifest)/_locales/en/messages.json | grep -i -A 3 "$msgName" | grep "message" | head -1 | awk -F ": " '{print $2}' | tr -d "\"")
				elif [ -f $(dirname $manifest)/_locales/en_US/messages.json ]
					then reportedName=$(cat $(dirname $manifest)/_locales/en_US/messages.json | grep -i -A 3 "$msgName" | grep "message" | head -1 | awk -F ": " '{print $2}' | tr -d "\"")
				fi
			else
				reportedName=$(cat $manifest | grep '"name":' | awk -F "\"" '{print $4}')
		fi
		version=$(cat $manifest | grep '"version":' | awk -F "\"" '{print $4}')
		extID=$(basename $(dirname $(dirname $manifest)))
		
		# This is the default output style - looks nice in JSS
		# Comment out line below if you wish to use alternate output
	 	echo -e "Name: $reportedName \nVersion: $version \nID: $extID \n"
	 	
	 	# This is the alternate output style - looks ugly in JSS, but possibly more useful
	 	# Uncomment line below to use this output instead
	 	#echo -e "$reportedName;$version;$extID"
 done
 }

if [ -d "$userHome/Library/Application Support/Google/Chrome/Default/Extensions" ]
        then result="`createChromeExtList`"
        else result="NA"
fi

echo "<result>$result</result>"