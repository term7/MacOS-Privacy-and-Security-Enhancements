#!/usr/bin/env bash

#   INSTALL_SpoofMAC.sh
#   term7 / 10.03.2024
#   Original code by feross: https://github.com/feross/spoof
#
#   MODIFIED 15.08.2026 by OpenHat Security (https://github.com/openhat-security):
#   This script no longer installs MacPorts, Node.js or the npm package "spoof".
#   MAC address randomization is now performed by a small helper script that only
#   uses macOS built-ins (/dev/urandom, /usr/sbin/networksetup, /sbin/ifconfig).
#   The LaunchDaemon design, the interactive install flow and the script structure
#   are term7's and are preserved.
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

# -------Abort Function:--------

function abort {
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
  echo "                                ---------------";
  echo "                                A B O R T I N G";
  echo "                                ---------------";
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
}

# -------Wrong Input Function:--------

function invalid {
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
  echo "                        --------------------------------";
  echo "                        INVALID INPUT - PLEASE TRY AGAIN";
  echo "                        --------------------------------";
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
}

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "   .d8888b.                              .d888 888b     d888"
echo "  d88P  Y88b                            d88P'  8888b   d8888"
echo "  Y88b.                                 888    88888b.d88888"
echo "   'Y888b.   88888b.   .d88b.   .d88b.  888888 888Y88888P888  8888b.   .d8888b"
echo "      'Y88b. 888 '88b d88''88b d88''88b 888    888 Y888P 888     '88b d88P'"
echo "         '88 888  888 888  888 888  888 888    888  Y8P  888 .d888888 888"
echo "  Y88b  d88P 888 d88P Y88..88P Y88..88P 888    888   '   888 888  888 Y88b."
echo "   'Y8888P'  88888P'   'Y88P'   'Y88P'  888    888       888 'Y888888  'Y8888P"
echo "             888"
echo "             888"
echo "             888"
echo "             888"
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"

# -------What this Script does:--------

echo " "
echo " "
echo "--------------------------------------------------------------------------------"

echo " "
echo "                                            ${bold}/ SpoofMAC / WHAT THIS SCRIPT DOES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "${bold}... THIS INTERACTIVE SCRIPT IS DESIGNED TO INSTALL SpoofMAC ON YOUR COMPUTER ...${reset}"
echo " "
echo "Your computer can always be identified via the unique MAC address of its network"
echo "interfaces (i.e. Ethernet, Wi-Fi & Bluetooth). SpoofMAC changes the MAC address"
echo "of your Wi-Fi Card to a random value, so that it becomes impossible to track and"
echo "fingerprint you via your device's MAC address."
echo " "
echo "This simple script installs a small helper script and, if you choose so, sets up"
echo "a Launch Daemon that randomizes the MAC address of your Wi-Fi Card whenever you"
echo "reboot your computer, making it impossible for other devices and network"
echo "operators to discover your identity via its MAC address when you connect to the"
echo "internet."
echo " "
echo "SpoofMAC requires ${bold}NO EXTERNAL SOFTWARE${reset}. It uses macOS built-in tools only:"
echo "/dev/urandom to generate a random address, /usr/sbin/networksetup to find your"
echo "Wi-Fi Card and to cycle its radio, and /sbin/ifconfig to apply the new address."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                ${bold}THIS SCRIPT HAS BEEN TESTED ON MACOS SONOMA."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -p "Type ${bold}[install]${reset} to install SpoofMAC, or ${bold}[exit]${reset} to abort & press ${bold}[ENTER]${reset}: " SpoofMAC
case $SpoofMAC in
[i][n][s][t][a][l][l])

# -------Abort this script unless a Wi-Fi Card is present:--------

# The Wi-Fi device is not always en0. We ask networksetup which device belongs to
# the "Wi-Fi" hardware port rather than hardcoding a device name.

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
  countdown "00:00:7"
  exit;
else

  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  echo "                   WI-FI CARD FOUND ON DEVICE: ${bold}${WIFI_DEVICE}${reset}"
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  countdown "00:00:3"

fi

break;;

# -------Input [exit]: Abort:--------

[e][x][i][t])
abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Variables:--------

ENHANCEMENTS=/Users/Shared/Enhancements/spoof_mac
SPOOF=$ENHANCEMENTS/spoof_mac.sh
LOGFILE=$ENHANCEMENTS/spoof_mac.log

DAEMON_FOLDER=/Library/LaunchDaemons
SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON_FILE=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist

# -------Setup Script Location:--------

echo " "
echo " "
echo "------------------------------setup script location-----------------------------"
echo " "
echo "if [ ! -d \"${ENHANCEMENTS}\" ]; then sudo -u $(stat -f '%Su' /dev/console) mkdir ${ENHANCEMENTS} fi"

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi
sleep 1

echo "sudo chown $(stat -f '%Su' /dev/console):wheel ${ENHANCEMENTS}"
sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"
sleep 1

# -------Create Boot-Time Script:--------

echo " "
echo "-----------------------------setup boot-time script-----------------------------"
echo " "
echo "${SPOOF}"
sleep 1

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
EOF

# -------Make Script Executable:--------

echo " "
echo " "
echo "-----------------------------make script executable-----------------------------"
echo " "
echo "sudo chown root:wheel ${SPOOF}"
sudo chown root:wheel "$SPOOF"
sleep 1

