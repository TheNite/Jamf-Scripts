#!/bin/bash
### Future use filevualt commands only work on 10.12+ ###
osvers_major=$(sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(sw_vers -productVersion | awk -F. '{print $2}')
osvers_patch=$(sw_vers -productVersion | awk -F. '{print $3}')
osvers_build=$(sw_vers -buildVersion | awk '{print}')
###########################################################

currentUser=$(who | grep console | head -n 1 | awk '{print $1}') #Get current logged in user 
fvMasterKey="/Library/KeyChains/FileVaultMaster.keychain" #Path to the Institutional master KeyChain for fileVault
compName=$(scutil --get LocalHostName | awk '{print}') #Get Hostname of computer
currentDirectory=$(cd "$(dirname "$0")"; pwd) #Get current working directory
jamf=$(which jamf)
sleepTime=10

#files
userFile=Users_output.txt #file use to dump all created account on laptop 
compInfo=$compName-Info.txt #Future use

#Admin Creds
q4Admin=
q4Pass=
q3Admin=
q3Pass=


#Get Current Status of FileVault. 
function getFVStatus {
	##################### Possible Outcomes #####################
	# FileVault master keychain appears to be installed. (Will show if first even if filevault is off or on)
	# FileVault is On
	# FileVault is Off
	# Deferred enablement appears to be active for user
	# File Vault is currently being decrypted.
	# FileVault is currently being encrypted.
	############################################################
	fdesetup status | tail -n 1
}

#Remove Profiles
function removeProfile {
	for identifier in $(profiles -L | awk "/attribute/" | awk '{print $4}')
	do 
		## Check that to see if jamf profile is already installed and skip deletion
  		if [ $identifier == "DB614DDE-6B22-449A-986E-75584CDBFBD1" ] ||  [ $identifier == "DB614DDE-6B22-449A-986E-75584CDBFBD1" ] || [ $identifier == "80143B11-A9F4-40B8-805B-4E307B81F6CB" ] || 
  			[ $identifier == "160CA691-3A44-4FAF-93F7-4689A3B07A20" ] || [ $identifier == "D929A889-08C9-40B2-A629-59BA6F13FEB8" ] || [ $identifier == "com.jamfsoftware.tcc.management" ] || 
  				[ $identifier == "com.meraki.wifi.pap.ttls" ] || [ $identifier == "00000000-0000-0000-A000-4A414D460003" ]; then 
    		#echo $identifier whitelisted profile found... skipping deletion
    		:
  		else
    		echo deleting $identifier
    		profiles -R -p $identifier
  		fi
	done
}


# Check for FileVault Master Keychain
function deleteFVMasterKeyChain {
	if [ -f $fvMasterKey ]; then
		echo Found master keychain....deleting
		rm -rf $fvMasterKey
		echo Checking if FileVaultMaster.keychain is still detected.
		#Detect if filevault status still reports master keychain being install.
		while true; do
			if [[ $(getFVStatus) =~ .*installed.* ]]; then
				echo Filevault masterkeychain still detected
				echo pausing for $sleepTime 
				sleep $sleepTime
				sleepTime=$(( $sleepTime + $sleepTime ))
				continue
			else
				echo Filevault master keychain no longer detected
				break
			fi
		done
	else
		echo Master Key not found.
	fi
}

#Disable FileVault 
function disableFV {
	#output current users on mac
	dscl . list /Users | grep -v "^_" | tee $userFile
	#Check for current sysadmin account. 
	if grep -Fxq sysadmin18q4 "$userFile"; then
		echo Sysadmin18q4 Account found...disabling filevault
		fdesetup disable -u $q4Admin -p $q4Pass
	elif grep -Fxq sysadmin18q3 "userFile"; then
		echo Sysadmin18q3 Account found...disabling filevault
		fdesetup disable -u $q3Admin -p $q3Pass
	else
		echo "Unable to disable filevault....no known sysadmin account found."
	fi
	rm $userFile #remove user file created by the disableFV function.
}

#install Jamf QuickAdd package
function installJamf {
	cd $currentDirectory
	installer -allowUntrusted -verboseR -pkg QuickAdd.pkg -target /
}

#Delete profiles first as there is profile for filevault with the masterkeychain
echo Looking through profiles
removeProfile 

#Time look delete the filevault aster keychain
echo Looking for Master KeyChain
deleteFVMasterKeyChain

#Check for filevault status and base on status do X.
if [[ $(getFVStatus) =~ .*On.* ]]; then
	echo $(getFVStatus)
	if [[ -e "$jamf" ]]; then #If jamf is already installed , we do not want to turn off filevault is already installed.
		echo FileVault is on and Jamf is installed.
	else
		echo Jamf not found.
		echo disabling filevault...
    	disableFV
    fi
elif [[ $(getFVStatus) =~ .*Off.* ]]; then
	echo $(getFVStatus)
	echo Checking if jamf is installed.
    if [[ -e "$jamf" ]]; then
    	echo Jamf already installed.
    else
    	echo installing Jamf....
    	installJamf
    fi
elif [[ $(getFVStatus) =~ .*Decrypt.* ]]; then
    echo Filevault is currently being decrypted.
    echo $(getFVStatus)
elif [[ $(getFVStatus) =~ .*Encrypt.* ]]; then
    echo Filevault Currently being encrypted. 
    echo $(getFVStatus)
else
	echo Unkown
    echo $(getFVStatus)
    exit 1
fi

rm -rf $currentDirectory
