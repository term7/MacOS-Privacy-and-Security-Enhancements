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

log "DISSOCIATE FROM WI-FI NETWORK:"

for i in {1..10}; do
  if run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} off"; then
    break
  fi
  log "Retrying setairportpower in 2 seconds... (attempt $i)"
  sleep 2
done

# Pause to let the radio settle before we touch the hardware address
sleep 2

# -------Apply the New MAC Address:--------

log "SPOOF MAC-ADDRESS:"
run_and_log "/sbin/ifconfig ${WIFI_DEVICE} ether ${NEW_MAC}"

# -------Power the Radio Back On:--------

log "ENABLE WI-FI:"
run_and_log "/usr/sbin/networksetup -setairportpower ${WIFI_DEVICE} on"

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
