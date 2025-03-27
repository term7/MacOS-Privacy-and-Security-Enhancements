#!/bin/bash

export USER=$(stat -f '%Su' /dev/console)
export HOME="/Users/$USER"

LOGFILE="/Users/Shared/Enhancements/kill_siri/kill_siri.log"

# Touch the trigger for the LaunchDaemon
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
  "$HOME/Library/Assistant/SiriVocabulary"
  "$HOME/Library/Assistant/CustomVocabulary"
  "$HOME/Library/Assistant/SiriReferenceResolution"
)

echo "$(date): Starting Siri cleanup" >> "$LOGFILE"

# Remove files and log deletions or errors
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    error_output=$(rm -f -- "$file" 2>&1)
    if [ $? -eq 0 ]; then
      echo "$(date): Deleted file: $file" >> "$LOGFILE"
    else
      echo "$(date): Error deleting file: $file. Error: $error_output" >> "$LOGFILE"
    fi
  fi
done

# Remove folders and log deletions or errors
for folder in "${FOLDERS[@]}"; do
  if [ -d "$folder" ]; then
    error_output=$(rm -rf -- "$folder" 2>&1)
    if [ $? -eq 0 ]; then
      echo "$(date): Deleted folder: $folder" >> "$LOGFILE"
    else
      echo "$(date): Error deleting folder: $folder. Error: $error_output" >> "$LOGFILE"
    fi
  fi
done

echo "$(date): Cleanup complete" >> "$LOGFILE"
