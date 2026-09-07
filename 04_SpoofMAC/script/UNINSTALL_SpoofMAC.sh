#!/usr/bin/env bash

#   UNINSTALL_SpoofMAC.sh
#
#   term7 / 10.03.2024
#
#   MODIFIED 15.08.2026 by OpenHat Security (https://github.com/openhat-security):
#   SpoofMAC no longer installs the npm package "spoof". This script removes the
#   LaunchDaemon and helper script created by the current installer, while retaining
#   conditional cleanup of the npm package left by an older SpoofMAC installation.
#
#   MODIFIED 07.09.2026 by term7:
#   Updated the uninstall status messages for the current SpoofMAC implementation
#   and added defensive checks when removing installed files.
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
echo "                   ARE YOU SURE YOU WANT TO DELETE SpoofMAC?";
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

while true
do
read -s -p "Type ${bold}[delete]${reset} to unload and remove all Daemons and files that constitute
the SpoofMAC, or ${bold}[exit]${reset} to abort and press ${bold}[ENTER]${reset}: " DELETE

case $DELETE in

[d][e][l][e][t][e])

# -------Variables:--------

ENHANCEMENTS=/Users/Shared/Enhancements/spoof_mac

DAEMON_FOLDER=/Library/LaunchDaemons
SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist

# -------Delete Daemon:--------

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
echo "-----------------------unload and delete SpoofMAC Daemon------------------------"
echo " "

if [ -e "$SpoofMAC_DAEMON" ]; then

    echo "sudo launchctl bootout system ${SpoofMAC_DAEMON}"
    sudo launchctl bootout system "$SpoofMAC_DAEMON"
    sleep 1

    echo "sudo rm ${SpoofMAC_DAEMON}"
    sudo rm "$SpoofMAC_DAEMON"
    sleep 1

else

    echo "SpoofMAC LaunchDaemon not found – skipping daemon removal."

fi

# -------Delete Script:--------

echo " "
echo "-----------------------------delete SpoofMAC Script-----------------------------"
echo " "
echo "sudo rm -r ${ENHANCEMENTS}"
if [ -d "$ENHANCEMENTS" ]; then
    sudo rm -r "$ENHANCEMENTS"
fi
sleep 1

# -------Delete legacy npm installation (if it exists):--------

# Older versions of SpoofMAC installed the npm package "spoof" through MacPorts.
# The current version does not, but we still clean up after an older installation.

if [ -x /opt/local/bin/spoof ]; then

    echo " "
    echo "--------------------------delete legacy npm SpoofMAC----------------------------"
    echo " "
    echo "sudo npm uninstall spoof -g"
    sudo npm uninstall spoof -g
    sleep 1

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
echo "SpoofMAC has been removed."
echo "The current Wi-Fi power state and MAC address are left unchanged by this"
echo "uninstaller. After the next reboot, SpoofMAC will no longer randomize your Wi-Fi"
echo "MAC address."
echo " "
countdown "00:00:3"

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