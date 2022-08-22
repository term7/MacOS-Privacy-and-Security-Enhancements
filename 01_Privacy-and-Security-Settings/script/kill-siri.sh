#!/usr/bin/env bash

#   kill-siri.sh
#   term7 / 19.08.2022
#
#   This script is meant to be educational and a resource for learning for unexperienced users. It has a lot of functionality that may be considered unnecessary from an advanced user's perspective. I.e. it pauses at certain times during the installation and displays a countdown. It echoes all commands to the terminal window and at certain times during the installation it displays informative texts and asks for user input. From an advanced user's perspective who knows exactly what he/she wants, this may be a waste of time - yet we have written this script with users in mind that are not yet used to the command line.
#
##   MIT License
#   Copyright (c) 2022 term7
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# -------Styles:--------

lil=$(tput setaf 255,000,255)
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
echo "                            _/    _/  _/_/_/  _/        _/"
echo "                           _/  _/      _/    _/        _/"
echo "                          _/_/        _/    _/        _/"
echo "                         _/  _/      _/    _/        _/"
echo "                        _/    _/  _/_/_/  _/_/_/_/  _/_/_/_/"
echo " "
echo "                         _/_/_/  _/_/_/  _/_/_/    _/_/_/"
echo "                      _/          _/    _/    _/    _/"
echo "                       _/_/      _/    _/_/_/      _/"
echo "                          _/    _/    _/    _/    _/"
echo "                   _/_/_/    _/_/_/  _/    _/  _/_/_/ "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"

sudo -u $(stat -f '%Su' /dev/console) open /System/Applications/Utilities/Activity\ Monitor.app

# -------What this Script does:--------

echo " "
echo "                              ${bold}/ KILL SIRI & ASSISTANTD / WHAT THIS SCRIPT DOES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "MacOS does not allow you to disable Siri permanently unless you disable your"
echo "Mac's System Integrity Protection (SIP). While disabeling Siri may improve your"
echo "privacy, it is a significant security issue to disable SIP."
echo " "
echo "As a workaround you can implement your own System Services to kill any process"
echo "relating to Siri and assistantd. We have opened your ${bold}ACTIVITY MONITOR${reset} for you."
echo "Search ${bold}ASSISTANTD${reset} and ${bold}SIRI${reset} to see which processes are still running..."
echo " "
echo "This script is designed to install a ${bold}LaunchAgent${reset} and a ${bold}LaunchDaemon${reset} that work"
echo "together to kill Siri and assistantd as soon as they are respawned by MacOS"
echo "(even if you disabled Siri completely in your System Preferences)."
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                THIS SCRIPT HAS BEEN TESTED ON MACOS MONTEREY."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} to read more: "

echo " "
echo " "
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Siri and assistantd modify this location on your computer: ~/Library/Assistant/"
echo "We want to watch for changes in this folder, because that indicates that Siri or"
echo "assistantd is active. If we delete files in this folder, we force the respective"
echo "process to recreate them as soon as it is respawned by MacOS. These files are in"
echo "a folder of your local Library, which is why we need a LaunchAgent that runs"
echo "with ${bold}LOCAL USER PRIVILEGES${reset} to watch and modify its content."
echo " "
echo "Yet some Siri Processes run with root privileges. Our LaunchAgent won't be able"
echo "to terminate them since it only has user privileges. This is why we also need a"
echo "LaunchDaemon with ${bold}ROOT PERMISSIONS${reset} to terminate them."
echo "Even though our global LaunchDaemon is not allowed to watch and delete files in"
echo "local Libraries, it can monitor any shared folder. This is why as soon as it"
echo "detects activity, our local LaunchAgent creates a trigger in this shared"
echo "location: /Users/Shared/trigger. This tells our global LaunchDemon to terminate"
echo "all active processes related to Siri and assistantd."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To install both, ${bold}LAUNCH AGENT${reset} and ${bold}LAUNCH DAEMON${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[C/c]${reset} to cancel: " KILLSIRI

case $KILLSIRI in

# -------Input [Y/y]: Disable Apple Remote Events:--------

[Yy])

