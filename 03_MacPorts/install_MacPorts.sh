#!/usr/bin/env bash

#   install_MacPorts.sh
#   term7 / 10.09.2022
#
#   This script is meant to be educational and a resource for learning for unexperienced users. It has a lot of functionality that may be considered unnecessary from an advanced user's perspective. I.e. it pauses at certain times during the installation and displays a countdown. It echoes all commands to the terminal window and at certain times during the installation it displays informative texts and asks for user input. From an advanced user's perspective who knows exactly what he/she wants, this may be a waste of time. After all it is always possible to read the script - yet we have written this script with users in mind that are not yet used to the command line. After completing this script it is possible to scroll up and read the output of the whole script, including the commands that would otherwise be invisible in the Terminal window.
#

# -------Admin Check:--------

if [ "$EUID" -ne 0 ]; then
    script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
    sudo "$script_path" || (
        echo 'Administrator privileges are required.'
        exit 1
    )
    exit 0
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

# -------Skip Function:--------

function skip {
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
  echo "                                S K I P P I N G";
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
}

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "                       .   ,         ;-.          ."
echo "                       |\ /|         |  )         |"
echo "                       | V | ,-: ,-. |-'  ,-. ;-. |-  ,-."
echo "                       |   | | | |   |    | | |   |   \`-."
echo "                       '   ' \`-\` \`-' '    \`-' '   \`-' \`-'"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:07"

# -------What this Script does:--------

echo " "
echo " "
echo "--------------------------------------------------------------------------------"

echo " "
echo "                                            ${bold}/ MACPORTS / WHAT THIS SCRIPT DOES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "${bold}... THIS INTERACTIVE SCRIPT IS DESIGNED TO INSTALL MACPORTS ON YOUR COMPUTER ...${reset}"
echo " "
echo "The MacPorts Project is an open-source community initiative that enables you to"
echo "compile software that runs natively on Linux (UNIX). We use MacPorts to"
echo "install software and command line tools that are otherwise not available on"
echo "MacOS, but very useful to enhance our ${bold}DIGITAL SECURITY${reset} and our ${bold}ONLINE PRIVACY${reset}."
echo " "
echo "${bold}MACPORTS${reset} requires ${bold}XCODE${reset} and ${bold}XCODE COMMAND LINE TOOLS${reset} to be installed on your"
echo "System. Please install Xcode from the Apple AppStore before you press ${bold}[ENTER]${reset}."
echo "Only then will this script install Xcode Command Line Tools and be able to"
echo "compile MacPorts for you. Alternatively you can dowload Xcode from the Apple"
echo "Developer Website: https://developer.apple.com/xcode/resources/"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                ${bold}THIS SCRIPT HAS BEEN TESTED ON MACOS MONTEREY."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "After you have installed Xcode, press ${bold}[ENTER]${reset} to continue: "

echo " "
echo " "

# -------Abort this script unless Xcode is installed:--------

if [ ! -e "/Applications/Xcode.app" ]; then
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
  echo "       ${bold}------------------------------------------------------------------"
  echo "       XCODE IS NOT INSTALLED ON YOUR SYSTEM - PLEASE INSTALL XCODE FIRST"
  echo "       ------------------------------------------------------------------${reset}"
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
  echo "open /Applications/Xcode.app"
  open /Applications/Xcode.app
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
  echo "         ${bold}---------------------------------------------------------------"
  echo "         INSTALL REQUIRED COMPONENTS - IF XCODE ASKS YOU TO INSTALL THEM"
  echo "         ---------------------------------------------------------------${reset}"
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  read -s -p "Once you are ready, ress ${bold}[ENTER]${reset} to continue: "
fi

# -------Install Xcode Command Line Tools unless they are installed already:--------

if [ -d "/Library/Developer/CommandLineTools" ]; then
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
  echo "            --------------------------------------------------------"
  echo "            XCODE-COMMANDLINE-TOOLS ARE ALREADY INSTALLED - SKIPPING"
  echo "            --------------------------------------------------------"
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
else
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
  echo "sudo xcode-select --install"
  sudo xcode-select --install
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  read -s -p "${bold}INSTALL XCODE COMMANDLINE TOOLS${reset} first, then press ${bold}[ENTER]${reset} to continue: "
fi

