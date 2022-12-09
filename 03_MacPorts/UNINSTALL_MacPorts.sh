#!/usr/bin/env bash

#   UNINSTALL_MacPorts.sh
#   term7 / 11.09.2022

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

# -------Uninstall MacPorts:--------

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
echo "                   -----------------------------------------";
echo "                   ARE YOU SURE YOU WANT TO DELETE MACPORTS?";
echo "                   -----------------------------------------";
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
read -p "Type ${bold}[delete]${reset} to remove ${bold}MACPORTS${reset}, or ${bold}[exit]${reset} to abort and press ${bold}[ENTER]${reset}: " DEL
case $DEL in
[d][e][l][e][t][e])

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

# -------delete installed Ports:--------

echo " "
echo "-----------------------------delete installed Ports-----------------------------"
echo " "
echo "sudo port -fp uninstall installed"
sudo port -fp uninstall installed
sleep 1

# -------delete MacPorts User & MacPorts Group:--------

echo " "
echo "---------------------delete MacPorts User & MacPorts Group----------------------"
echo " "
echo "sudo dscl . -delete /Users/macports"
sudo dscl . -delete /Users/macports
sleep 1
echo "sudo dscl . -delete /Groups/macports"
sudo dscl . -delete /Groups/macports
sleep 1

# -------change ownership:--------

echo " "
echo "--------------------------------change ownership--------------------------------"
echo " "
echo "sudo chown -R root:admin /opt/local"
sudo chown -R root:admin /opt/local
sleep 1

# -------delete all folders, LaunchDaemons and other traces:--------

echo " "
echo "---------------delete all folders, LaunchDaemons and other traces---------------"
echo " "

echo "sudo rm -rf \\"
echo "  /opt/local \\"
echo "  /opt/mports \\"
echo "  /Applications/DarwinPorts \\"
echo "  /Applications/MacPorts \\"
echo "  /Users/Shared/Enhancements/macports_updater \\"
echo "  /Library/LaunchDaemons/org.macports.* \\"
echo "  /Library/LaunchDaemons/info.term7.macports.updater.* \\"
echo "  /Library/Receipts/DarwinPorts*.pkg \\"
echo "  /Library/Receipts/MacPorts*.pkg \\"
echo "  /Library/StartupItems/DarwinPortsStartup \\"
echo "  /Library/Tcl/darwinports1.0 \\"
echo "  /Library/Tcl/macports1.0 \\"
echo "  ~/.macports"

sudo rm -rf \
  /opt/local \
  /opt/mports \
  /Applications/DarwinPorts \
  /Applications/MacPorts \
  /Users/Shared/Enhancements/macports_updater \
  /Library/LaunchDaemons/org.macports.* \
  /Library/LaunchDaemons/info.term7.macports.updater.* \
  /Library/Receipts/DarwinPorts*.pkg \
  /Library/Receipts/MacPorts*.pkg \
  /Library/StartupItems/DarwinPortsStartup \
  /Library/Tcl/darwinports1.0 \
  /Library/Tcl/macports1.0 \
  ~/.macports

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"

break;;

# -------Input [exit: Abort:--------

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
echo "                                F I N I S H E D";
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
read -s -n 1 -p  "Press ${bold}[ANY KEY]${reset} to exit this script: "
