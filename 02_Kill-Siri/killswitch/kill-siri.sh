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