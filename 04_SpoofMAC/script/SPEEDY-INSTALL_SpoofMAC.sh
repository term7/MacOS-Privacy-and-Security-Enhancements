#!/usr/bin/env bash

#   SPEEDY-INSTALL_SpoofMAC.sh
#   term7 / 10.03.2024
#   Original code by feross: https://github.com/feross/spoof
#
#   MODIFIED 15.08.2026 by OpenHat Security (https://github.com/openhat-security):
#   This script no longer installs MacPorts, Node.js or the npm package "spoof".
#   MAC address randomization is now performed by a small helper script that only
#   uses macOS built-ins (/dev/urandom, /usr/sbin/networksetup, /sbin/ifconfig).
#   The LaunchDaemon design, the install flow and the script structure are term7's.
#
#   MODIFIED 07.09.2026 by term7:
#   Changed MAC assignment from OFF -> MAC-change -> ON to OFF -> ON -> immediate MAC-change because current macOS does not accept the ifconfig MAC change while the Wi-Fi radio is still powered off.
#   Added retry handling for the early-boot Wi-Fi readiness race.
#   Added detection and migration of existing standalone Wifi-OFF [see: 05 - WiFi-OFF] installations: their LaunchDaemons and helper scripts are removed when automatic SpoofMAC is enabled, and the Wifi-OFF radio-off behavior is integrated into spoof_mac.sh.
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

# -------Prerequisites:--------

# SpoofMAC no longer requires MacPorts, Node.js or npm. The only prerequisite is a
# Wi-Fi card, which we resolve via networksetup instead of assuming it is en0.

WIFI_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print $2; exit }')

if [ -z "$WIFI_DEVICE" ];
then
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

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
  echo "                 --------------------------------------------"
  echo "                 NO WI-FI HARDWARE PORT FOUND - NOTHING TO DO"
  echo "                 --------------------------------------------"
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
  exit;
fi

# -------Variables:--------

ENHANCEMENTS=/Users/Shared/Enhancements/spoof_mac
SPOOF=$ENHANCEMENTS/spoof_mac.sh

DAEMON_FOLDER=/Library/LaunchDaemons
SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON_FILE=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist

WIFIOFF_ENHANCEMENTS=/Users/Shared/Enhancements/disable_wifi
WIFIOFF_DISABLE_DAEMON_NAME=info.term7.off.networksetup.daemon
WIFIOFF_ENABLE_DAEMON_NAME=info.term7.on.networksetup.daemon
WIFIOFF_DISABLE_DAEMON=$DAEMON_FOLDER/$WIFIOFF_DISABLE_DAEMON_NAME.plist
WIFIOFF_ENABLE_DAEMON=$DAEMON_FOLDER/$WIFIOFF_ENABLE_DAEMON_NAME.plist
WIFIOFF_MIGRATE=0

# -------Check for existing Wifi-OFF installation:--------

if [ -e "$WIFIOFF_DISABLE_DAEMON" ] || \
   [ -e "$WIFIOFF_ENABLE_DAEMON" ] || \
   sudo launchctl print "system/${WIFIOFF_DISABLE_DAEMON_NAME}" > /dev/null 2>&1 || \
   sudo launchctl print "system/${WIFIOFF_ENABLE_DAEMON_NAME}" > /dev/null 2>&1; then

    WIFIOFF_MIGRATE=1

    echo " "
    echo "Existing Wifi-OFF LaunchDaemon setup detected."
    echo "Wifi-OFF will be migrated into the new SpoofMAC helper script."
    echo " "

fi

# -------Setup Script Location:--------

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi

sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"

# -------Create Boot-Time Script:--------

sudo tee "$SPOOF" > /dev/null << 'EOF'
#!/bin/bash

#   spoof_mac.sh
#
#   NEW FILE, added 15.08.2026 by OpenHat Security (https://github.com/openhat-security)
#   as part of a modification of term7's "MacOS Privacy and Security Enhancements".
#
#   It replaces the previous SpoofMAC daemon payload, which invoked the npm package
#   "spoof" (https://github.com/feross/spoof) through a MacPorts installation of
#   Node.js. This script performs the same job using macOS built-ins only:
#   /dev/urandom, /usr/sbin/networksetup and /sbin/ifconfig. No MacPorts, no
#   Node.js, no npm.
#
#   The daemon layout, the logging helpers and the overall script structure follow
#   term7's own conventions (see 05_WiFi-OFF/network_daemon/01_disable_wifi.sh).
#
#   Copyright (c) 2026 OpenHat Security
#
#   MODIFIED 07.09.2026 by term7:
#   Changed MAC assignment from OFF -> MAC-change -> ON to OFF -> ON -> immediate
#   MAC-change because current macOS does not accept the ifconfig MAC change while
#   the Wi-Fi radio is still powered off.
#   Added retry handling for the early-boot Wi-Fi readiness race.
#
#   This program is free software: you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free Software
#   Foundation, either version 3 of the License, or (at your option) any later
#   version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#   PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along with
#   this program. If not, see <https://www.gnu.org/licenses/>.

