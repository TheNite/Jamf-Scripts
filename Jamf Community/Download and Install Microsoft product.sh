#!/bin/bash

<<ABOUT_THIS_SCRIPT
-----------------------------------------------------------------------

	Written by:William Smith
	Professional Services Engineer
	Jamf
	bill@talkingmoose.net
	https://gist.github.com/talkingmoose/a16ca849416ce5ce89316bacd75fc91a
	
	Originally posted: November 19, 2017
	Updated: December 19, 2018

	Purpose: Downloads and installs the latest available Microsoft
	product specified directly on the client. This avoids having to
	manually download and store an up-to-date installer on a
	distribution server every month.
	
	Instructions: Update the linkID value to one of the corresponding
	Microsoft products in the list and run the script with elevated
	privileges. If using Jamf Pro, consider replacing the linkID value
	with "$4" and entering the ID as a script parameter in a policy.

	Except where otherwise noted, this work is licensed under
	http://creativecommons.org/licenses/by/4.0/

	"You say goodbye and I say exit 0."
	
-----------------------------------------------------------------------
ABOUT_THIS_SCRIPT

# enter the Microsoft fwlink (permalink) product ID
# or leave blank if using a $4 script parameter with Jamf Pro

linkID="" # e.g. "525133" for Office 2019

# 525133 - Office 2019 for Mac SKUless download (aka Office 365)
# 2009112 - Office 2019 for Mac BusinessPro SKUless download (aka Office 365 with Teams)
# 871743 - Office 2016 for Mac SKUless download
# 525134 - Word 2019 SKUless download
# 871748 - Word 2016 SKUless download
# 525135 - Excel 2019 SKUless download
# 871750 - Excel 2016 SKUless download
# 525136 - PowerPoint 2019 SKUless download
# 871751 - PowerPoint 2016 SKUless download
# 525137 - Outlook 2019 SKUless download
# 871753 - Outlook 2016 SKUless download
# 820886 - OneNote download
# 823060 - OneDrive download
# 830196 - AutoUpdate download
# 800050 - SharePoint Plugin download
# 832978 - Skype for Business download
# 869655 - InTune Company Portal download
# 868963 - Remote Desktop
# 869428 - Teams

if [ "$4" != "" ] && [ "$linkID" = "" ]
then
    linkID=$4
fi

# this is the full fwlink URL
url="https://go.microsoft.com/fwlink/?linkid=$linkID"

# change directory to /private/tmp to make this the working directory
cd /private/tmp/

# download the installer package and name it for the linkID
/usr/bin/curl -JL "$url" -o "$linkID.pkg"

# install the package
/usr/sbin/installer -pkg "$linkID.pkg" -target /

# remove the installer package when done
/bin/rm -f "$linkID.pkg"

exit 0
