#!/bin/bash
# Link must be a direct link to the file.
# e.g. 	https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
# For security's sake, ONLY USE HTTPS LINKS FROM KNOWN GOOD VENDOR SOURCES
# A null $4 returns an errors
# in Jamf, parameters 1–3 are predefined as mount point, computer name, and username
downloadUrl="$4"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Check to see if values are added in Jamf policy
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if [ -z "$4" ]; then
		printf "Parameter 4 is empty. %s\n" "Populate parameter 4 with the package download URL."
		exit 3
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Variables
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

timeStamp=$(date +"%F %T")

# Get the download file name
pkgName=$(basename "$downloadUrl")

# Directory where the file will be downloaded to
downloadDirectory="/Cedar/Downloaded"

# Directory where DMG would be mounted to
dmgMount="$downloadDirectory/mount"

# Get download file extension
downloadExt="${pkgName##*.}"

## Get OS version and adjust for use with the URL string
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

## Set the User Agent string for use with curl
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Functions
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

createDirectory() {
    if [ ! -d $1 ]; then
    	echo "directory not found...making $downloadDirectory"
        mkdir -p $1
    fi
    printf "found $downloadDirectory \n Do not need to create directory"
}

cleanUp(){
	echo "Cleaning up......"
	for filename in $downloadDirectory/*; do
		printf "deleting $filename \n"
		rm -rf $filename
	done
	echo "done"
}

installDmg() {
		# If container is a .dmg:
			# Mount installer container
			# -nobrowse to hide the mounted .dmg
			# -noverify to skip .dmg verification
			# -mountpoint to specify mount point
			hdiutil attach $downloadDirectory/$pkgName -nobrowse -noverify -mountpoint $dmgMount
			if [ -e "$dmgMount"/*.app ]; then
				printf "Found .app inside DMG \n"
      			cp -pPR "$dmgMount"/*.app /Applications
    		elif [ -e "$dmgMount"/*.pkg ]; then
    			print "Found .pkg inside dmg \n"
      			pkgName=$(ls -1 "$dmgMount" | grep .pkg | head -1)
      			installer -allowUntrusted -verboseR -pkg "$dmgMount"/"$pkgName" -target /
    		fi
    		hdiutil detach $dmgMount
}


installZippedApp() {
	unzip $downloadDirectory/$pkgName &
	echo "Unzipping......please wait"
	wait
	echo "Finish unzipping"

	if [ -e "$downloadDirectory"/*.app ]; then
		printf "Extracted .app file......\nCopying application to Applications folder\n"
		cp -pPR $downloadDirectory/*.app /Applications
	else
		printf "No .app file found in zip\n"
	fi
}

printErrorMessage() {
	printf "$timeStamp %s\n" "$downloadExt" "is an unknown file type."
	printf "$timeStamp %s\n" "Downloaded $pkgName from..."
	printf "$timeStamp %s\n" "$downloadUrl"
	rm -rf "$downloadDirectory"/"$pkgName"
	printf "$timeStamp %s\n" "Deleted $pkgName"
	exit 4
}

installApplication() {
	case $downloadExt in
		pkg)
			# Install package
			installer -allowUntrusted -verboseR -pkg "$downloadDirectory"/"$pkgName" -target / 
			installerExitCode=$?
				if [ "$installerExitCode" -ne 0 ]; then
					printf "Failed to install: %s\n" "$pkgName"
					printf "Installer exit code: %s\n" "$installerExitCode"
					exit 2
				fi
			;;
		app) 
			cp -pPR "$downloadDirectory"/*.app /Applications
			;;
		dmg)
			installDmg
			;;
		zip)
			installZippedApp
			;;
		*)
			printErrorMessage
	esac

}

downloadFile() {
	createDirectory $downloadDirectory #Create directory $downloadDirectory, continue if directory already exists
	cd $downloadDirectory
	printf "Downloading File....\n $downloadUrl" # Print message
	if [[ "$downloadUrl" == *"postman"* ]] || [[ "$downloadUrl" == *"pstmn.io"* ]]; then
		echo "Downloading Postman"
		pkgName="postman"
		downloadExt="zip"
		curl -O -A $userAgent -L $downloadUrl > $downloadDirectory/postman.zip
	elif [[ "$downloadUrl" == *"slack"* ]]; then
		echo "Downloading Slack"
		pkgName="slack"
		downloadExt="dmg"
		curl -O -A $userAgent -L $downloadUrl > $downloadDirectory/slack.dmg
	else
		curl $downloadUrl -O -L #Download file without changing its name.
	fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# BLAST OFF!!
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

printf "Current working extension: $downloadExt \n"
downloadFile
installApplication
cleanUp

exit 0