echo "sudo chmod 755 ${SPOOF}"
sudo chmod 755 "$SPOOF"
sleep 1

# -------Run SpoofMAC once:--------

echo " "
echo " "
echo "----------------------------------run SpoofMAC----------------------------------"
echo " "
echo "sudo ${SPOOF}"
echo " "
echo "${bold}YOUR WI-FI WILL BRIEFLY DISCONNECT WHILE THE NEW MAC ADDRESS IS APPLIED.${reset}"
echo " "
countdown "00:00:3"

sudo "$SPOOF"

echo " "
echo "--------------------------------------------------------------------------------"
echo " "

/usr/sbin/networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print "        - \"Wi-Fi\" on device \"" $2 "\"" }'
/sbin/ifconfig "$WIFI_DEVICE" | awk '/[[:space:]]ether[[:space:]]/ { print "          currently set to " toupper($2) }'

echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Your Wi-Fi device should have a changed MAC address now! To read the MAC address"
echo "that is currently set on your Wi-Fi Card, enter this command into a Terminal"
echo "Window: ifconfig ${WIFI_DEVICE} | grep ether"
echo " "
echo "To see the log of the last run, enter this command into a Terminal Window:"
echo "cat ${LOGFILE}"
echo " "
echo "                                             -> **MORE INFO** 04_SpoofMAC/README.md"
echo "--------------------------------------------------------------------------------"
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

# -------SpoofMAC LaunchDaemon:--------

echo " "
echo "                                              ${bold}/ SpoofMAC / RANDOMIZE ON REBOOT /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "This script can configure ${bold}AUTOMATIC MAC RANDOMIZATION${reset} for you."
echo " "
echo "If you choose to set up ${bold}AUTOMATIC MAC RANDOMIZATION${reset}, this script will configure"
echo "a Launch Daemon that runs the required commands once everytime you reboot your"
echo "computer."
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "You can find the ${bold}SPOOF DAEMON${reset} in this location:"
echo "${DAEMON_FOLDER}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "Press ${bold}[Y/y]${reset} to set up ${bold}AUTOMATIC MAC RANDOMIZATION${reset}, or ${bold}[C/c]${reset} to cancel: " RAND
case $RAND in

# -------Input [Y/y]: setup Global Spoof Daemon:--------

[Yy])

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
echo " "
echo " "
echo "------------------------------create LaunchDaemon-------------------------------"
echo " "
echo "${SpoofMAC_DAEMON_FILE}"
sleep 1

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

echo " "
echo " "
echo "-------------------------setup ownership & permissions--------------------------"
echo " "
echo "sudo chown root:wheel ${SpoofMAC_DAEMON_FILE}"
sleep 1

sudo chown root:wheel "$SpoofMAC_DAEMON_FILE"

echo "sudo chmod 644 ${SpoofMAC_DAEMON_FILE}"
sleep 1

sudo chmod 644 "$SpoofMAC_DAEMON_FILE"

# -------Load spoof daemon:--------

echo " "
echo " "
echo "-------------------------------load LaunchDaemon--------------------------------"
echo " "

echo "launchctl bootstrap system ${SpoofMAC_DAEMON_FILE}"
launchctl bootstrap system "$SpoofMAC_DAEMON_FILE"

sleep 1

echo " "
echo " "
echo "------------------------open LaunchDaemon in Text Editor------------------------"
echo " "
echo "open -a TextEdit ${SpoofMAC_DAEMON_FILE}"
open -a TextEdit "$SpoofMAC_DAEMON_FILE"
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
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo "   ${bold}We have opened a text file with the SpoofMAC-LaunchDaemon. Please review!${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready to continue: "

echo " "
echo " "
echo "------------------------open Boot-Time Script in Text Editor--------------------"
echo " "
echo "open -a TextEdit ${SPOOF}"
open -a TextEdit "$SPOOF"
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
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo "     ${bold}We have opened a text file with the SpoofMAC-Script. Please review!${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready to continue: "

break;;

# -------Input [C/c]: Abort:--------

[Cc])
abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done


echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                              888"
echo "                              888"
echo "            .d8888b   .d88b.  888888 888  888 88888b."
echo "            88K      d8P  Y8b 888    888  888 888 '88b"
echo "            'Y8888b. 88888888 888    888  888 888  888"
echo "                 X88 Y8b.     Y88b.  Y88b 888 888 d88P"
echo "             88888P'  'Y8888   'Y888  'Y88888 88888P"
echo "                                              888"
echo "                                              888          888"
echo "                                              888          888"
echo "       .d8888b .d88b.  88888b.d88b.  88888b.  888  .d88b.  888888 .d88b."
echo "      d88P'   d88''88b 888 '888 '88b 888 '88b 888 d8P  Y8b 888   d8P  Y8b"
echo "      888     888  888 888  888  888 888  888 888 88888888 888   88888888"
echo "      Y88b.   Y88..88P 888  888  888 888 d88P 888 Y8b.     Y88b. Y8b."
echo "       'Y8888P 'Y88P'  888  888  888 88888P'  888  'Y8888   'Y888 'Y8888"
echo "                                     888"
echo "                                     888"
echo "                                     888"
echo " "
echo "                                          -> **MORE INFO** 04_SpoofMAC/README.md"
echo "--------------------------------------------------------------------------------"
read -s -n 1 -p  "Press ${bold}[ANY KEY]${reset} to exit this script: "
