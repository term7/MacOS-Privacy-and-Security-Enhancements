#!/usr/bin/env bash

#   kill-siri.sh
#   term7 / 27.03.2025
#
#   This script is meant to be educational and a resource for learning for unexperienced users. It has a lot of functionality that may be considered unnecessary from an advanced user's perspective. I.e. it pauses at certain times during the installation and displays a countdown. It echoes all commands to the terminal window and at certain times during the installation it displays informative texts and asks for user input. From an advanced user's perspective who knows exactly what he/she wants, this may be a waste of time. After all it is always possible to read the script - yet we have written this script with users in mind that are not yet used to the command line. After completing this script it is possible to scroll up and read the output of the whole script, including the commands that would otherwise be invisible in the Terminal window.
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

# -------Intro:--------

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
echo "        THIS SCRIPT HAS BEEN TESTED ON MACOS MONTEREY AND MACOS VENTURA."${reset}
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
ENHANCEMENTS=/Users/Shared/Enhancements/kill_siri
TRIGGER_LOCATION=$ENHANCEMENTS/trigger
TRIGGER=$TRIGGER_LOCATION/.trigger

KILLSIRI_SCRIPT=$ENHANCEMENTS/kill_siri.sh
KILLSIRI_HELPER=$ENHANCEMENTS/kill_siri-helper.sh

LOCAL_DAEMON_FOLDER=/Library/LaunchAgents
LOCAL_DAEMON_NAME=info.term7.killall.siri.helper
LOCAL_DAEMON=$LOCAL_DAEMON_FOLDER/$LOCAL_DAEMON_NAME.plist

GLOBAL_DAEMON_FOLDER=/Library/LaunchDaemons
GLOBAL_DAEMON_NAME=info.term7.killall.siri
GLOBAL_DAEMON=$GLOBAL_DAEMON_FOLDER/$GLOBAL_DAEMON_NAME.plist

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
echo "-----------------------------setup trigger location-----------------------------"
echo " "
echo "if [ ! -d \"${ENHANCEMENTS}\" ]; then sudo -u $(stat -f '%Su' /dev/console) mkdir ${ENHANCEMENTS} fi"

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi
sleep 1

echo "sudo -u $(stat -f '%Su' /dev/console) open ${ENHANCEMENTS}"
sudo -u $(stat -f '%Su' /dev/console) open "$ENHANCEMENTS"
sleep 1

echo " "
echo "if [ ! -d \"${TRIGGER_LOCATION}\" ]; then sudo -u $(stat -f '%Su' /dev/console) mkdir ${TRIGGER_LOCATION} fi"

