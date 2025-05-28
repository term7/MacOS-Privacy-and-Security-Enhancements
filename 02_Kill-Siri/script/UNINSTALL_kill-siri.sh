#!/usr/bin/env bash

#   UNINSTALL_kill_siri.sh
#   term7 / 27.03.2025
#
#   This script is meant to be educational and a resource for learning for unexperienced users. It has a lot of functionality that may be considered unnecessary from an advanced user's perspective. I.e. it pauses at certain times during the installation and displays a countdown. It echoes all commands to the terminal window and at certain times during the installation it displays informative texts and asks for user input. From an advanced user's perspective who knows exactly what he/she wants, this may be a waste of time - yet we have written this script with users in mind that are not yet used to the command line.
#
##   MIT License
#   Copyright (c) 2025 term7
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

function countdown {
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
echo "              ----------------------------------------------------";
echo "              ARE YOU SURE YOU WANT TO DELETE THE SIRI KILLSWITCH?";
echo "              ----------------------------------------------------";
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
the KillSwitch, or ${bold}[exit]${reset} to abort and press ${bold}[ENTER]${reset}: " DELETE

case $DELETE in

[dD][eE][lL][eE][tT][eT])

# -------Variables:--------

SIRI_LOCATION=/Users/Shared/Enhancements/kill_siri

LOCAL_DAEMON_FOLDER=/Library/LaunchAgents
LOCAL_DAEMON_NAME=info.term7.killall.siri.helper
LOCAL_DAEMON=$LOCAL_DAEMON_FOLDER/$LOCAL_DAEMON_NAME.plist

GLOBAL_DAEMON_FOLDER=/Library/LaunchDaemons
GLOBAL_DAEMON_NAME=info.term7.killall.siri
GLOBAL_DAEMON=$GLOBAL_DAEMON_FOLDER/$GLOBAL_DAEMON_NAME.plist


# -------Delete Trigger Location:--------

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
echo "------------------------------delete Siri Location------------------------------"
echo " "
echo "if [ -d \"${SIRI_LOCATION}\" ]; then sudo -u $(stat -f '%Su' /dev/console) rm -rf ${SIRI_LOCATION} fi"

if [ -d "$SIRI_LOCATION" ]; then
    sudo -u $(stat -f '%Su' /dev/console) rm -rf $SIRI_LOCATION
fi

sleep 1

# -------Delete Daemons:--------

echo " "
echo "--------------------------unload and delete KillSwitch--------------------------"
echo " "
echo "sudo -u \"$(stat -f '%Su' /dev/console)\" launchctl bootout \"gui/$(stat -f '%u' /dev/console)\" ${LOCAL_DAEMON}"
sudo -u "$(stat -f '%Su' /dev/console)" launchctl bootout "gui/$(stat -f '%u' /dev/console)" "$LOCAL_DAEMON"
sleep 1
echo "sudo rm ${LOCAL_DAEMON}"
sudo rm ${LOCAL_DAEMON}
sleep 1
echo "sudo launchctl bootout system ${GLOBAL_DAEMON}"
sudo launchctl bootout system "$GLOBAL_DAEMON"
sleep 1
echo "sudo rm ${GLOBAL_DAEMON}"
sudo rm ${GLOBAL_DAEMON}
sleep 1

# -------Unlock SiriVocabulary:--------

echo " "
echo "-----------------------------unlock SiriVocabulary------------------------------"
echo " "
echo "sudo -u $(stat -f '%Su' /dev/console) chflags nouchg /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary"
sudo -u $(stat -f '%Su' /dev/console) chflags nouchg /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sleep 1
echo "sudo -u $(stat -f '%Su' /dev/console) rm -rf /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary"
sudo -u $(stat -f '%Su' /dev/console) rm -rf /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sleep 1

break;;

# -------Input [C/c]: Abort:--------

[eE][xX][iI][tT])
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