# -------Variables:--------

WATCH_LOCATION=~/Library/Assistant/
TRIGGER_LOCATION=/Users/Shared/trigger
TRIGGER=$TRIGGER_LOCATION/.trigger

LOCAL_DAEMON_FOLDER=/Library/LaunchAgents
LOCAL_DAEMON_NAME=info.term7.killall.siri.helper
LOCAL_DAEMON=$LOCAL_DAEMON_FOLDER/$LOCAL_DAEMON_NAME.plist

GLOBAL_DAEMON_FOLDER=/Library/LaunchDaemons
GLOBAL_DAEMON_NAME=info.term7.killall.siri
GLOBAL_DAEMON=$GLOBAL_DAEMON_FOLDER/$GLOBAL_DAEMON_NAME.plist

TRIGGER_COMMAND="touch $TRIGGER; rm $TRIGGER; rm -f -- ~/Library/Assistant/SiriAnalytics.db; rm -f -- ~/Library/Assistant/SiriAnalytics.db-shm; rm -f -- ~/Library/Assistant/SiriAnalytics.db-wal; rm -f -- ~/Library/Assistant/assistantdDidLaunch; rm -f -- ~/Library/Assistant/session_did_finish_timestamp; if [ -d ~/Library/Assistant/SiriVocabulary ]; then rm -rf ~/Library/Assistant/SiriVocabulary; fi; if [ -d ~/Library/Assistant/CustomVocabulary ]; then rm -rf ~/Library/Assistant/CustomVocabulary; fi"
KILLALL_COMMAND="if pgrep siriinferenced; then kill -9 \$(pgrep siriinferenced); fi; if pgrep siriactionsd; then kill -9 \$(pgrep siriactionsd); fi; if pgrep siriknowledged; then kill -9 \$(pgrep siriknowledged); fi; if pgrep assistantd; then kill -9 \$(pgrep assistantd); fi; if pgrep com.apple.siri.embeddedspeech; then kill -9 \$(pgrep com.apple.siri.embeddedspeech); fi"


# -------Trigger Location:--------

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
echo "----------------------------setup trigger location----------------------------"
echo " "
echo "open /Users/Shared"

open /Users/Shared
sleep 3

echo " "
echo "if [ ! -d \"${TRIGGER_LOCATION}\" ]; then mkdir ${TRIGGER_LOCATION} fi"

if [ ! -d "$TRIGGER_LOCATION" ]; then
    mkdir $TRIGGER_LOCATION
fi

sleep 1
echo "sudo chown $(stat -f '%Su' /dev/console):wheel ${TRIGGER_LOCATION}"

sudo chown $(stat -f '%Su' /dev/console):wheel "$TRIGGER_LOCATION"

sleep 1
echo "sudo chmod +X ${TRIGGER_LOCATION}"

sudo chmod +X "$TRIGGER_LOCATION"

# -------Local Helper Daemon:--------

echo " "
echo " "
echo "------------------------------create LaunchAgent------------------------------"
echo " "
echo "${LOCAL_DAEMON}"
sleep 1

sudo tee "$LOCAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LOCAL_DAEMON_NAME}</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/sh</string>
		<string>-c</string>
		<string>${TRIGGER_COMMAND}</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>~/Library/Assistant</string>
	</array>
</dict>
</plist>
EOF

# -------Global Unload Daemon:--------

echo " "
echo " "
echo "-----------------------------create LaunchDaemon------------------------------"
echo " "
echo "${GLOBAL_DAEMON}"
sleep 1

sudo tee "$GLOBAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLOBAL_DAEMON_NAME}</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/sh</string>
		<string>-c</string>
		<string>${KILLALL_COMMAND}</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>${TRIGGER_LOCATION}</string>
	</array>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

