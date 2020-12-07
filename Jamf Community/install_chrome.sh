#!/bin/sh

# Get current stable build version number of Chrome from the web, do this in a single line to keep it encapsulated
chrome_latest_stable="$(curl https://omahaproxy.appspot.com/all | grep "mac,stable" | sed "s/,/ /g" | awk '{print $3}')"

# Get version number on currently installed Chrome app
installed_version="$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version   | grep -iE "[0-9.]{10,20}" | tr -d " <>-:;/,&\"=#[a-z][A-Z]")"

DOWNLOAD_URL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"

install_Chrome() {
  # Create a temporary directory in which to mount the .dmg
  tmp_mount=`/usr/bin/mktemp -d /tmp/chrome.XXXX`

  # Attach the install DMG directly from Google's servers (ensuring HTTPS)
  hdiutil attach "$( eval echo "${DOWNLOAD_URL}" )" -nobrowse -quiet -mountpoint "${tmp_mount}"

  rm -fR "/Applications/Google Chrome.app"

  ditto "${tmp_mount}/Google Chrome.app" "/Applications/Google Chrome.app"

  # Let things settle down
  sleep 1

  # Detach the dmg and remove the temporary mountpoint
  hdiutil detach "${tmp_mount}" && /bin/rm -rf "${tmp_mount}"

  if [ -e "/Applications/Google Chrome.app" ]; then
    echo "******Latest version of Chrome is installed on target Mac.******"
  fi
}

check_Running ()
{
# To find if the app is running, use:
ps -A | grep "Google Chrome.app" | grep -v "grep" > /tmp/RunningApps.txt

if grep -q "Google Chrome.app" /tmp/RunningApps.txt;
then
    echo "******Application is currently running on target Mac. Installation of Chrome cannot proceed.******"
    exit 1;
else
    echo "******Application is not running on target Mac. Proceeding...******"
    install_Chrome
    exit 0
fi
}

# If the version installed differs at all from the available version
# then we want to update
case "${installed_version}" in
  "${chrome_latest_stable}")
    echo "****** Chrome version checked OK (${latest_stable}) ******"
    ;;
  *) 
    echo "****** Chrome version differs - installed: ${installed_version}, available: ${latest_stable} ******"
    check_Running
    ;;
esac

exit 0;