LOGFILE="/Users/Shared/Enhancements/spoof_mac/spoof_mac.log"
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

log "===== SpoofMAC Daemon Script started ====="

# -------Find the Wi-Fi Device:--------

# The Wi-Fi device is not always en0. Apple assigns BSD device names in the order
# the interfaces are enumerated, so a Mac with a Thunderbolt dock, an USB Ethernet
# adapter or an iPhone tethered over USB can end up with Wi-Fi on en1, en2 or later.
# We therefore ask networksetup which device belongs to the "Wi-Fi" hardware port
# instead of hardcoding a name.

WIFI_DEVICE=$(/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print $2; exit }')

if [ -z "$WIFI_DEVICE" ]; then
  log "No Wi-Fi hardware port found – nothing to randomize. Exiting."
  log "===== SpoofMAC Daemon Script completed ====="
  exit 1
fi

log "Wi-Fi hardware port found on device: ${WIFI_DEVICE}"

# -------Generate a Random MAC Address:--------

# Six random bytes are read from /dev/urandom, the kernel CSPRNG. We deliberately
# do not use $RANDOM, which is a weak, seeded PRNG and a poor source for an
# identifier that is meant to be unlinkable across locations.
#
# The first octet then has two bits corrected. They live in the least significant
# bits of the first octet and this is the single easiest thing to get wrong:
#
#   bit 0 (0x01) – I/G bit. 0 = individual (unicast), 1 = group (multicast).
#                  It MUST be 0. A station address with the multicast bit set is
#                  invalid, and the driver or the access point will reject it.
#   bit 1 (0x02) – U/L bit. 0 = universally administered (an address drawn from a
#                  vendor's IEEE registered OUI), 1 = locally administered.
#                  It MUST be 1, because we are making this address up. Setting it
#                  also stops us from impersonating a real vendor's OUI.
#
# So: OR with 0x02 to force the locally administered bit ON, AND with 0xFE to force
# the multicast bit OFF. This yields a valid, locally administered unicast address.

generate_mac() {
  local bytes first
  # shellcheck disable=SC2207
  bytes=( $(/usr/bin/od -An -N6 -tu1 /dev/urandom) )

  if [ "${#bytes[@]}" -ne 6 ]; then
    return 1
  fi

  first=$(( (bytes[0] | 0x02) & 0xFE ))

  printf '%02x:%02x:%02x:%02x:%02x:%02x' \
    "$first" "${bytes[1]}" "${bytes[2]}" "${bytes[3]}" "${bytes[4]}" "${bytes[5]}"
}

NEW_MAC=$(generate_mac)

if [ -z "$NEW_MAC" ]; then
  log "Could not read six random bytes from /dev/urandom – aborting without changing the MAC address."
  log "===== SpoofMAC Daemon Script completed ====="
  exit 1
fi

log "CURRENT MAC-ADDRESS:"
log "$(/sbin/ifconfig "$WIFI_DEVICE" 2>&1 | awk '/[[:space:]]ether[[:space:]]/ { print $2 }')"

log "NEW MAC-ADDRESS:"
log "$NEW_MAC"

# -------Dissociate from any Wi-Fi Network:--------

# macOS refuses to apply a new hardware address while the interface is associated
# with a network. The npm "spoof" package solved this by calling Apple's private
# airport CLI with -z. That binary was deprecated in macOS 14.4 and has since been
# removed, so it is no longer an option. Powering the radio down achieves the same
# dissociation using a documented, supported command.
#
# On current macOS versions, however, ifconfig cannot change the MAC address while
# the Wi-Fi radio remains powered off. We therefore power Wi-Fi off to dissociate,
# power it straight back on, and immediately attempt the MAC change before the
# interface has time to associate with a network.

log "DISSOCIATE FROM WI-FI NETWORK:"

# -------Apply the New MAC Address:--------

# During early boot, networksetup may successfully power Wi-Fi on before the
# Wi-Fi interface is fully ready to accept a new link-layer address. In that
# state, networksetup returns exit code 0, but ifconfig can still fail with:
#
#   ifconfig: ioctl (SIOCAIFADDR): Network is down
#
# Testing on both reboot and cold boot showed that this condition can persist
# for several seconds after the LaunchDaemon starts.
#
# The complete OFF -> ON -> MAC-change sequence is therefore retried. Repeating
# the power cycle also forces Wi-Fi back into an unassociated state on each
# attempt, giving ifconfig a fresh opportunity to change the MAC address before
# macOS automatically reconnects to a remembered network.

log "SPOOF MAC-ADDRESS:"

MAC_APPLIED=0

for i in {1..5}; do
  log "MAC change attempt ${i}/5"

  if ! run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} off"; then
    log "Could not power Wi-Fi off."
    sleep 1
    continue
  fi

  # Do not pause here. The MAC change must be attempted while Wi-Fi is powered on
  # but before it has associated with a network.
  if ! run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} on"; then
    log "Could not power Wi-Fi on."
    sleep 1
    continue
  fi

  if run_and_log "/sbin/ifconfig ${WIFI_DEVICE} ether ${NEW_MAC}"; then
    MAC_APPLIED=1
    break
  fi

  log "MAC change failed; retrying the off/on/change sequence."
  sleep 1