echo " "
echo " "
echo "------------------------setup ownership & permissions-------------------------"
echo " "
echo "sudo chown root:wheel ${LOCAL_DAEMON}"
sleep 1

sudo chown root:wheel "$LOCAL_DAEMON"

echo "sudo chmod 644 ${LOCAL_DAEMON}"
sleep 1

sudo chmod 644 "$LOCAL_DAEMON"

echo "sudo chown root:wheel ${GLOBAL_DAEMON}"
sleep 1

sudo chown root:wheel "$GLOBAL_DAEMON"

echo "sudo chmod 644 ${GLOBAL_DAEMON}"
sleep 1

sudo chmod 644 "$GLOBAL_DAEMON"

# -------Open Watch Folder:--------

echo " "
echo " "
echo "------------------------------open watch folder-------------------------------"
echo " "

sudo -u $(stat -f '%Su' /dev/console) open /Users/$(stat -f '%Su' /dev/console)/Library/Assistant

echo "sudo -u $(stat -f '%Su' /dev/console) open /Users/$(stat -f '%Su' /dev/console)/Library/Assistant"
sleep 3

# -------Load Daemons:--------

echo " "
echo " "
echo "---------------------------------load daemons---------------------------------"
echo " "

echo "sudo -u $(stat -f '%Su' /dev/console) launchctl load ${LOCAL_DAEMON}"
sleep 1

sudo -u $(stat -f '%Su' /dev/console) launchctl load "$LOCAL_DAEMON"

echo "sudo launchctl load ${GLOBAL_DAEMON}"
sleep 1

sudo launchctl load "$GLOBAL_DAEMON"

# -------Trigger Daemons:--------

echo " "
echo " "
echo "-----------------------------trigger daemons once-----------------------------"
echo " "

echo "sudo -u $(stat -f '%Su' /dev/console) touch /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp"
echo "sudo -u $(stat -f '%Su' /dev/console) touch /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp"

sudo -u $(stat -f '%Su' /dev/console) touch /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp
sudo -u $(stat -f '%Su' /dev/console) rm /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp

sleep 3

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
countdown "00:00:3"

break;;

# -------Input [C/c]: Abort:--------

[Cc])
abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done


echo " "
echo "-----------------------open LaunchAgent in Text Editor------------------------"
echo " "
echo "open -a TextEdit ${LOCAL_DAEMON}"
open -a TextEdit "$LOCAL_DAEMON"
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
countdown "00:00:5"

echo " "
echo "-----------------------open LaunchDaemon in Text Editor-----------------------"
echo " "
echo "open -a TextEdit ${GLOBAL_DAEMON}"
open -a TextEdit "$GLOBAL_DAEMON"
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
countdown "00:00:5"

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "From on on, all processes relating to Siri and assistantd will be killed as soon"
echo "as they are respawned by MacOS."
echo " "
echo "Please have a look at the two open Text documents:"
echo "These are the ${bold}LaunchAgent${reset} and the ${bold}LaunchDaemon${reset} that were set up by this script."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "                     _/_/_/  _/_/_/_/  _/_/_/_/_/  _/    _/  _/_/_/"
echo "                  _/        _/            _/      _/    _/  _/    _/"
echo "                   _/_/    _/_/_/        _/      _/    _/  _/_/_/"
echo "                      _/  _/            _/      _/    _/  _/"
echo "               _/_/_/    _/_/_/_/      _/        _/_/    _/"
echo " "
echo "                  _/_/_/      _/_/    _/      _/  _/_/_/_/"
echo "                 _/    _/  _/    _/  _/_/    _/  _/"
echo "                _/    _/  _/    _/  _/  _/  _/  _/_/_/"
echo "               _/    _/  _/    _/  _/    _/_/  _/"
echo "              _/_/_/      _/_/    _/      _/  _/_/_/_/"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -n 1 -p  "Press ${bold}[ANY KEY]${reset} to exit this script: "
