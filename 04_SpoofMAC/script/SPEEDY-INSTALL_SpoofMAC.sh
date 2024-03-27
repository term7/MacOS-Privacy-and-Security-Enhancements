#!/usr/bin/env bash

#   SPEEDY-INSTALL_SpoofMac.sh
#   term7 / 10.03.2024
#   Original code by feross: https://github.com/feross/spoof
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

# -------Prerequisites:--------

if [ ! -e "/opt/local/bin/port" ]; 
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
  echo "              ------------------------------------------------------"
  echo "              MACPORTS NOT INSTALLED - PLEASE INSTALL MACPORTS FIRST"
  echo "              ------------------------------------------------------"
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
else
  sudo port install npm10

# -------Install Spoof:--------

  sudo npm install spoof -g
fi

# -------Variables:--------

DAEMON_FOLDER=/Library/LaunchDaemons
SPOOFMAC_DAEMON_NAME=info.term7.spoof.mac
SPOOFMAC_DAEMON_FILE=$DAEMON_FOLDER/$SPOOFMAC_DAEMON_NAME.plist

# -------Global Spoof Daemon:--------

sudo tee "$SPOOFMAC_DAEMON_FILE" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${SPOOFMAC_DAEMON_NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/local/bin/node</string>
        <string>/opt/local/bin/spoof</string>
        <string>randomize</string>
        <string>en0</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

sudo chown root:wheel "$SPOOFMAC_DAEMON_FILE"
sudo chmod 644 "$SPOOFMAC_DAEMON_FILE"

# -------Load Daemons:--------

networksetup -setairportpower en0 off
sudo launchctl load "$SPOOFMAC_DAEMON_FILE"

echo " "
echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s