done

if [ "$MAC_APPLIED" -ne 1 ]; then
  log "Could not apply MAC address after 5 attempts."
  log "===== SpoofMAC Daemon Script completed ====="
  exit 1
fi

# -------Verify:--------

log "CURRENT SPOOF STATUS:"

APPLIED_MAC=$(/sbin/ifconfig "$WIFI_DEVICE" 2>&1 | awk '/[[:space:]]ether[[:space:]]/ { print $2 }')

if [ "$APPLIED_MAC" = "$NEW_MAC" ]; then
  log "\"Wi-Fi\" on device \"${WIFI_DEVICE}\" is now set to ${APPLIED_MAC}"
else
  log "MAC address was NOT applied. Device \"${WIFI_DEVICE}\" reports ${APPLIED_MAC}, expected ${NEW_MAC}."
  log "===== SpoofMAC Daemon Script completed ====="
  exit 1
fi

log "===== SpoofMAC Daemon Script completed ====="
EOF

# -------Carry existing Wifi-OFF into SpoofMAC:--------

if [ "$WIFIOFF_MIGRATE" -eq 1 ]; then

    FINAL_COMPLETION_LINE=$(
        /usr/bin/grep -n '^[[:space:]]*log "===== SpoofMAC Daemon Script completed ====="[[:space:]]*$' "$SPOOF" \
        | /usr/bin/tail -n 1 \
        | /usr/bin/cut -d: -f1
    )

    if [ -z "$FINAL_COMPLETION_LINE" ]; then
        echo "Could not locate the final completion line in the SpoofMAC helper script."
        echo "The existing Wifi-OFF installation has NOT been removed."
        exit 1
    fi

    TMPFILE=$(/usr/bin/mktemp /tmp/SpoofMAC-Wifi-OFF.XXXXXX)
    BLOCKFILE=$(/usr/bin/mktemp /tmp/SpoofMAC-Wifi-OFF-block.XXXXXX)

    if [ -z "$TMPFILE" ] || [ -z "$BLOCKFILE" ]; then
        echo "Could not create temporary files."
        echo "The existing Wifi-OFF installation has NOT been removed."
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
        ' "$SPOOF" > "$TMPFILE"

    if ! /bin/bash -n "$TMPFILE"; then
        echo "The Wifi-OFF integrated SpoofMAC helper failed the Bash syntax check."
        echo "The existing Wifi-OFF installation has NOT been removed."
        exit 1
    fi

    if ! sudo /usr/bin/install -o root -g wheel -m 755 "$TMPFILE" "$SPOOF"; then
        echo "Could not install the Wifi-OFF integrated SpoofMAC helper script."
        echo "The existing Wifi-OFF installation has NOT been removed."
        exit 1
    fi

    if ! /usr/bin/grep -Fq "# -------WiFi-OFF Integration:--------" "$SPOOF"; then
        echo "Wifi-OFF integration could not be verified."
        echo "The existing Wifi-OFF installation has NOT been removed."
        exit 1
    fi

    echo "Wifi-OFF was successfully added to the SpoofMAC helper script."

fi

# -------Make Script Executable:--------

sudo chown root:wheel "$SPOOF"
sudo chmod 755 "$SPOOF"

# -------Global Spoof Daemon:--------

sudo tee "$SpoofMAC_DAEMON_FILE" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${SpoofMAC_DAEMON_NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${SPOOF}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

sudo chown root:wheel "$SpoofMAC_DAEMON_FILE"
sudo chmod 644 "$SpoofMAC_DAEMON_FILE"

# -------Remove standalone Wifi-OFF installation:--------

if [ "$WIFIOFF_MIGRATE" -eq 1 ]; then

    if sudo launchctl print "system/${WIFIOFF_DISABLE_DAEMON_NAME}" > /dev/null 2>&1; then
        sudo launchctl bootout "system/${WIFIOFF_DISABLE_DAEMON_NAME}"
    fi

    if sudo launchctl print "system/${WIFIOFF_ENABLE_DAEMON_NAME}" > /dev/null 2>&1; then
        sudo launchctl bootout "system/${WIFIOFF_ENABLE_DAEMON_NAME}"
    fi

    if [ -e "$WIFIOFF_DISABLE_DAEMON" ]; then
        sudo rm "$WIFIOFF_DISABLE_DAEMON"
    fi

    if [ -e "$WIFIOFF_ENABLE_DAEMON" ]; then
        sudo rm "$WIFIOFF_ENABLE_DAEMON"
    fi

    if [ -d "$WIFIOFF_ENHANCEMENTS" ]; then
        sudo rm -rf "$WIFIOFF_ENHANCEMENTS"
    fi

    echo "Existing standalone Wifi-OFF installation removed."
    echo "Wifi-OFF is now integrated into the SpoofMAC helper script."

fi

# -------Load Daemons:--------

sudo launchctl bootstrap system "$SpoofMAC_DAEMON_FILE"

echo " "
echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s