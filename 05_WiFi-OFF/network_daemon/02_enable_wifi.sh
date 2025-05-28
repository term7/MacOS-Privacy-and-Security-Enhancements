#!/bin/bash

LOGFILE="/Users/Shared/Enhancements/disable_wifi/disable_wifi.log"

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

log "===== Daemon Script 2) started ====="

log "Boot stage: $(/bin/launchctl print system | grep -m 1 state | awk '{print $NF}')"
log "System uptime: $(uptime)"

log "Waiting for user login..."

WAITED=0

while ! /usr/bin/stat -f%Su /dev/console | grep -vq '^root$'; do
  log "No user logged in yet... waiting ($WAITED seconds elapsed)"
  sleep 1
  WAITED=$((WAITED + 1))
done

log "Detected user login after $WAITED seconds. Proceeding..."

log "Detected user login. Proceeding..."

log "DISCONNECT WIFI:"

# Turn off the Wi-Fi radio interface (en0)
for i in {1..10}; do
  run_and_log "/usr/sbin/networksetup -setairportpower en0 off"
  if [ $? -eq 0 ]; then
    break
  fi
  log "Retrying setairportpower in 2 seconds..."
  sleep 2
done

log "ENABLE OFFLINE WIFI:"

# Pause to let Wi-Fi disconnect cleanly
log "Waiting 3 seconds before re-enabling the Wi-Fi network service..."
sleep 3

# Re-enable the Wi-Fi network service (so it's visible but disconnected)
run_and_log "/usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi on"

log "===== Daemon Script 2) completed ====="
