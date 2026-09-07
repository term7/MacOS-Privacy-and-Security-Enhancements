#!/usr/bin/env bash

#   UNINSTALL_Wifi-OFF.sh
#
#   term7 / 27.05.2025 - last modification: 07.09.2026

#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# -------Admin Check:--------

if ! sudo -v; then
    echo "Administrator privileges are required."
    exit 1
fi

# -------Styles:--------

bold=$(tput bold)
reset=$(tput sgr0)

# -------Countdown Function:--------

function countdown
{
local OLD_IFS="${IFS}"
IFS=":"
local ARR=( $1 )
local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
local START=$(date +%s)
local END=$((START + SECONDS))
local CUR=$START

while [[ $CUR -lt $END ]]
do
CUR=$(date +%s)
LEFT=$((END-CUR))

printf "\r%02d:%02d:%02d" \
$((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

sleep 1
done
IFS="${OLD_IFS}"
echo "        "
}

# -------Abort Function:--------

function abort {
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo "                                ---------------";
  echo "                                A B O R T I N G";
  echo "                                ---------------";
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
countdown "00:00:3"
}

# -------Wrong Input Function:--------

function invalid {
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo "                        --------------------------------";
  echo "                        INVALID INPUT - PLEASE TRY AGAIN";
  echo "                        --------------------------------";
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
}

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "                   -----------------------------------------";
echo "                   ARE YOU SURE YOU WANT TO DELETE WiFi_OFF?";
echo "                   -----------------------------------------";
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "

while true
do
read -s -p "Type ${bold}[delete]${reset} to remove WiFi-OFF, or ${bold}[exit]${reset} to abort and press ${bold}[ENTER]${reset}: " DELETE

case $DELETE in

[d][e][l][e][t][e])

# -------Variables:--------

DAEMON_FOLDER=/Library/LaunchDaemons
DISABLE_DAEMON_NAME=info.term7.off.networksetup.daemon
ENABLE_DAEMON_NAME=info.term7.on.networksetup.daemon
DISABLE_DAEMON=$DAEMON_FOLDER/$DISABLE_DAEMON_NAME.plist
ENABLE_DAEMON=$DAEMON_FOLDER/$ENABLE_DAEMON_NAME.plist
ENHANCEMENTS=/Users/Shared/Enhancements/disable_wifi

SPOOFMAC=/Users/Shared/Enhancements/spoof_mac/spoof_mac.sh
WIFIOFF_MARKER="# -------WiFi-OFF Integration:--------"

INTEGRATION_REMOVED=0
STANDALONE_REMOVED=0

# -------Remove Wifi-OFF Integration from SpoofMAC:--------

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "----------------------remove Wifi-OFF from SpoofMAC----------------------------"
echo " "

if [ -f "$SPOOFMAC" ] && /usr/bin/grep -Fq "$WIFIOFF_MARKER" "$SPOOFMAC"; then

    TMPFILE=$(/usr/bin/mktemp /tmp/Wifi-OFF-uninstall.XXXXXX)

    if [ -z "$TMPFILE" ]; then
        echo "Could not create temporary file."
        exit 1
    fi

    trap 'rm -f "$TMPFILE"' EXIT

    if ! /usr/bin/awk -v marker="$WIFIOFF_MARKER" '
        $0 == marker {
            in_wifi_off = 1
            found_marker = 1
            next
        }

        in_wifi_off {
            if ($0 == "fi") {
                in_wifi_off = 0
                found_end = 1
                next
            }
            next
        }

        {
            print
        }

        END {
            if (found_marker && !found_end)
                exit 2
        }
    ' "$SPOOFMAC" > "$TMPFILE"; then
        echo "Could not safely remove the Wifi-OFF integration block."
        echo "The installed SpoofMAC helper script has NOT been changed."
        exit 1
    fi

    echo "/bin/bash -n ${TMPFILE}"

    if ! /bin/bash -n "$TMPFILE"; then
        echo "The restored SpoofMAC helper script failed the Bash syntax check."
        echo "The installed SpoofMAC helper script has NOT been changed."
        exit 1
    fi

    echo "sudo /usr/bin/install -o root -g wheel -m 755 ${TMPFILE} ${SPOOFMAC}"

    if ! sudo /usr/bin/install -o root -g wheel -m 755 "$TMPFILE" "$SPOOFMAC"; then
        echo "Could not install the restored SpoofMAC helper script."
        exit 1
    fi

    if /usr/bin/grep -Fq "$WIFIOFF_MARKER" "$SPOOFMAC"; then
        echo "Wifi-OFF integration could not be removed from SpoofMAC."
        exit 1
    fi

    echo "Wifi-OFF integration removed from the SpoofMAC helper script."
    echo "The SpoofMAC LaunchDaemon remains installed and unchanged."
    INTEGRATION_REMOVED=1

else

    echo "No Wifi-OFF integration found in the SpoofMAC helper script – skipping."

fi

sleep 1

# -------Delete Standalone Script Location:--------

echo " "
echo "------------------------delete standalone WiFi_OFF files-----------------------"
echo " "

if [ -d "$ENHANCEMENTS" ]; then
    echo "sudo rm -rf ${ENHANCEMENTS}"
    sudo rm -rf "$ENHANCEMENTS"
    STANDALONE_REMOVED=1
else
    echo "Standalone Wifi-OFF helper directory not found – skipping."
fi

sleep 1

# -------Delete Standalone Daemons:--------

echo " "
echo "-----------------------unload and delete Wifi-OFF Daemons-----------------------"
echo " "

if sudo launchctl print "system/${DISABLE_DAEMON_NAME}" > /dev/null 2>&1; then
    echo "sudo launchctl bootout system/${DISABLE_DAEMON_NAME}"
    sudo launchctl bootout "system/${DISABLE_DAEMON_NAME}"
    sleep 1
    STANDALONE_REMOVED=1
fi

if [ -e "$DISABLE_DAEMON" ]; then
    echo "sudo rm ${DISABLE_DAEMON}"
    sudo rm "$DISABLE_DAEMON"
    sleep 1
    STANDALONE_REMOVED=1
fi

if sudo launchctl print "system/${ENABLE_DAEMON_NAME}" > /dev/null 2>&1; then
    echo "sudo launchctl bootout system/${ENABLE_DAEMON_NAME}"
    sudo launchctl bootout "system/${ENABLE_DAEMON_NAME}"
    sleep 1
    STANDALONE_REMOVED=1
fi

if [ -e "$ENABLE_DAEMON" ]; then
    echo "sudo rm ${ENABLE_DAEMON}"
    sudo rm "$ENABLE_DAEMON"
    sleep 1
    STANDALONE_REMOVED=1
fi

if [ "$STANDALONE_REMOVED" -eq 0 ]; then
    echo "No standalone Wifi-OFF helper scripts or LaunchDaemons found – skipping."
fi

break;;

# -------Input [C/c]: Abort:--------

[e][x][i][t])
abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

echo " "
echo "------------------------------------SUMMARY-------------------------------------"
echo " "

if [ "$INTEGRATION_REMOVED" -eq 1 ]; then
    echo "Wifi-OFF was removed from the existing SpoofMAC helper script."
    echo "SpoofMAC itself remains installed and will continue to randomize the Wi-Fi"
    echo "MAC address."
    echo " "
    countdown "00:00:3"
    echo " "
fi

if [ "$STANDALONE_REMOVED" -eq 1 ]; then
    echo "Standalone Wifi-OFF helper scripts and LaunchDaemons were removed."
    echo " "
    countdown "00:00:3"
    echo " "
fi

if [ "$INTEGRATION_REMOVED" -eq 0 ] && [ "$STANDALONE_REMOVED" -eq 0 ]; then
    echo "No installed Wifi-OFF components were found."
    echo " "
    countdown "00:00:3"
    echo " "
fi

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "                                ---------------";
echo "                                F I N I S H E D";
echo "                                ---------------";
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "

echo " "
read -s -n 1 -p "Press ${bold}[ANY KEY]${reset} to exit this script: "