#!/usr/bin/env bash

#   INSTALL_Wifi-OFF.sh
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
echo "                  .:l'                                   .cc."
echo "                 ;kNWk.                                 .xWNO:"
echo "               .dNMWO:                                   ,kNMNk'"
echo "              ;0WMXl.      ;oo'                 .lo:.     .cKWMK:"
echo "             :KMW0;      ,kNMWo                 cNMWO;      'OWMXc"
echo "            ;KMWO'      cXMW0c.                 ;0WMXo.     .kWMXc"
echo "           'OMM0,      lNMWk.                     .xNMNd.     .OMMK,"
echo "           oWMNc      :XMWx.         ,,.,,         .dWMNl      :XMWd."
echo "          '0MMO.     .OMM0'        odxxxxxdo        .kMM0'     .xMMK,"
echo "          :NMWo      :NMWo       ;KNkoooookNNc       cNMWl      cWMNc"
echo "          cWMWc      lWMN:       oMk.     .kMx.      ;KMMd      :NMWl"
echo "          cWMNc      lWMN:       oWk.     .kMx.      ;KMMd      :NMWl"
echo "          :NMWo      :NMWo       ;KNkdddodkNX:       cNMWc      lWMWc"
echo "          '0MMk.     .OMM0'       .cdOWMW0dl'       .OMM0'     .xMMK,"
echo "           oWMNc      :XMWk.         '''''         .dWMNc      :XMWd."
echo "           '0MM0,      cXMWk'                     .xWMNo.     'OMMK,"
echo "            ;XMMO'      :KMMKc.                  :0WMXl.     .kWMX:"
echo "             :XMW0,      'xNMWo                 cNMWO,      ,OWMXc"
echo "              ;0MMXl.      ,ll'                 .co;.     .lXMMK;"
echo "               .xNMWO;                                   ;OWMNx'"
echo "                 ;kNWk.                                  .dNNO;"
echo "                   ',.                                   .''      ...Wi-Fi = ON"

countdown "00:00:7"

# -------What this Script does:--------

echo " "
echo " "
echo "--------------------------------------------------------------------------------"

echo " "
echo "                                          ${bold}/ WiFi = OFF / WHAT THIS SCRIPT DOES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "${bold}THIS INTERACTIVE SCRIPT IS DESIGNED TO DISABLE WI-FI AT BOOT ON YOUR COMPUTER!${reset}"
echo " "
echo "Apple computers often restore the last Wi-Fi state after a reboot, but thus is"
echo "not guaranteed. On macOS, Wi-Fi may turn back on automatically due to system"
echo "services that override the previous state. There is no setting to prevent this,"
echo "so we created a tool that ensures to keep Wi-Fi off at startup."
echo " "
echo "This simple script sets up two helper scripts and two LaunchDaemons that make"
echo "sure your Wi-Fi is switched off when you boot your computer. Furthermore, if"
echo "SpoofMAC is installed, it can randomize the MAC address of your Wi-Fi Card"
echo "whenever you reboot your computer, making it impossible for other devices and"
echo "network operators to discover your identity via its MAC address when you connect"
echo "to the internet."
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                ${bold}THIS SCRIPT HAS BEEN TESTED ON MACOS SONOMA."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -p "Type ${bold}[install]${reset} to install WiFi=OFF, or ${bold}[exit]${reset} to abort & press ${bold}[ENTER]${reset}: " WiFi
case $WiFi in
[i][n][s][t][a][l][l])

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


# -------Setup Script Location:--------

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
echo "------------------------------setup script location-----------------------------"
echo " "
echo "if [ ! -d \"${ENHANCEMENTS}\" ]; then sudo -u $(stat -f '%Su' /dev/console) mkdir ${ENHANCEMENTS} fi"

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir -p "$ENHANCEMENTS"
fi
sleep 1

echo "sudo -u $(stat -f '%Su' /dev/console) open ${ENHANCEMENTS}"
sudo -u $(stat -f '%Su' /dev/console) open "$ENHANCEMENTS"
sleep 1

sleep 1
echo "sudo chown $(stat -f '%Su' /dev/console):wheel ${ENHANCEMENTS}"
sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"

# -------Create Boot-Time Script:--------

echo " "
echo "-----------------------------setup boot-time script-----------------------------"
echo " "
echo "${DISABLE}"
sleep 1

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

echo " "
echo "-----------------------------setup login-time script-----------------------------"
echo " "
echo "${ENABLE}"
sleep 1

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

echo " "
echo " "
echo "----------------------------make scripts executable-----------------------------"
echo " "
sudo chmod +x "$DISABLE"
echo "sudo chmod +x ${DISABLE}"
sleep 1

sudo chmod +x "$ENABLE"
echo "sudo chmod +x ${ENABLE}"
sleep 1

# -------Boot-Time Daemon:--------

echo " "
echo " "
echo "-----------------------------create Boot-Time Daemon----------------------------"
echo " "
echo "${DISABLE_DAEMON}"
sleep 1

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

echo " "
echo " "
echo "----------------------------create User-Login Daemon----------------------------"
echo " "
echo "${ENABLE_DAEMON}"
sleep 1

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

