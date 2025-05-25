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
#  LAUNCHAGENT CANNOT DELETE THIS FOLDER // we implemented a workaround in the installation scripts!
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