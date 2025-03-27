#!/bin/bash

LOGFILE="/Users/Shared/Enhancements/kill_siri/kill_siri.log"
chmod 666 "$LOGFILE"

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

echo "$(date): !!!!! KILL SIRI !!!!!" > "$LOGFILE"

# Kill matching processes and log each kill
for proc in "${PROCS[@]}"; do
  if /usr/bin/pgrep "$proc" >/dev/null; then
    /usr/bin/pkill -9 "$proc"
    echo "$(/bin/date): Killed $proc" >> "$LOGFILE"
  fi
done