if [ ! -d "/Library/Developer/CommandLineTools" ]; then
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
  echo "      ${bold}--------------------------------------------------------------------"
  echo "      XCODE COMMANDLINE TOOLS ARE NOT INSTALLED, PLEASE INSTALL THEM FIRST"
  echo "      --------------------------------------------------------------------${reset}"
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
  echo "--------------------------------------------------------------------------------"
  echo " "
  echo "sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  sleep 1
  echo " "
  echo "sudo xcodebuild -license accept"
  sudo xcodebuild -license accept
  sleep 1
  echo " "
  echo "sudo xcodebuild -runFirstLaunch"
  sudo xcodebuild -runFirstLaunch
  sleep 1
  echo " "
  echo "--------------------------------------------------------------------------------"

fi

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
echo "                   ------------------------------------------";
echo "                   ARE YOU SURE YOU WANT TO INSTALL MACPORTS?";
echo "                   ------------------------------------------";
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
while true
do
read -p "Type ${bold}[install]${reset} to install MACPORTS, or ${bold}[exit]${reset} to abort & press ${bold}[ENTER]${reset}: " MACPORTS
case $MACPORTS in
[i][n][s][t][a][l][l])

if [ -e "/opt/local/bin/port" ]; 
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
  echo "                    ----------------------------------------"
  echo "                    MACPORTS IS ALREADY INSTALLED - SKIPPING"
  echo "                    ----------------------------------------"
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

else

  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"
  echo " "
  echo " "

  # -------Variables:--------

  INSTALLATION_FOLDER=/opt/mports
  GIT_FOLDER=$INSTALLATION_FOLDER/macports-base
  ZSHRC=~/.zshrc

  # -------Current MacPorts Release (stable):--------

  if [ ! -d "$INSTALLATION_FOLDER" ]; then
      mkdir -p /opt/mports
  fi

  echo "if [ ! -d \"${INSTALLATION_FOLDER}\" ]; then mkdir -p /opt/mports; fi"
  sleep 1
  echo "cd ${INSTALLATION_FOLDER}"
  sleep 1
  cd $INSTALLATION_FOLDER
  echo "open ${INSTALLATION_FOLDER}"
  sudo -u $(stat -f '%Su' /dev/console) open $INSTALLATION_FOLDER
  sleep 1
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "git clone https://github.com/macports/macports-base.git"
  echo " "
  git clone https://github.com/macports/macports-base.git
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "cd ${GIT_FOLDER}"
  sleep 1
  cd $GIT_FOLDER
  echo "open -R ${GIT_FOLDER}"
  sudo -u $(stat -f '%Su' /dev/console) open -R $GIT_FOLDER
  sleep 1
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "curl --silent \"https://api.github.com/repos/macports/macports-base/releases/latest\" | grep \'\"tag_name\":\' |  cut -d : -f 2,3 | sed \'s/[ \",]//g\' > .release"
  sleep 1
  curl --silent "https://api.github.com/repos/macports/macports-base/releases/latest" | grep '"tag_name":' |  cut -d : -f 2,3 | sed 's/[ ",]//g' > .release
  echo " "
  echo "git checkout $(cat .release)"
  sleep 1
  git checkout $(cat .release)
  echo " "
  echo "rm .release"
  sleep 1
  rm .release
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "./configure --enable-readline"
  echo " "
  echo " "
  sleep 1
  ./configure --enable-readline
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "make"
  echo " "
  echo " "
  sleep 1
  make
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "make install"
  echo " "
  echo " "
  sleep 1
  sudo make install
  echo " "
  echo " "
  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "make distclean"
  echo " "
  echo " "
  sleep 1
  make distclean
  echo " "
  echo " "

  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "/opt/local/bin/port -v selfupdate"
  echo " "
  echo " "
  sleep 1
  bash -c '/opt/local/bin/port -v selfupdate ; /opt/local/bin/port -puN upgrade outdated'
  echo " "
  echo " "

  echo "--------------------------------------------------------------------------------"

  echo " "
  echo " "
  echo "/opt/local/bin/port -puN upgrade outdated"
  echo " "
  echo " "
  sleep 1
  /opt/local/bin/port -puN upgrade outdated
  echo " "
  echo " "


  # -------Adding MacPorts Executables to Path:--------

  echo "----------------------Adding MacPorts Executables to Path-----------------------"
  echo " "
  echo " "
  echo "touch -a $ZSHRC"
  touch -a $ZSHRC
  sleep 1
  echo "echo \"# MacPorts Executables:\" >> $ZSHRC"
  echo "# MacPorts Executables:" >> $ZSHRC
  sleep 1
  echo "echo \'export PATH=\"/opt/local/bin:/opt/local/sbin:\$PATH\"\' >> $ZSHRC"
  echo 'export PATH="/opt/local/bin:/opt/local/sbin:$PATH"' >> $ZSHRC
  sleep 1
  echo "awk '!/./ || !seen[\$0]++' $ZSHRC > .tmp && mv .tmp $ZSHRC"
  awk '!/./ || !seen[$0]++' $ZSHRC > .tmp && mv .tmp $ZSHRC
  sleep 1
  echo "open -a TextEdit $ZSHRC"
  open  -a TextEdit $ZSHRC
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
  echo "        ${bold}We have opened your ZSH shell configuration file. Please review!${reset}"
  echo "--------------------------------------------------------------------------------"
  echo " "
  read -s -p "Press ${bold}[ENTER]${reset} when you are ready to continue: "
  echo " "
  echo " "
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

