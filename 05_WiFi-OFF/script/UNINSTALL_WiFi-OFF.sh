#!/usr/bin/env bash

#   UNINSTALL_Wifi-OFF.sh
#
#   term7 / 27.05.2025

#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

while true
do
read -s -p "Type ${bold}[delete]${reset} to unload and remove all Daemons and files that constitute 
the WiFi-OFF, or ${bold}[exit]${reset} to abort and press ${bold}[ENTER]${reset}: " DELETE

case $DELETE in

[d][e][l][e][t][e])

# -------Variables:--------

DAEMON_FOLDER=/Library/LaunchDaemons
DISABLE_DAEMON_NAME=info.term7.off.networksetup.daemon
ENABLE_DAEMON_NAME=info.term7.on.networksetup.daemon
DISABLE_DAEMON=$DAEMON_FOLDER/$DISABLE_DAEMON_NAME.plist
ENABLE_DAEMON=$DAEMON_FOLDER/$ENABLE_DAEMON_NAME.plist
ENHANCEMENTS=/Users/Shared/Enhancements/disable_wifi

# -------Delete Script Location:--------

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
echo "----------------------------delete WiFi_OFF Location----------------------------"
echo " "
echo "if [ -d \"${ENHANCEMENTS}\" ]; then sudo rm -rf ${ENHANCEMENTS} fi"

if [ -d "$ENHANCEMENTS" ]; then
    sudo rm -rf $ENHANCEMENTS
fi

sleep 1

# -------Delete Daemons:--------

echo " "
echo "-----------------------unload and delete Wifi-OFF Daemons-----------------------"
echo " "
echo "sudo launchctl bootout system ${DISABLE_DAEMON}"
sudo launchctl bootout system  "$DISABLE_DAEMON"
sleep 1
echo "sudo rm ${DISABLE_DAEMON}"
sudo rm ${DISABLE_DAEMON}
sleep 1
echo " "
echo "sudo launchctl bootout system ${ENABLE_DAEMON}"
sudo launchctl bootout system "$ENABLE_DAEMON"
sleep 1
echo "sudo rm ${ENABLE_DAEMON}"
sudo rm ${ENABLE_DAEMON}
sleep 1

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
read -s -n 1 -p "Press ${bold}[ANY KEY]${reset} to exit this script: "