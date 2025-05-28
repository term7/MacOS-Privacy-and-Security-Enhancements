#!/bin/bash

LOGFILE="/Users/Shared/Enhancements/disable_wifi/disable_wifi.log"
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

echo "$(date): Boot stage: $(/bin/launchctl print system | grep -m 1 state | awk '{print $NF}')" > "$LOGFILE"
log "System uptime: $(uptime)"

log "===== Daemon Script 1) started ====="

# Spoof Wi-Fi MAC Address if SpoofMAC exists
if [ -x /opt/local/bin/spoof ]; then
    log "SPOOF MAC-ADDRESS:"
    run_and_log "/opt/local/bin/node /opt/local/bin/spoof randomize en0"

    log "CURRENT SPOOF STATUS:"
    SPOOF_OUTPUT=$(/opt/local/bin/node /opt/local/bin/spoof list --wifi 2>&1)
    log "$SPOOF_OUTPUT"
else
    log "SpoofMAC not found at /opt/local/bin/spoof – skipping MAC spoofing and status check."
fi

# Immediately disable Wi-Fi network service to prevent early connections
log "DISABLE WI-FI:"
run_and_log "/usr/sbin/networksetup -setnetworkserviceenabled Wi-Fi off"

# Apply system power settings
log "PREVENT WAKE-ON-LAN WI-FI ACTIVATIONS:" >> "$LOGFILE"
run_and_log "/usr/bin/pmset -a womp 0"
log "PREVENT WAKE-FROM-SLEEP WI-FI ACTIVATIONS:" >> "$LOGFILE"
run_and_log "/usr/bin/pmset -a networkoversleep 0"

log "===== Daemon Script 1) completed ====="

sudo launchctl kickstart -k system/info.term7.on.networksetup.daemon
