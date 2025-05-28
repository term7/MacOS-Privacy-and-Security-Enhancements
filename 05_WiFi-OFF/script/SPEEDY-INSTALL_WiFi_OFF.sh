#!/usr/bin/env bash

#   SPEEDY-INSTALL_Wifi-OFF.sh
#   term7 / 26.05.2025
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

ENHANCEMENTS=/Users/Shared/Enhancements/disable_wifi
DISABLE=$ENHANCEMENTS/01_disable_wifi.sh
ENABLE=$ENHANCEMENTS/02_enable_wifi.sh

DAEMON_FOLDER=/Library/LaunchDaemons
DISABLE_DAEMON_NAME=info.term7.off.networksetup.daemon
ENABLE_DAEMON_NAME=info.term7.on.networksetup.daemon
DISABLE_DAEMON=$DAEMON_FOLDER/$DISABLE_DAEMON_NAME.plist
ENABLE_DAEMON=$DAEMON_FOLDER/$ENABLE_DAEMON_NAME.plist

SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi

sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"

# -------Create Boot-Time Script:--------

sudo tee /Users/Shared/Enhancements/disable_wifi/01_disable_wifi.sh > /dev/null << 'EOF'
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
EOF

# -------Create Login-Time Script:--------

sudo tee /Users/Shared/Enhancements/disable_wifi/02_enable_wifi.sh > /dev/null << 'EOF'
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
EOF

# -------Make Scripts Executable:--------

sudo chmod +x "$DISABLE"
sudo chmod +x "$ENABLE"

# -------Boot-Time Daemon:--------

sudo tee "$DISABLE_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
    <string>$DISABLE_DAEMON_NAME</string>
	<key>Nice</key>
	<integer>-20</integer>
	<key>ProgramArguments</key>
	<array>
		<string>${DISABLE}</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOF

# -------Login Daemon:--------

sudo tee "$ENABLE_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$ENABLE_DAEMON_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>${ENABLE}</string>
    </array>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

sudo chown root:wheel "$DISABLE_DAEMON"
sudo chmod 644 "$DISABLE_DAEMON"
sudo chown root:wheel "$ENABLE_DAEMON"
sudo chmod 644 "$ENABLE_DAEMON"

# -------DISABLE AND DELETE SPOOFMAC DAEMON (if it exists):--------

if [ -e "$SpoofMAC_DAEMON" ]; then
    sudo launchctl bootout system ${SpoofMAC_DAEMON}
    sudo rm ${SpoofMAC_DAEMON}
fi

# -------Load Daemons:--------

sudo launchctl bootstrap system "$DISABLE_DAEMON"
sudo launchctl bootstrap system "$ENABLE_DAEMON"   

echo " "
echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s