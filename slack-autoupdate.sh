#!/bin/bash


DOWNLOAD_URL="https://slack.com/ssb/download-osx"

APP_NAME="Slack.app"
APP_PATH="/Applications/$APP_NAME"
APP_VERSION_KEY="CFBundleShortVersionString"

loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

SLACK_UNZIP_DIRECTORY="/Users/$loggedInUser"
SLACK_APP_UNZIPPED_PATH="/Users/$loggedInUser/Slack.app"

echo $SLACK_UNZIP_DIRECTORY

currentSlackVersion=$(/usr/bin/curl -s 'https://downloads.slack-edge.com/mac_releases/releases.json' | grep -o "[0-9]\.[0-9]\.[0-9]" | tail -1)

if [ -d "$APP_PATH" ]; then
    localSlackVersion=$(defaults read "$APP_PATH/Contents/Info.plist" "$APP_VERSION_KEY")
    if [ "$currentSlackVersion" = "$localSlackVersion" ]; then
        printf "Slack is already up-to-date. Version: %s" "$localSlackVersion"
        exit 0
    fi
fi

# OS X major release version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
finalDownloadUrl=$(curl "$DOWNLOAD_URL" -s -L -I -o /dev/null -w '%{url_effective}')

zipName=$(printf "%s" "${finalDownloadUrl[@]}" | sed 's@.*/@@')
slackZipPath="/Users/$loggedInUser/$zipName"
rm -rf "$slackZipPath" "$SLACK_APP_UNZIPPED_PATH"
/usr/bin/curl --retry 3 -L "$finalDownloadUrl" -o "$slackZipPath"
/usr/bin/unzip -o -q "$slackZipPath" -d "$SLACK_UNZIP_DIRECTORY"
rm -rf "$slackZipPath"

if pgrep 'Slack'; then
    printf "Error: Slack is currently running!\n"
    exit 409
else
    if [ -d "$APP_PATH" ]; then
        rm -rf "$APP_PATH"
    fi
    mv -f "$SLACK_APP_UNZIPPED_PATH" "$APP_PATH"
    # Slack permissions are stupid
    chown -R root:admin "$APP_PATH"
    localSlackVersion=$(defaults read "$APP_PATH/Contents/Info.plist" "$APP_VERSION_KEY")
    if [ "$currentSlackVersion" = "$localSlackVersion" ]; then
        printf "Slack is now updated/installed. Version: %s" "$localSlackVersion"
        exit 0
    fi
fi
