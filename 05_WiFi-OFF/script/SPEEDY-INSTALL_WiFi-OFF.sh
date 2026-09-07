#!/usr/bin/env bash

#   SPEEDY-INSTALL_Wifi-OFF.sh
#   term7 / 26.05.2025 - last modification: 07.09.2026
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# -------Admin Check:--------

if ! sudo -v; then
    echo "Administrator privileges are required."
    exit 1
fi

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

SPOOFMAC=/Users/Shared/Enhancements/spoof_mac/spoof_mac.sh
SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist

WIFIOFF_MARKER="# -------WiFi-OFF Integration:--------"

# -------Choose Installation Mode:--------

if [ -x "$SPOOFMAC" ] && [ -e "$SpoofMAC_DAEMON" ]; then

    INSTALL_MODE="SPOOFMAC"

    echo " "
    echo "SpoofMAC installation found."
    echo "Wifi-OFF will use the existing SpoofMAC boot setup."
    echo "No additional Wifi-OFF LaunchDaemons will be installed."
    echo " "

    # -------Check if Wifi-OFF is already integrated:--------

    if /usr/bin/grep -Fq "$WIFIOFF_MARKER" "$SPOOFMAC"; then

        echo "Wifi-OFF is already integrated into the SpoofMAC helper script."
        echo "No changes are necessary."
        echo " "

    else

        # -------Find final SpoofMAC completion line:--------

        FINAL_COMPLETION_LINE=$(
            /usr/bin/grep -n '^[[:space:]]*log "===== SpoofMAC Daemon Script completed ====="[[:space:]]*$' "$SPOOFMAC" \
            | /usr/bin/tail -n 1 \
            | /usr/bin/cut -d: -f1
        )

        if [ -z "$FINAL_COMPLETION_LINE" ]; then
            echo "Could not locate the final completion line in the SpoofMAC helper script."
            echo "The script has not been modified."
            exit 1
        fi

        # -------Create Wifi-OFF integration block:--------

        TMPFILE=$(/usr/bin/mktemp /tmp/Wifi-OFF.XXXXXX)
        BLOCKFILE=$(/usr/bin/mktemp /tmp/Wifi-OFF-block.XXXXXX)

        if [ -z "$TMPFILE" ] || [ -z "$BLOCKFILE" ]; then
            echo "Could not create temporary files."
            exit 1
        fi

        trap 'rm -f "$TMPFILE" "$BLOCKFILE"' EXIT

        cat > "$BLOCKFILE" << 'WIFIOFF_EOF'
# -------WiFi-OFF Integration:--------

# After SpoofMAC has successfully randomized and verified the MAC address, power
# the Wi-Fi radio off again. The Wi-Fi network service itself remains enabled, so
# the logged-in user can turn Wi-Fi back on manually whenever needed.

log "DISABLE WI-FI:"

if ! run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} off"; then
  log "Could not power Wi-Fi off."
  log "===== SpoofMAC Daemon Script completed ====="
  exit 1
fi

WIFIOFF_EOF

        # -------Add Wifi-OFF to SpoofMAC:--------

        /usr/bin/awk \
            -v insert_at="$FINAL_COMPLETION_LINE" \
            -v block="$BLOCKFILE" \
            '
            NR == insert_at {
                while ((getline line < block) > 0)
                    print line
                close(block)
            }
            {
                print
            }
            ' "$SPOOFMAC" > "$TMPFILE"

        # -------Validate modified SpoofMAC script:--------

        if ! /bin/bash -n "$TMPFILE"; then
            echo "The modified SpoofMAC helper script failed the Bash syntax check."
            echo "The installed SpoofMAC helper script has NOT been changed."
            exit 1
        fi

        # -------Install modified SpoofMAC script:--------

        if ! sudo /usr/bin/install -o root -g wheel -m 755 "$TMPFILE" "$SPOOFMAC"; then
            echo "Could not install the modified SpoofMAC helper script."
            echo "Wifi-OFF has not been installed."
            exit 1
        fi

        # -------Verify Wifi-OFF integration:--------

        if ! /usr/bin/grep -Fq "$WIFIOFF_MARKER" "$SPOOFMAC"; then
            echo "Wifi-OFF integration could not be verified."
            exit 1
        fi

        echo "Wifi-OFF was successfully added to the existing SpoofMAC helper script."
        echo " "

    fi

