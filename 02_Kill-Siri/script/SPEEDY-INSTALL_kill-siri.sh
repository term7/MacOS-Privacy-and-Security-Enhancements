#!/usr/bin/env bash

#   SPEEDY-INSTALL_kill-siri.sh
#   term7 / 27.03.2025
##
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

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi

if [ ! -d "$TRIGGER_LOCATION" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$TRIGGER_LOCATION"
fi

sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"
sudo chown $(stat -f '%Su' /dev/console):staff "$TRIGGER_LOCATION"

sudo chmod 775 "$TRIGGER_LOCATION"

# -------Create Kill Script:--------

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

sudo chmod +x "$KILLSIRI_SCRIPT"
sudo chmod +x "$KILLSIRI_HELPER"

# -------Local Helper Daemon:--------

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

sudo chown root:wheel "$LOCAL_DAEMON"
sudo chmod 644 "$LOCAL_DAEMON"
sudo chown root:wheel "$GLOBAL_DAEMON"
sudo chmod 644 "$GLOBAL_DAEMON"

# -------Load Daemons:--------

sudo -u "$(stat -f '%Su' /dev/console)" launchctl bootstrap "gui/$(stat -f '%u' /dev/console)" "$LOCAL_DAEMON"
sudo launchctl bootstrap system "$GLOBAL_DAEMON"

# -------Trigger Daemons:--------

sudo -u $(stat -f '%Su' /dev/console) touch /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp
sudo -u $(stat -f '%Su' /dev/console) rm /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp

# -------Delete SiriVocabulary Manually, recreate it and protect it, so that Siri cannot modify it anymore--------

sudo -u $(stat -f '%Su' /dev/console) rm -rf /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sudo -u $(stat -f '%Su' /dev/console) mkdir /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary
sudo -u $(stat -f '%Su' /dev/console) chflags uchg /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/SiriVocabulary

echo " "
echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s