ENHANCEMENTS=/Users/Shared/Enhancements
UPDATE_FOLDER=$ENHANCEMENTS/macports_updater
LOG_OUT=$UPDATE_FOLDER/macports.out.log
LOG_ERR=$UPDATE_FOLDER/macports.err.log

UPDATER=$UPDATE_FOLDER/macports_updater.sh

DAEMON_FOLDER=/Library/LaunchDaemons
UPDATER_NAME=info.term7.macports.updater
UPDATER_DAEMON=$DAEMON_FOLDER/$UPDATER_NAME.plist

echo " "
echo "                                                ${bold}/ MACPORTS / AUTOMATIC UPDATES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "This script can configure ${bold}MACPORTS AUTOMATIC UPDATES${reset} for you."
echo " "
echo "If you choose to install ${bold}MACPORTS AUTOMATIC UPDATES${reset}, this script will configure"
echo "a Launch Daemon that runs the required commands once everytime you start your"
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
echo "You can find the ${bold}UPDATE SCRIPT${reset} and all log files in this location:"
echo "${UPDATE_FOLDER}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "Press ${bold}[Y/y]${reset} to set up ${bold}AUTOMATIC UPDATES${reset}, or ${bold}[C/c]${reset} to cancel: " AUTOUP
case $AUTOUP in

# -------Input [Y/y]: setup Macports Automatic Updates:--------

[Yy])


# -------Enhancement Location:--------

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
echo "--------------------------setup MacPorts update folder--------------------------"
echo " "

echo "open /Users/Shared"
sudo -u $(stat -f '%Su' /dev/console) open /Users/Shared
sleep 1
echo " "

echo "if [ ! -d \"${ENHANCEMENTS}\" ]; then mkdir ${ENHANCEMENTS}; fi"
sleep 1

if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir $ENHANCEMENTS
fi

echo "open -R ${ENHANCEMENTS}"
sudo -u $(stat -f '%Su' /dev/console) open -R $ENHANCEMENTS
sleep 1
echo " "

echo "if [ ! -d \"${UPDATE_FOLDER}\" ]; then sudo mkdir ${UPDATE_FOLDER}; fi"
sleep 1

if [ ! -d "$UPDATE_FOLDER" ]; then
  sudo mkdir $UPDATE_FOLDER
fi

echo "open -R ${UPDATE_FOLDER}"
sudo -u $(stat -f '%Su' /dev/console) open -R $UPDATE_FOLDER
sleep 1
echo " "
echo " "