else

    INSTALL_MODE="STANDALONE"

    echo " "
    echo "A complete automatic SpoofMAC installation was not found."
    echo "Wifi-OFF will install its standalone helper scripts and LaunchDaemons."
    echo " "

    # -------Setup Script Location:--------

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

# Find the Wi-Fi device. It is not always en0.
WIFI_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print $2; exit }')

if [ -n "$WIFI_DEVICE" ]; then
    log "Wi-Fi hardware port found on device: ${WIFI_DEVICE}"
else
    log "No Wi-Fi hardware port found."
fi

# Spoof Wi-Fi MAC Address if the new SpoofMAC helper exists.
# WiFi-OFF owns the boot sequence when installed, so the separate SpoofMAC
# LaunchDaemon is removed by the installer and this script invokes the helper
# directly instead.
SPOOFMAC="/Users/Shared/Enhancements/spoof_mac/spoof_mac.sh"

if [ -x "$SPOOFMAC" ]; then
    log "SPOOF MAC-ADDRESS:"
    if run_and_log "$SPOOFMAC"; then
        log "SpoofMAC completed successfully."
    else
        log "SpoofMAC failed. Continuing with Wi-Fi shutdown."
    fi
else
    log "SpoofMAC helper not found at ${SPOOFMAC} – skipping MAC spoofing."
fi

# SpoofMAC intentionally leaves the Wi-Fi radio powered on because current macOS
# requires the interface to be on but unassociated when changing its MAC address.
# WiFi-OFF therefore turns the radio back off immediately afterwards.
if [ -n "$WIFI_DEVICE" ]; then
    log "DISABLE WI-FI RADIO:"
    for i in {1..10}; do
        if run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} off"; then
            break
        fi
        log "Retrying setairportpower in 2 seconds... (attempt $i)"
        sleep 2
    done
fi

# Immediately disable Wi-Fi network service to prevent early connections
log "DISABLE WI-FI NETWORK SERVICE:"
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

# Find the Wi-Fi device. It is not always en0.
WIFI_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print $2; exit }')

# Turn off the Wi-Fi radio interface
if [ -n "$WIFI_DEVICE" ]; then
  for i in {1..10}; do
    run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} off"
    if [ $? -eq 0 ]; then
      break
    fi
    log "Retrying setairportpower in 2 seconds..."
    sleep 2
  done
else
  log "No Wi-Fi hardware port found – skipping radio power command."
fi

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

    # -------DISABLE AND DELETE STANDALONE SPOOFMAC DAEMON (if it exists):--------

    if [ -e "$SpoofMAC_DAEMON" ]; then
        sudo launchctl bootout system "$SpoofMAC_DAEMON"
        sudo rm "$SpoofMAC_DAEMON"
    fi

    # -------Load Daemons:--------

    sudo launchctl bootstrap system "$DISABLE_DAEMON"
    sudo launchctl bootstrap system "$ENABLE_DAEMON"

fi

echo " "

if [ "$INSTALL_MODE" = "SPOOFMAC" ]; then
    echo "Wifi-OFF has been integrated into the existing SpoofMAC helper script."
    echo "No additional Wifi-OFF LaunchDaemons were installed."
    echo "Whenever SpoofMAC runs at boot, Wi-Fi will be switched off after the MAC"
    echo "address has been successfully randomized and verified."
else
    echo "Standalone Wifi-OFF has been installed."
    echo "Whenever you start your computer, Wi-Fi will be switched off."
    echo "You can always connect manually after login."
fi

echo " "
echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s