#!/usr/bin/env bash

#   SPEEDY-INSTALL_MacOS-Privacy-and-Security-Settings.sh
#   term7 / 20.08.2022
#
#   RESOURCES:
#
#   Special thanks to https://privacy.sexy/ and https://github.com/drduh/macOS-Security-and-Privacy-Guide
#   Without these two resources, this script would not exist.
#
#
#   MIT License
#   Copyright (c) 2022 term7
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

# -------Apple Remote Events:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To disable ${bold}APPLE REMOTE EVENTS${reset} press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " ARI
case $ARI in

# -------Input [Y/y]: Disable Apple Remote Events:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
echo "   ${bold}TURNING REMOTE APPLEEVENTS ON OR OFF REQUIRES FULL DISK ACCESS PRIVILEGES${reset}"
echo " "
echo "                   ${bold}HAVE YOU ALREADY GRANTED FULL DISK ACCESS?${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "If yes, press ${bold}[Y/y]${reset} to continue. Otherwise press ${bold}[C/c]${reset} to exit this script.
It will then open your System Settings. Manually ${bold}GRANT FULL DISK ACCESS${reset} to your
Terminal, restart this script and skip through until you are here again: " manual

case $manual in

# -------Input [Y/y]: Disable Apple Remote Events:--------
[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo systemsetup -setremoteappleevents off
break;;

# -------Input [C/c]: Abort and open Settings (Full Disk Access):--------

[Cc])
echo " "
echo " "
echo "------------------------open full disk access preferences-----------------------"
echo " "
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
sleep 5
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo " "
echo "                  Wait until Full Disk Access Preferences open:"
echo " "
echo " Click '${bold}+${reset}' ..."
echo " "
echo "      -> in the pop-up Finder Window, select ${bold}Applications${reset}, and scroll down"
echo "         to ${bold}Utilities${reset} ..."
echo "   Click on ${bold}Utilities${reset} to open it, select ${bold}Terminal${reset} and click ${bold}Open${reset}."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Before you click ${bold}QUIT & REOPEN${reset}, press ${bold}[ENTER]${reset} to exit this script: "

exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Apple Remote Management Service:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To deactivate ${bold}REMOTE MANAGEMENT SERVICE${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " ARD
case $ARD in

# -------Input [Y/y]: Deactivate Apple Remote Management Service:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# -------Remove Apple Remote Desktop Settings:--------

sudo rm -rf /var/db/RemoteManagement
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sudo rm -r /Library/Application\ Support/Apple/Remote\ Desktop/
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done


# -------Siri:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To disable ${bold}SIRI${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " SIRI
case $SIRI in

# -------Input [Y/y]: Disable Siri:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable "system/com.apple.assistantd"
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable "system/com.apple.Siri.agent"
echo " "
echo " "
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi
echo " "
echo " "
read -s -p "Review the output of this command and press ${bold}[ENTER]${reset} when you are ready: "

echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
echo "Siri and assistantd (helper process) are baked into your Mac's core operating"
echo "system. To completely disable Siri and assistantd system-wide to prevent them"
echo "from re-spawning altogether, you have to disable your Mac's System Integrity"
echo "Protection (SIP) - and keep it disabled, otherwise your changes will be lost."
echo " "
echo "--------------------------------------------------------------------------------"
echo "       ${bold}!!! DISABELING SYSTEM INTECRITY PROTECTION IS A SECURITY RISK !!!${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
echo "Visit this link to learn how to disable SIP:"
echo "https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection"
echo " "
echo "Then run this part of the Script again."
echo " "
echo "Alternatively run our script ${bold}kill-siri.sh${reset} to configure a KillSwitch..."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Now press ${bold}[ENTER]${reset} to ${bold}HIDE SIRI${reset} and to ${bold}OPT-OUT${reset} of Siri data collection: "

# -------Input [ENTER]: Change Siri Settings:--------

echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Speech.prefPane
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
read -s -p "Please ${bold}REVIEW YOUR SIRI PREFERENCES${reset} and press ${bold}[ENTER]${reset} when you are ready: "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Spotlight Search:--------

while true
do
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To open ${bold}SPOTLIGHT PREFERENCES${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SPOT1
case $SPOT1 in

# -------Input [Y/y]: Disable Spotlight indexing:--------

[Yy])
echo " "
echo " "
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Spotlight.prefPane
echo "--------------------------------------------------------------------------------"
echo " "
echo "  Wait until System Preferences open..."
echo "  Then deselect all categories you don't want to be searchable with Spotlight."
echo " "
echo "              ${bold}DON'T FORGET TO DISABLE SIRI SEARCH SUGGESTIONS${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Spotlight Indexing:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}DISABLE SPOTLIGHT INDEXING${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SPOT2
case $SPOT2 in

# -------Input [Y/y]: Disable Spotlight indexing:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo mdutil -sav -i off -d /
echo " "
read -s -p "Review the output of this command and press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Internet Based Spell Correction:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To disable ${bold}INTERNET BASED SPELL CORRECTION${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " IBSC
case $IBSC in

# -------Input [Y/y]: Disable internet based spell correction:--------

[Yy])
echo " "
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Analytics and Targeted Advertisement:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To disable ${bold}APPLE ADVERTISING AND ANALYTICS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " LOC
case $LOC in

# -------Input [Y/y]: Disable Apple Advertising and Analytics:--------

[Yy])
echo " "
echo " "
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"
sleep 5
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences open:"
echo " "
echo "                            ${bold}UNTICK 'PERSONALISED ADS'${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
echo " "
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences update:"
echo " "
echo "                       UNTICK 'SHARE MAC ANALYTICS'${reset}"
echo "                       UNTICK 'SHARE WITH APP DEVELOPERS'${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# ------- Location Services:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To disable ${bold}LOCATION SERVICES${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " LOC
case $LOC in