# -------Setup Log File Locations:--------

echo "----------------------------setup Log File Locations----------------------------"
echo " "
echo " "
echo "sudo touch "$LOG_OUT""
sudo touch "$LOG_OUT"
sleep 1
echo "sudo touch "$LOG_ERR""
sudo touch "$LOG_ERR"
sleep 1
echo " "
echo " "

# -------Create Update Script:--------

echo "------------------------------create Update Script------------------------------"
echo " "
echo " "
echo "$UPDATER"

sudo tee "$UPDATER" << EOF > /dev/null
#!/bin/bash
date +'%d/%m/%Y %H:%M:%S' > $LOG_OUT
echo ' ' >> $LOG_OUT
date +'%d/%m/%Y %H:%M:%S' > $LOG_ERR
echo ' ' >> $LOG_ERR
bash -c '/opt/local/bin/port selfupdate ; /opt/local/bin/port -puN upgrade outdated ; /opt/local/bin/port uninstall inactive ; /opt/local/bin/port uninstall leaves'
EOF

# -------Ownership, Permissions:--------

echo " "
echo " "
echo "-------------------------setup ownership & permissions--------------------------"
echo " "
echo "sudo chown root:wheel ${UPDATER}"
sudo chown root:wheel "$UPDATER"
sleep 1

echo "sudo chown $(stat -f '%Su' /dev/console):admin ${LOG_OUT} ${LOG_ERR}"
sudo chown $(stat -f '%Su' /dev/console):admin "$LOG_OUT" "$LOG_ERR"
sleep 1

echo "sudo chmod 744 ${UPDATER}"
sudo chmod 744 "$UPDATER"
sleep 1

echo "sudo chmod 644 ${LOG_OUT} ${LOG_ERR}"
sudo chmod 644 "$LOG_OUT" "$LOG_ERR"
sleep 1

echo " "
echo " "
echo "---------------------------open Script in Text Editor---------------------------"
echo " "
echo "open -a TextEdit ${UPDATER}"
open -a TextEdit "$UPDATER"
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
echo "            ${bold}We have opened the MacPorts Update Script. Please review!${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready to continue: "
echo " "
echo " "

# -------Global Macports Update Daemon:--------

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
echo "${UPDATER_DAEMON}"
sleep 1


sudo tee "$UPDATER_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${UPDATER_NAME}</string>
  <key>LaunchOnlyOnce</key>
  <true/>
  <key>ProgramArguments</key>
  <array>
    <string>${UPDATER}</string>
  </array>
  <key>StandardOutPath</key>
  <string>${LOG_OUT}</string>
  <key>StandardErrorPath</key>
  <string>${LOG_ERR}</string>
  <key>StartInterval</key>
  <integer>300</integer>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

echo " "
echo " "
echo "-------------------------setup ownership & permissions--------------------------"
echo " "
echo "sudo chown root:wheel ${UPDATER_DAEMON}"
sleep 1

sudo chown root:wheel "$UPDATER_DAEMON"

echo "sudo chmod 644 ${UPDATER_DAEMON}"
sleep 1

sudo chmod 644 "$UPDATER_DAEMON"

# -------Load MacPorts updater daemon:--------

echo " "
echo " "
echo "--------------------------load MacPorts updater daemon--------------------------"
echo " "

echo "sudo launchctl load ${UPDATER_DAEMON}"
sleep 1

sudo launchctl load "$UPDATER_DAEMON"

echo " "
echo " "
echo "------------------------open LaunchDaemon in Text Editor------------------------"
echo " "
echo "open -a TextEdit ${UPDATER_DAEMON}"
open -a TextEdit "$UPDATER_DAEMON"
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
echo "            ${bold}We have opened the MacPorts LaunchDaemon. Please review!${reset}"
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
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "                        ___           __        ___  __ "
echo "                       |__  | |\\ | | /__\` |__| |__  |  \\"
echo "                       |    | | \\| | .__/ |  | |___ |__/"
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
read -s -n 1 -p  "Press ${bold}[ANY KEY]${reset} to exit this script: "
