#!/usr/bin/env bash

#   INSTALL_SpoofMAC.sh
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
echo "interfaces (i.e. Ethernet, Wi-Fi & Bluetooth). SpoofMAC is an open source tool"
echo "that makes it easy for you to change the MAC addresses of your computer via the"
echo "Command Line, so that it becomes impossible to track and fingerprint you via"
echo "your device's MAC addresses."
echo " "
echo "This simple script uses MacPorts to install npm, before it proceeds to install"
echo "SpoofMAC. Further, if you choose so, it sets up a Launch Daemon that randomizes"
echo "randomize the MAC address of your Ethernet and Wi-Fi Cards whenever you reboot"
echo "your computer, making it impossible for other devices and network operators to"
echo "discover your identity via its MAC address when you connect to the internet."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                ${bold}THIS SCRIPT HAS BEEN TESTED ON MACOS SONOMA."${reset}
echo "               ${bold}MAKE SURE MACPORTS IS INSTALLED ON YOUR SYSTEM!"${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -p "Type ${bold}[install]${reset} to install SpoofMAC, or ${bold}[exit]${reset} to abort & press ${bold}[ENTER]${reset}: " SpoofMAC
case $SpoofMAC in
[i][n][s][t][a][l][l])

# -------Abort this script unless MacPorts is installed:--------

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
  countdown "00:00:7"
  exit;
else


  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  echo " "

# -------Install NPM and Spoof:--------

  sudo port install npm10
  echo "sudo port install npm10"
  echo " "
  echo " "
  sudo npm install spoof -g
  echo "sudo port install spoof -g"

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


# -------Run Spoof:--------

networksetup -setairportpower en0 off
echo "networksetup -setairportpower en0 off"
echo " "
echo " "
sudo spoof randomize en0
echo "sudo spoof randomize en0"
echo "spoof list"
echo "--------------------------------------------------------------------------------"
echo " "

spoof list
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Your Wi-Fi device should have a changed MAC addresses now! To list all available"
echo "network devices and their respective MAC addresses, enter this command into a"
echo "Terminal Window: spoof list"
echo " "
echo "To list all available commands type this command: spoof --help"
echo " "
echo "                                             -> **MORE INFO** 04_SpoofMAC/README.md"
echo "--------------------------------------------------------------------------------"
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

# -------SpoofMAC LaunchDaemon:--------



# -------Variables:--------

DAEMON_FOLDER=/Library/LaunchDaemons
SpoofMAC_DAEMON_NAME=info.term7.spoof.mac
SpoofMAC_DAEMON_FILE=$DAEMON_FOLDER/$SpoofMAC_DAEMON_NAME.plist


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

networksetup -setairportpower en0 off
echo "networksetup -setairportpower en0 off"

echo "sudo launchctl load ${SpoofMAC_DAEMON_FILE}"
sudo launchctl load "$SpoofMAC_DAEMON_FILE"

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