if [ ! -d "$TRIGGER_LOCATION" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$TRIGGER_LOCATION"
fi

sleep 1
echo "sudo chown $(stat -f '%Su' /dev/console):wheel ${ENHANCEMENTS}"
sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"

sleep 1
echo "sudo chown $(stat -f '%Su' /dev/console):staff ${TRIGGER_LOCATION}"
sudo chown $(stat -f '%Su' /dev/console):staff "$TRIGGER_LOCATION"

sleep 1
echo "sudo chmod 775 ${TRIGGER_LOCATION}"

sudo chmod 775 "$TRIGGER_LOCATION"

# -------Create Kill Script:--------

echo " "
echo " "
echo -------------------------------"create Kill Script-------------------------------"
echo " "
echo "${KILLSIRI_SCRIPT}"
sleep 1

sudo tee /Users/Shared/Enhancements/kill_siri/kill_siri.sh > /dev/null << 'EOF'
#!/bin/bash

LOGFILE="/Users/Shared/Enhancements/kill_siri/kill_siri.log"
mkdir -p "$(dirname "$LOGFILE")"
touch "$LOGFILE"
chmod 666 "$LOGFILE"

log() {
  echo "$(date): $1" >> "$LOGFILE"
}

run_and_log() {
  CMD="$1"
  log "Running: $CMD"
  OUTPUT=$(eval "$CMD" 2>&1)
  EXITCODE=$?
  log "Exit code: $EXITCODE"
  if [ -n "$OUTPUT" ]; then
    log "Output: $OUTPUT"
  fi
  return $EXITCODE
}

echo "$(date): ===== KILL SIRI =====" > "$LOGFILE"

# List of Siri-related processes to kill
PROCS=(
  SiriAUSP
  siriinferenced
  siriactionsd
  siriknowledged
  sirittsd
  SiriTTSSynthesizerAU
  assistantd
  com.apple.siri.embeddedspeech
  com.apple.SiriTTSService.TrialProxy
  com.apple.siri-distributed-evaluation
)

# Kill matching processes and log each kill
for proc in "${PROCS[@]}"; do
  if /usr/bin/pgrep "$proc" >/dev/null; then
    run_and_log "/usr/bin/pkill -9 $proc"
    log "Killed $proc"
  fi
done
EOF

# -------Create Helper Script:--------

echo " "
echo " "
echo ------------------------------"create Helper Script------------------------------"
echo " "
echo "${KILLSIRI_HELPER}"
sleep 1

sudo tee /Users/Shared/Enhancements/kill_siri/kill_siri-helper.sh > /dev/null << 'EOF'
#!/bin/bash

export USER=$(stat -f '%Su' /dev/console)
export HOME="/Users/$USER"

LOGFILE="/Users/Shared/Enhancements/kill_siri/kill_siri.log"
mkdir -p "$(dirname "$LOGFILE")"

log() {
  echo "$(date): $1" >> "$LOGFILE"
}

run_and_log() {
  CMD="$1"
  log "Running: $CMD"
  OUTPUT=$(eval "$CMD" 2>&1)
  EXITCODE=$?
  log "Exit code: $EXITCODE"
  if [ -n "$OUTPUT" ]; then
    log "Output: $OUTPUT"
  fi
  return $EXITCODE
}

log "===== CLEANUP ====="

# Trigger the LaunchDaemon by touching then removing the trigger file
touch /Users/Shared/Enhancements/kill_siri/trigger/.trigger
rm /Users/Shared/Enhancements/kill_siri/trigger/.trigger 2>/dev/null

# Files and folders to delete
FILES=(
  "$HOME/Library/Assistant/SiriAnalytics.db"
  "$HOME/Library/Assistant/SiriAnalytics.db-shm"
  "$HOME/Library/Assistant/SiriAnalytics.db-wal"
  "$HOME/Library/Assistant/session_did_finish_timestamp"
  "$HOME/Library/Assistant/assistantdDidLaunch"
  "$HOME/Library/Assistant/.DS_Store"
)

FOLDERS=(
# "$HOME/Library/Assistant/SiriVocabulary" -> PROTECTED BY SIP
#  LAUNCHAGENT CANNOT DELETE THIS FOLDER // we implemented a workaround in installation the scripts!
  "$HOME/Library/Assistant/CustomVocabulary"
  "$HOME/Library/Assistant/SiriReferenceResolution"
)

# Remove files and log deletions or errors
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    if run_and_log "rm -f -- '$file'"; then
      log "Deleted file: $file"
    else
      log "Error deleting file: $file"
    fi
  fi
done

# Remove folders and log deletions or errors
for folder in "${FOLDERS[@]}"; do
  if [ -d "$folder" ]; then
    if run_and_log "rm -rf -- '$folder'"; then
      log "Deleted folder: $folder"
    else
      log "Error deleting folder: $folder"
    fi
  fi
done

log "===== CLEANUP COMPLETE ====="
EOF

# -------Make Scripts Executable:--------

echo " "
echo " "
echo "----------------------------make scripts executable-----------------------------"
echo " "
sudo chmod +x "$KILLSIRI_SCRIPT"
echo "sudo chmod +x ${KILLSIRI_SCRIPT}"
sleep 1

sudo chmod +x "$KILLSIRI_HELPER"
echo "sudo chmod +x ${KILLSIRI_HELPER}"
sleep 1

# -------Local Helper Daemon:--------

echo " "
echo " "
echo "-------------------------------create LaunchAgent-------------------------------"
echo " "
echo "${LOCAL_DAEMON}"
sleep 1

sudo tee "$LOCAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LOCAL_DAEMON_NAME</string>

    <key>ProgramArguments</key>
    <array>
        <string>${KILLSIRI_HELPER}</string>
    </array>

    <key>WatchPaths</key>
    <array>
        <string>~/Library/Assistant/</string>
    </array>
</dict>
</plist>
EOF


# -------Global Unload Daemon:--------

echo " "
echo " "
echo "------------------------------create LaunchDaemon-------------------------------"
echo " "
echo "${GLOBAL_DAEMON}"
sleep 1

sudo tee "$GLOBAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$GLOBAL_DAEMON_NAME</string>

    <key>ProgramArguments</key>
    <array>
        <string>${KILLSIRI_SCRIPT}</string>
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
echo "-------------------------setup ownership & permissions--------------------------"
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
echo "-------------------------------open watch folder--------------------------------"
echo " "

sudo -u $(stat -f '%Su' /dev/console) open /Users/$(stat -f '%Su' /dev/console)/Library/Assistant

echo "sudo -u $(stat -f '%Su' /dev/console) open /Users/$(stat -f '%Su' /dev/console)/Library/Assistant"
sleep 3

# -------Load Daemons:--------

echo " "
echo " "
echo "----------------------------------load daemons----------------------------------"
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
echo "------------------------------trigger daemons once------------------------------"
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

# -------Delete SiriVocabulary Manually, recreate it and protect it, so that Siri cannot modify it anymore--------

echo " "
echo " "
echo "-----------------------------delete SiriVocabulary------------------------------"
echo " "

echo "sudo -u $(stat -f '%Su' /dev/console) rm -rf /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary"
sudo -u $(stat -f '%Su' /dev/console) rm -rf /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sleep 1

echo " "
echo " "
echo "--------------------------create empty SiriVocabulary---------------------------"
echo " "

echo "sudo -u $(stat -f '%Su' /dev/console) mkdir /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary"
sudo -u $(stat -f '%Su' /dev/console) mkdir /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sleep 1

echo " "
echo " "
echo "------------------------------lock SiriVocabulary-------------------------------"
echo " "

echo "sudo -u $(stat -f '%Su' /dev/console) chflags uchg /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary"
sudo -u $(stat -f '%Su' /dev/console) chflags uchg /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary

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
echo "------------------------open LaunchAgent in Text Editor-------------------------"
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
echo "------------------------open LaunchDaemon in Text Editor------------------------"
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
echo "------------------------open Kill Script in Text Editor-------------------------"
echo " "
echo "open -a TextEdit ${KILLSIRI_SCRIPT}"
open -a TextEdit "$KILLSIRI_SCRIPT"
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
echo "-----------------------open Helper Script in Text Editor------------------------"
echo " "
echo "open -a TextEdit ${KILLSIRI_HELPER}"
open -a TextEdit "$KILLSIRI_HELPER"
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