echo " "
echo " "
echo "-------------------------setup ownership & permissions--------------------------"
echo " "
echo "sudo chown root:wheel ${DISABLE_DAEMON}"
sleep 1

sudo chown root:wheel "$DISABLE_DAEMON"

echo "sudo chmod 644 ${DISABLE_DAEMON}"
sleep 1

sudo chmod 644 "$DISABLE_DAEMON"

echo "sudo chown root:wheel ${ENABLE_DAEMON}"
sleep 1

sudo chown root:wheel "$ENABLE_DAEMON"

echo "sudo chmod 644 ${ENABLE_DAEMON}"
sleep 1

sudo chmod 644 "$ENABLE_DAEMON"

# -------DISABLE AND DELETE SPOOFMAC DAEMON (if it exists):--------

if [ -e "$SpoofMAC_DAEMON" ]; then

    echo " "
    echo " "
    echo "----------------------------SpoofMAC Daemon detected----------------------------"
    echo " "
    echo "${SpoofMAC_DAEMON}"
    echo " "
    countdown "00:00:3"
    echo " "

    sleep 1
    echo "---------------------------avoiding SpoofMAC conflicts--------------------------"
    echo " "
    echo "sudo launchctl bootout system ${SpoofMAC_DAEMON}"
    sudo launchctl bootout system ${SpoofMAC_DAEMON}
    sleep 1
    echo "sudo rm ${SpoofMAC_DAEMON}"
    sudo rm ${SpoofMAC_DAEMON}
    echo " "
    countdown "00:00:3"
    echo " "
fi

# -------Load Daemons:--------

echo " "
echo " "
echo "------------------------------load Boot-Time Daemon-----------------------------"
echo " "

echo "sudo launchctl bootstrap system ${DISABLE_DAEMON}"
sudo launchctl bootstrap system "$DISABLE_DAEMON"

sleep 1

echo " "
echo " "
echo "-----------------------------load User-Login Daemon-----------------------------"
echo " "

echo "sudo launchctl bootstrap system ${ENABLE_DAEMON}"
sudo launchctl bootstrap system "$ENABLE_DAEMON"   

sleep 1


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

echo " "
echo "----------------------open Boot-Time Daemon in Text Editor----------------------"
echo " "
echo "open -a TextEdit ${DISABLE_DAEMON}"
open -a TextEdit "$DISABLE_DAEMON"
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
countdown "00:00:5"

echo " "
echo "---------------------open User-Login Daemon in Text Editor----------------------"
echo " "
echo "open -a TextEdit ${ENABLE_DAEMON}"
open -a TextEdit "$ENABLE_DAEMON"
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
countdown "00:00:5"

echo " "
echo "----------------------open Boot-Time Script in Text Editor----------------------"
echo " "
echo "open -a TextEdit ${DISABLE}"
open -a TextEdit "$DISABLE"
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
countdown "00:00:5"

echo " "
echo "----------------------open User-Login Script in Text Editor---------------------"
echo " "
echo "open -a TextEdit ${ENABLE}"
open -a TextEdit "$ENABLE"
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
countdown "00:00:5"

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "From on on, whenever you start your computer, Wi-Fi will be switched off!"
echo "You can always connect manually..."
echo " "
echo "Please have a look at the open Text documents:"
echo "These are the ${bold}Scripts${reset} and the ${bold}LaunchDaemons${reset} that were set up by this script."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "

echo " "
echo " "
echo "                  .:l'                                   .cc."
echo "                 ;kNWk.                                 .xWNO:"
echo "               .dNMWO:                                   ,kNMNk'"
echo "              ;0WMXl.      ;oo'                 .lo:.     .cKWMK:"
echo "             :KMW0;      ,kNMWo                 cNMWO;      'OWMXc"
echo "            ;KMWO'      cXMW0c.                 ;0WMXo.     .kWMXc"
echo "           'OMM0,      lNMWk.                     .xNMNd.     .OMMK,"
echo "           oWMNc      :XMWx.                       .dWMNl      :XMWd."
echo "--------------------------------------------------------------------------------"
echo "-----------------------------------         ------------------------------------"
echo "-----------------------------------  Wi-Fi  ------------------------------------"
echo "-----------------------------------   OFF   ------------------------------------"
echo "-----------------------------------         ------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "           oWMNc      :XMWk.                       .dWMNc      :XMWd."
echo "           '0MM0,      cXMWk'                     .xWMNo.     'OMMK,"
echo "            ;XMMO'      :KMMKc.                  :0WMXl.     .kWMX:"
echo "             :XMW0,      'xNMWo                 cNMWO,      ,OWMXc"
echo "              ;0MMXl.      ,ll'                 .co;.     .lXMMK;"
echo "               .xNMWO;                                   ;OWMNx'"
echo "                 ;kNWk.                                  .dNNO;"
echo "                   ',.                                   .''"
echo "--------------------------------------------------------------------------------"
read -s -n 1 -p  "Press ${bold}[ANY KEY]${reset} to exit this script: "