# -------Input [Y/y]: Location Services:--------

[Yy])
echo " "
echo " "
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences open:"
echo " "
echo "             ${bold}REMOVE THE HOOK IN FRONT OF 'ENABLE LOCATION SERVICES'${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------iCloud:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To open ${bold}iCLoud and AppleID Preferences${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " CLOUD
case $CLOUD in

# -------Input [Y/y]: Open Apple ID Preferences:--------

[Yy])
echo " "
echo " "
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/AppleIDPrefPane.prefPane
echo "--------------------------------------------------------------------------------"
echo " "
echo "  Wait until System Preferences open..."
echo "  Then, provided you don't want to use iCLoud, disable all iCloud options."
echo " "
echo "                      ${bold}THEN SIGN OUT OF YOUR APPLE ACCOUNT${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------iCloud Documents:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}STOP STORING DOCUMENTS TO ICLOUD${reset} by default, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " DRIVE
case $DRIVE in

# -------Input [Y/y]: Do not store documents to iCloud Drive by default:--------

[Yy])
echo " "
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Airdrop File Sharing:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}DISABLE AIRDROP${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " AIR
case $AIR in

# -------Input [Y/y]: Disable AirDrop file sharing:--------

[Yy])
echo " "
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Recent Items in Dock:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}NOT SHOW RECENT ITEMS IN DOCK${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " NSRID
case $NSRID in

# -------Input [Y/y]: Do not show recent items in Dock:--------

[Yy])
echo " "
sudo -u $(stat -f '%Su' /dev/console) defaults write com.apple.dock show-recents -bool false && \
sudo -u $(stat -f '%Su' /dev/console) killall Dock
osascript -e 'quit app "System Preferences"'
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Dock.prefPane
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Captive Portal:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}DISABLE CAPTIVE PORTAL${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " PORT
case $PORT in

# -------Input [Y/y]: Disable Captive Portal:--------

[Yy])
echo " "
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done


# -------Application Layer Firewall:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}TURN ON YOUR FIREWALL${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " FIRE
case $FIRE in

# -------Input [Y/y]: Turn on Firewall:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true
osascript -e 'quit app "System Preferences"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Firewall"
sleep 5
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                   ... Wait until Firewall Settings open ..."
echo " "
echo "                      ${bold}PLEASE REVIEW YOUR FIREWALL SETTINGS${reset}."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Guest Accounts:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}DISABLE GUEST ACCOUNTS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " GUEST
case $GUEST in

# -------Input [Y/y]: Disable Guest Accouts:--------

[Yy])
echo " "
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Accounts.prefPane
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Unauthorized Connections:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}PREVENT UNAUTHORIZED CONNECTIONS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " CON
case $CON in

# -------Input [Y/y]: Prevent Unauthorized Connections:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo 'yes' | sudo systemsetup -setremotelogin off
sudo launchctl disable 'system/com.apple.tftpd'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
sudo launchctl disable system/com.apple.telnetd
osascript -e 'quit app "System Preferences"'
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/SharingPref.prefPane
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Printer Sharing:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}DISABLE PRINTER SHARING${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " CON
case $CON in

# -------Input [Y/y]: Disable Printer Sharing:--------

[Yy])
echo " "
cupsctl --no-share-printers
cupsctl --no-remote-any
cupsctl --no-remote-admin
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Screen Saver Session Lock:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}ENABLE SCREEN SAVER SESSION LOCK${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SSS
case $SSS in

# -------Input [Y/y]: Enable Screen Saver Session Lock:--------

[Yy])
echo " "
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5
osascript -e 'quit app "System Preferences"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?General"
sleep 5
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System & Privacy Settings open:"
echo " "
echo "Tick the box [ ] next to ${bold}Require password${reset} and select either ${bold}immideately${reset} or"
echo "${bold}5 seconds${reset}."
echo "Click ${bold}Advanced${reset} and set ${bold}log out after [  ] minutes of inactivity${reset} to 10 or less."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "
echo " "
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Firmware Password Pt.1:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}SETUP FIRMWARE PASSWORD${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " FIRM
case $FIRM in

# -------Input [Y/y]: Setup Firmware Password:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo firmwarepasswd -setpasswd -setmode command
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------Firmware Password Pt.2:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}PREVENT FIRMWARE PASSWORD RESETS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel and ${bold}REBOOT${reset} first: " FIRMRE
case $FIRMRE in

# -------Input [Y/y]: Prevent Firmware Password Resets:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo firmwarepasswd -disable-reset-capability
break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------FileVault:--------

while true
do
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "To ${bold}ENABLE FILEVAULT${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " VAULT
case $VAULT in

# -------Input [Y/y]: Enable Filevault:--------

[Yy])
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?FDE"
sudo fdesetup enable

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
echo " "
break;;

# -------Input [C/c]: Abort:--------

[Cc])
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
sleep 5
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "${bold}ALWAYS REVIEW YOUR SETTINGS AFTER RUNNING THIS SCRIPT: THIS SCRIPT MAY STOP"${reset}
echo "${bold}WORKING THE WAY IT SHOULD AFTER UPDATES AND MAJOR VERSION UPGRADES."${reset}
echo "${bold}THIS SCRIPT HAS BEEN TESTED ON MACOS MONTEREY."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "           ${bold}DON'T FORGET TO REVOKE FULL DISK ACCESS FOR YOUR TERMINAL"${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences open:"
echo " "
echo "                 Deselect and remove Terminal.app from the list"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Before you click ${bold}QUIT & REOPEN${reset}, press ${bold}[ANY KEY]${reset} to exit this script: "
read -n 1 -s
