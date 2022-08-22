#!/usr/bin/env bash

#   MacOS-Privacy-and-Security-Settings.sh
#   term7 / 11.08.2022
#
#   This script is meant to be educational and a resource for learning for unexperienced users. It has a lot of functionality that may be considered unnecessary from an advanced user's perspective. I.e. it pauses at certain times during the installation and displays a countdown. It echoes all commands to the terminal window and at certain times during the installation it displays informative texts and asks for user input. From an advanced user's perspective who knows exactly what he/she wants, this may be a waste of time - yet we have written this script with users in mind that are not yet used to the command line.
#
#
#   RESOURCES:
#
#   Special thanks to https://privacy.sexy/ and https://github.com/drduh/macOS-Security-and-Privacy-Guide#firewall
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

lil=$(tput setaf 255,000,255)
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
echo "                      _/      _/    _/_/      _/_/_/        _/_/      _/_/_/"
echo "                     _/_/  _/_/  _/    _/  _/            _/    _/  _/"
echo "                    _/  _/  _/  _/_/_/_/  _/            _/    _/    _/_/"
echo "                   _/      _/  _/    _/  _/            _/    _/        _/"
echo "                  _/      _/  _/    _/    _/_/_/        _/_/    _/_/_/"
echo " "
echo "                    +-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+"
echo "                   |P|R|I|V|A|C|Y| |A|N|D| |S|E|C|U|R|I|T|Y|"
echo "                  +-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+-+-+"
echo " "
echo "          _/_/_/    _/_/_/  _/_/_/    _/_/_/  _/_/_/    _/_/_/_/_/"
echo "       _/        _/        _/    _/    _/    _/    _/      _/"
echo "        _/_/    _/        _/_/_/      _/    _/_/_/        _/"
echo "           _/  _/        _/    _/    _/    _/            _/"
echo "    _/_/_/      _/_/_/  _/    _/  _/_/_/  _/            _/"
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"


# -------What this Script does:--------

echo " "
echo "                 ${bold}/ MACOS PRIVACY AND SECURITY SETTINGS / WHAT THIS SCRIPT DOES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "${bold}... THIS IS AN INTERACTIVE SCRIPT ...${reset}"
echo " "
echo "It is designed to adjust your Mac's Privacy and Security Settings: For each"
echo "potential change, it will ask you wether you want to proceed ${bold}[Y/y]${reset} or not ${bold}[N/n]${reset}."
echo " "
echo "If you press ${bold}[Y/y]${reset} and hit ${bold}[ENTER]${reset}, it will execute the required command,"
echo "if you press ${bold}[N/n]${reset} and hit ${bold}[ENTER]${reset}, it will skip this step and proceed to the"
echo "next option. You can always press ${bold}[CONTROL] + [C]${reset} to exit this script."
echo " "
echo "Every command executed by this script will be shown in your Terminal. If manual"
echo "actions are required, i.e. changing your System Settings, this script will open"
echo "the required System Settings for you and instruct you what to do next."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                THIS SCRIPT HAS BEEN TESTED ON MACOS MONTEREY."${reset}
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

echo " "                                                            
echo " "                                                            
echo " "                                                            
echo " "                                                            
echo " "                                                            
echo " "                                                            
echo "             _/_/_/              _/"
echo "            _/    _/  _/  _/_/      _/      _/    _/_/_/    _/_/_/  _/    _/"
echo "           _/_/_/    _/_/      _/  _/      _/  _/    _/  _/        _/    _/"
echo "          _/        _/        _/    _/  _/    _/    _/  _/        _/    _/"
echo "         _/        _/        _/      _/        _/_/_/    _/_/_/    _/_/_/"
echo "                                                                   _/"
echo "                                                              _/_/"
echo "        _/_/_/              _/      _/      _/"
echo "     _/          _/_/    _/_/_/_/_/_/_/_/      _/_/_/      _/_/_/    _/_/_/"
echo "      _/_/    _/_/_/_/    _/      _/      _/  _/    _/  _/    _/  _/_/"
echo "         _/  _/          _/      _/      _/  _/    _/  _/    _/      _/_/"
echo "  _/_/_/      _/_/_/      _/_/    _/_/  _/  _/    _/    _/_/_/  _/_/_/"
echo "                                                           _/"
echo "                                                      _/_/"
echo " "
echo " "
echo " "                                                        
echo " "
countdown "00:00:7"


# -------About Apple Remote Events:--------

echo " "
echo " "
echo "                                   ${bold}/ MACOS PRIVACY / ABOUT APPLE REMOTE EVENTS /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Your Mac can accept Apple events from apps running on other computers. An Apple"
echo "event is a task being performed on a Mac, such as 'open this document'."
echo " "
echo "With remote Apple events turned on, an AppleScript program running on another"
echo "Mac can interact with your Mac. For example, the program could open and print a"
echo "document that is located on your Mac. Your Mac can be discovered by other Apple"
echo "devices when Apple Remote Events are enabled."
echo " "
echo "Turning off Apple Remote Events through this script will only take effect after"
echo "the next reboot!"
echo " "
echo "Do you want to disable Apple Remote Events?"
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To disable ${bold}APPLE REMOTE EVENTS${reset} press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " ARI
case $ARI in

# -------Input [Y/y]: Disable Apple Remote Events:--------

[Yy])

echo " "
echo " "
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "   ${bold}TURNING REMOTE APPLEEVENTS ON OR OFF REQUIRES FULL DISK ACCESS PRIVILEGES${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Your Terminal requires Full Disk Access to run this part of the script. Granting"
echo "it will terminate all current Terminal processes including this script."
echo "Don't forget to revoke Full Disk Access again once you are finished."
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                   ${bold}HAVE YOU ALREADY GRANTED FULL DISK ACCESS?${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
read -s -p "If yes, press ${bold}[Y/y]${reset} to continue. Otherwise press ${bold}[C/c]${reset} to exit this script.
It will then open your System Settings. Manually ${bold}GRANT FULL DISK ACCESS${reset} to your
Terminal, restart this script and skip through until you are here again: " manual

case $manual in

# -------Input [Y/y]: Disable Apple Remote Events:--------
[Yy])

echo " "
echo " "
echo "---------------------------disable Apple Remote Events--------------------------"
echo " "
echo "sudo systemsetup -setremoteappleevents off"
sudo systemsetup -setremoteappleevents off
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [C/c]: Abort:--------

[Cc])

echo " "
echo " "
echo "------------------------open full disk access preferences-----------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
sleep 5
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                  Wait until Full Disk Access Preferences open."
echo " "
echo " "
echo " Click '${bold}+${reset}' ..."
echo " "
echo "      -> in the pop-up Finder Window, select ${bold}Applications${reset}, and scroll down"
echo "         to ${bold}Utilities${reset} ..."
echo "   Click on ${bold}Utilities${reset} to open it, select ${bold}Terminal${reset} and click ${bold}Open${reset}."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
echo " "
read -s -p "Before you click ${bold}QUIT & REOPEN${reset}, press ${bold}[ENTER]${reset} to exit this script: "

abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
break;;

# -------Input [C/c]: Abort and open Settings (Full Disk Access):--------

[Cc])
abort
exit;;

# -------Input [*]: Wrong Input:--------

*)
invalid
;;

esac
done

# -------About Apple Remote Management Service:--------

echo " "
echo "                        ${bold}/ MACOS PRIVACY / ABOUT APPLE REMOTE MANAGMENT SERVICE /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "MacOS Remote Management allows other users to access your computer using Apple "
echo "Remote Desktop (ARD). The same function is used to allow remote access to your"
echo "Mac via SSH, which enables code execution and to run scripts in the background."
echo " "
echo "ARD is proprietary software. You have to purchase it on the Apple App Store in"
echo "order to use it. However, if it is enabled on your computer someone with a"
echo "license can access it if you allow it. This is why some ARD Settings may be"
echo "present on your Mac, even if you never installed ARD. This script will"
echo "deactivate MacOS Remote Management and attempt to remove all ARD settings, even"
echo "if they do not exist on your system."
echo " "
echo "Do you want to disable the Remote Managment Service, remove all related Apple"
echo "Remote Desktop Settings at the same time and open the corresponding System"
echo "Settings?"
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To deactivate ${bold}REMOTE MANAGEMENT SERVICE${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " ARD
case $ARD in

# -------Input [Y/y]: Deactivate Apple Remote Management Service:--------

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
echo "----------------------deactivate remote management service----------------------"
echo " "
echo "sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "

# -------Remove Apple Remote Desktop Settings:--------

echo "----------------------remove Apple Remote Desktop settings----------------------"
echo " "
echo "sudo rm -rf /var/db/RemoteManagement"
sudo rm -rf /var/db/RemoteManagement
sleep 1
echo "sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist"
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
sleep 1
echo "defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist"
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sleep 1
echo "sudo rm -r /Library/Application\ Support/Apple/Remote\ Desktop/"
sudo rm -r /Library/Application\ Support/Apple/Remote\ Desktop/
sleep 1
echo "rm -r ~/Library/Application\ Support/Remote\ Desktop/"
rm -r ~/Library/Application\ Support/Remote\ Desktop/
sleep 1
echo "rm -r ~/Library/Containers/com.apple.RemoteDesktop"
rm -r ~/Library/Containers/com.apple.RemoteDesktop
sleep 1
echo " "
echo " "
read -s -p "Review the output of this command and press ${bold}[ENTER]${reset} when you are ready: "

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Siri Pt.1:--------

echo " "
echo "                                                  ${bold}/ MACOS PRIVACY / ABOUT SIRI /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Siri is Apple's voice control system."
echo " "
echo "According to Apple, voice commands are processed on Apple servers, but they"
echo "aren't associated with the user's Apple ID. However, this still means that voice"
echo "commands do not stay on your computer, but are instead transferred to an"
echo "external server to be processed."
echo " "
echo "In the past, Apple has been caught sending voice assistant recordings to"
echo "contractors, who listened to snippets of your requests and conversations,"
echo "without telling anyone. Apple states that they have stopped this practice now."
echo "Today, Siri is improved through algorithms and machine learning."
echo " "
echo "Some data that is used to improve Siri, like the music you listen to and"
echo "searches, are still sent to Apple's servers by default. All data that is sent to"
echo "Apple is encrypted and anonymized. It is not associated with your Apple ID."
echo "There is no indication that Apple monetizes your data (by selling it)."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

# -------About Siri Pt.2:--------

echo " "
echo "                                                  ${bold}/ MACOS PRIVACY / ABOUT SIRI /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "If Location Services is enabled, your device's exact location may be sent to"
echo "Apple too - in order to improve Siri results. All that data, however, is"
echo "nevertheless  associated with a unique device identifier. Apple does save user"
echo "voice data for a six-month period to improve your Siri's voice recognition."
echo "After that, Apple saves some recordings without device or user identifier."
echo " "
echo "It is possible to opt-out of this data collection by Siri. If you don't opt-out,"
echo "data collection happens automatically."
echo " "
echo "Do you want to disable Siri (and assistantd - which is a helper process) now?"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To disable ${bold}SIRI${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " SIRI
case $SIRI in

# -------Input [Y/y]: Disable Siri:--------

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
echo "-------------------------------disable 'Ask Siri'-------------------------------"
echo " "
echo "defaults write com.apple.assistant.support 'Assistant Enabled' -bool false"
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
sleep 1
echo " "
echo " "
echo "---------------------------disable Siri voice feedback--------------------------"
echo " "
echo "defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3"
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
sleep 1
echo " "
echo " "
echo "------------------disable Siri services 'Siri' and 'assistantd'-----------------"
echo " "
echo 'launchctl disable "user/$UID/com.apple.assistantd"'
launchctl disable "user/$UID/com.apple.assistantd"
sleep 1
echo 'launchctl disable "gui/$UID/com.apple.assistantd"'
launchctl disable "gui/$UID/com.apple.assistantd"
sleep 1
echo 'sudo launchctl disable "system/com.apple.assistantd"'
sudo launchctl disable "system/com.apple.assistantd"
sleep 1
echo 'launchctl disable "user/$UID/com.apple.Siri.agent"'
launchctl disable "user/$UID/com.apple.Siri.agent"
sleep 1
echo 'launchctl disable "gui/$UID/com.apple.Siri.agent"'
launchctl disable "gui/$UID/com.apple.Siri.agent"
sleep 1
echo 'sudo launchctl disable "system/com.apple.Siri.agent"'
sudo launchctl disable "system/com.apple.Siri.agent"
sleep 1
echo " "
echo " "
echo " "
echo " "
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
    >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi
echo " "
read -s -p "Review the output of this command and press ${bold}[ENTER]${reset} when you are ready: "

echo " "
echo " "
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo " "
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
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

echo " "
echo " "
echo "                                                               ${bold}/ PLEASE NOTICE /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "An alternative to disabeling SIP to stop Siri and assistantd from re-spawning"
echo "can be a custom system service, that monitors whenever Siri and/or assitantd"
echo "become activate and that terminates the respective processes immideately."
echo " "
echo "--------------------------------------------------------------------------------"
echo "             WE HAVE WRITTEN AN ADDITIONAL SCRIPT THAT CAN DO THAT${reset}"
echo "--------------------------------------------------------------------------------"
echo " "
echo "If you want to terminate all processes related to Siri and assistantd as soon as"
echo "they start on your Mac, run our ${bold}KILL SIRI${reset} script to configure the required"
echo "${bold}LaunchAgent${reset} and the required ${bold}LauchDaemon${reset}."
echo " "
echo "Our installation script is called: kill-siri.sh"
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Now press ${bold}[ENTER]${reset} to ${bold}HIDE SIRI${reset} and to ${bold}OPT-OUT${reset} of Siri data collection.
This script will also open ${bold}SIRI SPEECH PREFERENCES${reset} for you: "

# -------Input [ENTER]: Change Siri Settings:--------

echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------open Siri speech preferences--------------------------"
echo " "
echo "sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Speech.prefPane"
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Speech.prefPane
sleep 1
echo " "
echo " "
echo "------------------disable 'Do you want to enable Siri?' pop-up------------------"
echo " "
echo "defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True"
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
sleep 1
echo " "
echo " "
echo "-----------------------------hide Siri from Menu Bar----------------------------"
echo " "
echo "defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0"
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
sleep 1
echo " "
echo " "
echo "---------------------------hide Siri from Status Menu---------------------------"
echo " "
echo "defaults write com.apple.Siri 'StatusMenuVisible' -bool false"
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
sleep 1
echo "defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true"
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
sleep 1
echo " "
echo " "
echo "------------------------opt-out from Siri data collection-----------------------"
echo " "
echo "defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2"
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
sleep 1
echo " "
echo " "
echo " "
echo " "
read -s -p "Please ${bold}REVIEW YOUR SIRI PREFERENCES${reset} and press ${bold}[ENTER]${reset} when you are ready: "

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Spotlight Search:--------

echo " "
echo "                                      ${bold}/ MACOS PRIVACY / ABOUT SPOTLIGHT SEARCH /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Spotlight Search is your Mac's built-in search feature that allows you to search"
echo "for files on your Mac. Spotlight is integrated with Apple's voice assistant Siri"
echo "and can search the internet as well. As long as search suggestions (Siri"
echo "Suggestions) are enabled, Spotlight sends data to Apple servers. This can only"
echo "be turned off manually in your System Settings. This script will open the"
echo "required settings for you:"
echo " "
echo "Do you want to open your Spotlight Preferences now?"
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
while true
do
read -s -p "To open ${bold}SPOTLIGHT PREFERENCES${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SPOT1
case $SPOT1 in

# -------Input [Y/y]: Disable Spotlight indexing:--------

[Yy])

echo " "
echo " "
echo "--------------------------- spotlight preferences---------------------------"
echo " "
echo "sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Spotlight.prefPane"
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Spotlight.prefPane
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "  Wait until System Preferences open..."
echo "  Then deselect all categories you don't want to be searchable with Spotlight."
echo " "
echo "              ${bold}DON'T FORGET TO DISABLE SIRI SEARCH SUGGESTIONS${reset}"
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Spotlight Indexing:--------

echo " "
echo "                                    ${bold}/ MACOS PRIVACY / ABOUT SPOTLIGHT INDEXING /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Spotlight Indexing is a function that keeps track of where all your documents"
echo "and data are in order to find them more quickly. It can use a lot of CPU and be"
echo "intensive, but is not necessarily a privacy issue."
echo " "
echo "Do you want to disable Spotlight Indexing?"
echo " "
echo " "
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
while true
do
read -s -p "To ${bold}DISABLE SPOTLIGHT INDEXING${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SPOT2
case $SPOT2 in

# -------Input [Y/y]: Disable Spotlight indexing:--------

[Yy])

echo " "
echo " "
echo "---------------------------disable spotlight indexing---------------------------"
echo " "
echo "sudo mdutil -sav -i off -d /"
sudo mdutil -sav -i off -d /
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -p "Review the output of this command and press ${bold}[ENTER]${reset} when you are ready: "

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Internet Based Spell Correction:--------

echo " "
echo " "
echo "                       ${bold}/ MACOS PRIVACY / ABOUT INTERNET BASED SPELL CORRECTION /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "If Internet Based Spell Correction is enabled, every word you type on your Mac"
echo "will be checked by a remote online service for spelling and grammatical errors."
echo " "
echo "This service has the ability to log and analyze everything you type on your"
echo "Mac. Even if this is not necessarily common practice, it can be a privacy issue."
echo " "
echo "Do you want to disable internet based spell correction on your Mac?"
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
while true
do
read -s -p "To disable ${bold}INTERNET BASED SPELL CORRECTION${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " IBSC
case $IBSC in

# -------Input [Y/y]: Disable internet based spell correction:--------

[Yy])

echo " "
echo " "
echo "--------------------disable Internet Based Spell Correction--------------------"
echo " "
echo "defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Analytics and Targeted Advertisement:--------

echo " "
echo "                   ${bold}/ MACOS PRIVACY / ABOUT ANALYTICS AND TAGETED ADVERTISEMENT /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Apple on Analytics:"
echo " "
echo "${bold}With your permission, macOS can automatically collect analytics information from"
echo "your Mac and send it to Apple to help improve the quality and performance of its"
echo "products. This information is sent only with your consent and is submitted"
echo "anonymously to Apple.${reset}"
echo " "
echo "Furthermore Apple delivers targeted advertisement. If you do not want to receive"
echo "targeted Apple Advertising and share Analytics and Telemetry data with Apple,"
echo "you can disable them in your System Settings."
echo " "
echo "This script can open the required System Settings for you."
echo "Do you want to disable Tageted Advertisement and sending Analytics and Telemetry"
echo "data to Apple now?"
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To disable ${bold}APPLE ADVERTISING AND ANALYTICS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " LOC
case $LOC in

# -------Input [Y/y]: Disable Apple Advertising and Analytics:--------

[Yy])

echo " "
echo " "
echo "-----------------------open Apple Advertising preferences-----------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"
sleep 5
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences open:"
echo " "
echo "                            ${bold}UNTICK 'PERSONALISED ADS'${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "

echo " "
echo " "

echo "--------------------open Analytics & Improvem... preferences--------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"
echo " "
echo " "
echo " "
echo " "
echo " "
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
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Location Services:--------

echo " "
echo "                                     ${bold}/ MACOS PRIVACY / ABOUT LOCATION SERVICES /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "If Location Services are enabled, apps and services, including your browser, can"
echo "determine your location. A lot of apps that do not need to know your location,"
echo "i.e. your Calender App or AppleTV request location access."
echo " "
echo "This can be a privacy issue."
echo " "
echo "This script can open the required System Settings for you. You just need to"
echo "untick the box next to 'Enable Location Services' to disable them."
echo " "
echo "Do you want to disable your Mac's Location Services now?"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To disable ${bold}LOCATION SERVICES${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " LOC
case $LOC in

# -------Input [Y/y]: Location Services:--------

[Yy])

echo " "
echo " "
echo "-----------------------open Location Services preferences-----------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " Wait until System Preferences open:"
echo " "
echo "             ${bold}REMOVE THE HOOK IN FRONT OF 'ENABLE LOCATION SERVICES'${reset}"
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About iCloud Pt.1:--------

echo " "
echo " "
echo "                                                ${bold}/ MACOS PRIVACY / ABOUT ICLOUD /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "iCloud is the service from Apple that stores your passwords, photos, files,"
echo "notes and other data in the cloud and keeps it up to date across all your"
echo "devices."
echo " "
echo "iCloud includes a free email account and 5 GB of free storage for your data."
echo " "
echo "If you back up files to iCloud, Apple does keep the cryptographic key to those"
echo "'backed up' emails, photos, personal notes, contacts and calendar events. Apple"
echo "can always access those documents on iCloud. In the US Apple has already started"
echo "automatic scans of photos in order to fight and report child abuse. Furthermore,"
echo "if Apple receives a court order combined with a gag order, Apple will have to"
echo "comply and turn over your data to NSA, CIA and FBI. You won't even notice."
echo " "
echo "Similar legislation is being discussed in the EU as well:"
echo " "
echo "https://www.patrick-breyer.de/en/posts/messaging-and-chat-control/"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
read -s -p "Press ${bold}[ENTER]${reset} to continue: "

# -------About iCloud Pt.2:--------

echo " "
echo " "
echo "                                                ${bold}/ MACOS PRIVACY / ABOUT ICLOUD /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "If you don't want to give Apple the possibility to view and analyze your data,"
echo "you should not use iCloud and Apple's free email account at all: in your iCLoud"
echo "preference untick all boxes to stop any automatic synchronization."
echo " "
echo "Then sign out of your account."
echo " "
echo "Do you want to adjust your iCLoud and AppleID preferences now?"
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
while true
do
read -s -p "To open ${bold}iCLoud and AppleID Preferences${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " CLOUD
case $CLOUD in

# -------Input [Y/y]: Open Apple ID Preferences:--------

[Yy])

echo " "
echo " "
echo "----------------------------open AppleID preferences----------------------------"
echo " "
echo "sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/AppleIDPrefPane.prefPane"
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/AppleIDPrefPane.prefPane
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "  Wait until System Preferences open..."
echo "  Then, provided you don't want to use iCLoud, disable all iCloud options."
echo " "
echo "                      ${bold}THEN SIGN OUT OF YOUR APPLE ACCOUNT${reset}"
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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




# -------About iCloud Documents:--------

echo " "
echo " "
echo "                                      ${bold}/ MACOS PRIVACY / ABOUT ICLOUD DOCUMENTS /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "On your Mac, iCloud Documents is the default directory opened in the fileviewer"
echo "dialog when saving a new document. This is true as soon as iCloud is set up."
echo " "
echo "It is possbile to change your Mac's default behaviour, so that instead of iCLoud"
echo "documents your home directory is opened in the fileviewer dialog when saving a"
echo "new document. That way your documents stay on your Mac's local harddisk and are"
echo "not automatically stored on iCloud."
echo " "
echo "Do you want to stop storing documents to iCloud Drive by default?"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}STOP STORING DOCUMENTS TO ICLOUD${reset} by default, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or ${bold}[C/c]${reset} to cancel: " DRIVE
case $DRIVE in

# -------Input [Y/y]: Do not store documents to iCloud Drive by default:--------

[Yy])

echo " "
echo " "
echo "---------------do not store documents to iCloud Drive by default----------------"
echo " "
echo "defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Airdrop File Sharing:--------

echo " "
echo "                                  ${bold}/ MACOS PRIVACY / ABOUT AIRDROP FILE SHARING /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "With AirDrop, you can wirelessly send documents, photos, videos, websites, map"
echo "locations, and more to a nearby Mac, iPhone, iPad, or iPod touch."
echo " "
echo "By default AirDrop is not enabled. It can be enabled in your Finder Menu. As"
echo "soon as AirDrop is enabled your Mac can be discovered by other Apple according"
echo "devices as specified in your Airdrop preferences. However, AirDrop is not only a"
echo "privacy issue, but a security issue too:"
echo "In May 2019, researchers at TU Darmstadt have warned that sensitive personal"
echo "data can be exposed when using AirDrop. A hacker can easily access email"
echo "addresses and phone numbers, because of a flaw in Apple's security system. This"
echo "vulnerability has not yet been fixed. Visit this link to find out more: https://"
echo "www.informatik.tu-darmstadt.de/fb20/aktuelles_fb20/fb20_news/news_fb20_details_2"
echo "31616.en.jsp"
echo " "
echo "Do you want to disable AirDrop?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}DISABLE AIRDROP${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " AIR
case $AIR in

# -------Input [Y/y]: Disable AirDrop file sharing:--------

[Yy])

echo " "
echo " "
echo "--------------------------disable airdrop file sharing-------------------------"
echo " "
echo "defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Recent Items in Dock:--------

echo " "
echo "                                  ${bold}/ MACOS PRIVACY / ABOUT RECENT ITEMS IN DOCK /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "By default your recently used apps are listed in the Apple menu and appear in"
echo "the Dock. This may be a (minor) privacy issue and can be changed easily."
echo " "
echo "Do you want to NOT SHOW recent items in your Dock?"
echo " "
echo " "
echo " "
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
while true
do
read -s -p "To ${bold}NOT SHOW RECENT ITEMS IN DOCK${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " NSRID
case $NSRID in

# -------Input [Y/y]: Do not show recent items in Dock:--------

[Yy])

echo " "
echo " "
echo "------------------------do not show recent items in dock------------------------"
echo " "
echo "sudo -u $(stat -f '%Su' /dev/console) defaults write com.apple.dock show-recents -bool false && \\"
echo "sudo -u $(stat -f '%Su' /dev/console) killall Dock"
sudo -u $(stat -f '%Su' /dev/console) defaults write com.apple.dock show-recents -bool false && \
sudo -u $(stat -f '%Su' /dev/console) killall Dock
echo " "
echo "osascript -e 'quit app \"System Preferences\"'"
osascript -e 'quit app "System Preferences"'
echo "sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Dock.prefPane"
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Dock.prefPane
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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
echo "       _/_/_/                                          _/    _/"
echo "    _/          _/_/      _/_/_/  _/    _/  _/  _/_/      _/_/_/_/  _/    _/"
echo "     _/_/    _/_/_/_/  _/        _/    _/  _/_/      _/    _/      _/    _/"
echo "        _/  _/        _/        _/    _/  _/        _/    _/      _/    _/"
echo " _/_/_/      _/_/_/    _/_/_/    _/_/_/  _/        _/      _/_/    _/_/_/"
echo "                                                                      _/"
echo "                                                                 _/_/"
echo "          _/_/_/              _/      _/      _/"
echo "       _/          _/_/    _/_/_/_/_/_/_/_/      _/_/_/      _/_/_/    _/_/_/"
echo "        _/_/    _/_/_/_/    _/      _/      _/  _/    _/  _/    _/  _/_/"
echo "           _/  _/          _/      _/      _/  _/    _/  _/    _/      _/_/"
echo "    _/_/_/      _/_/_/      _/_/    _/_/  _/  _/    _/    _/_/_/  _/_/_/"
echo "                                                           _/"
echo "                                                      _/_/"
echo " "
echo " "
echo " "                                                        
echo " "
countdown "00:00:7"

# -------About Captive Portal:--------

echo " "
echo "                                             ${bold}/ MACOS SECURITY / CAPTIVE PORTAL /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "When your Mac connects to new networks, it checks for Internet connectivity and"
echo "may launch a Captive Portal assistant utility application. The intention behind"
echo "this function is to make it very easy for you to log into the public wifi of a"
echo "coffee shop, your university or a public library."
echo " "
echo "An attacker could trigger the utility and direct a Mac to a site with malware"
echo "without user interaction - which can quickly result in the Mac being hacked."
echo "This is in fact easier than you may think... You can always use your browser"
echo "instead - thus the Captive Portal assistant is not really needed."
echo " "
echo "Read more about how Captive Portals interfere with security and privacy here:"
echo "https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-sec"
echo "urity-and-privacy"
echo " "
echo "Do you want to disable your Mac's Captive Portal assistant?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}DISABLE CAPTIVE PORTAL${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " PORT
case $PORT in

# -------Input [Y/y]: Disable Captive Portal:--------

[Yy])

echo " "
echo " "
echo "-----------------------------disable captive portal----------------------------"
echo " "
echo "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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


# -------About Application Layer Firewall:--------

echo " "
echo "                           ${bold}/ MACOS SECURITY / ABOUT APPLICATION LAYER FIREWALL /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "MacOS comes with a built-in, basic firewall which blocks incoming connections"
echo "only. This firewall does not have the ability to monitor, nor block outgoing"
echo "connections."
echo " "
echo "Your firewall is disabled by default."
echo " "
echo "This script can turn on your Mac's firewall, prevent automatically allowing"
echo "incoming connections to signed apps, as well as to downloaded signed apps and"
echo "enable Stealth Mode (prevent your Mac from responding to probing requests like"
echo "ICMP/Ping that can be used to reveal its existence). Afterwards it will open the"
echo "corresponding System Setting so you can check if the changes have been"
echo "implemented correctly."
echo " "
echo "Do you want to turn on your Mac's built-in basic firewall?"
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}TURN ON YOUR FIREWALL${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " FIRE
case $FIRE in

# -------Input [Y/y]: Turn on Firewall:--------

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
echo "-----------------------------turn on stealth mode-----------------------------"
echo " "
echo "/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on"
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sleep 1
echo "sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true"
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
sleep 1
echo "defaults write com.apple.security.firewall EnableStealthMode -bool true"
defaults write com.apple.security.firewall EnableStealthMode -bool true
sleep 1
echo " "
echo " "
echo "----------prevent automatically allowing connections to signed apps-----------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false"
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false
sleep 1
echo " "
echo " "
echo "-----prevent automatically allowing connections to downloaded signed apps-----"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false"
sudo defaults write /Library/Preferences/com.apple.alf allowdownloadsignedenabled -bool false
sleep 1
echo " "
echo " "
echo "--------------------------------enable firewall-------------------------------"
echo " "
echo "/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on"
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sleep 1
echo "sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true"
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
sleep 1
echo "defaults write com.apple.security.firewall EnableFirewall -bool true"
defaults write com.apple.security.firewall EnableFirewall -bool true
sleep 1
echo " "
echo " "
echo "-------------------open system settings firewall preferences------------------"
echo " "
echo "osascript -e 'quit app \"System Preferences\"'"
osascript -e 'quit app "System Preferences"'
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Firewall"
sleep 5
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "                   ... Wait until Firewall Settings open ..."
echo " "
echo "                      ${bold}PLEASE REVIEW YOUR FIREWALL SETTINGS${reset}."
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "


break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Guest Accounts:--------

echo " "
echo "                                       ${bold}/ MACOS SECURITY / ABOUT GUEST ACCOUNTS /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Guest Accounts are accounts on your Mac with limited access: in theory guests"
echo "can use your computer, but cannot access your data. They also cannot install"
echo "new software and their rights can be restricted even further with the parental"
echo "controls in your Mac's System Settings. However, Guest accounts still are a"
echo "security risk:"
echo " "
echo "https://www.stigviewer.com/stig/apple_os_x_10.13/2018-10-01/finding/V-81615"
echo "https://www.stigviewer.com/stig/apple_macos_11_big_sur/2021-06-16/finding/V-230823"
echo " "
echo "We recommend you set up a Standard User Accout for your everyday work (without"
echo "admin privileges) - and a separate Admin Account with superuser privileges which"
echo "you only use to administer you Mac (install new software and change settings)."
echo " "
echo "Do you want to disable Guest accounts on your Mac?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}DISABLE GUEST ACCOUNTS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " GUEST
case $GUEST in

# -------Input [Y/y]: Disable Guest Accouts:--------

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
echo "--------------disable signing in as Guest from the login screen---------------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO
sleep 1
echo " "
echo " "
echo "-----------------disable Guest access to file shares over SMB-----------------"
echo " "
echo "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO"
echo " "
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
sleep 1
echo " "
echo " "
echo "-----------------disable Guest access to file shares over AF------------------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO"
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
sleep 1
echo " "
echo " "
echo "----------------------open system settings Users & Groups---------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Accounts.prefPane'
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/Accounts.prefPane
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:5"

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Unauthorized Connections:--------

echo " "
echo "                                   ${bold}/ MACOS SECURITY / UNAUTHORIZED CONNECTIONS /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "There are several protocols that can be used to connect to your Mac."
echo "This script makes sure that the following connection types are disabled:"
echo " "
echo "1) Remote Login Connections (incomming SSH and SFTP connections)"
echo " "
echo "2) Insecure TFTP Service (Trivial File Transfer Protocol): https://www.stigviewe"
echo "r.com/stig/apple_macos_11_big_sur/2021-06-16/finding/V-230813"
echo " "
echo "3) Bonjour Multicast Advertisement: https://www.stigviewer.com/stig/apple_os_x_1"
echo "0.11/2017-04-06/finding/V-67593"
echo " "
echo "4) Insecure Telnet Protocol: https://www.stigviewer.com/stig/apple_os_x_10.13/20"
echo "20-09-11/finding/V-214882"
echo " "
echo "Do you want to prevent unauthorized connections to your Mac?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}PREVENT UNAUTHORIZED CONNECTIONS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " CON
case $CON in

# -------Input [Y/y]: Prevent Unauthorized Connections:--------

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
echo "--------disable isable remote login (incoming SSH and SFTP connections)-------"
echo " "
echo "echo 'yes' | sudo systemsetup -setremotelogin off"
echo 'yes' | sudo systemsetup -setremotelogin off
sleep 1
echo " "
echo " "
echo "------------------------disable insecure TFTP service-------------------------"
echo " "
echo "sudo launchctl disable 'system/com.apple.tftpd'"
sudo launchctl disable 'system/com.apple.tftpd'
sleep 1
echo " "
echo " "
echo "--------------------disable Bonjour multicast advertising---------------------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true"
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
sleep 1
echo " "
echo " "
echo "-----------------------disable insecure telnet protocol-----------------------"
echo " "
echo "sudo launchctl disable system/com.apple.telnetd"
sudo launchctl disable system/com.apple.telnetd
sleep 1
echo " "
echo " "
echo "---------------------------open Sharing Preferences---------------------------"
echo " "
echo "osascript -e 'quit app \"System Preferences\"'"
osascript -e 'quit app "System Preferences"'
echo "sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/SharingPref.prefPane"
sudo -u $(stat -f '%Su' /dev/console) open -b com.apple.systempreferences /System/Library/PreferencePanes/SharingPref.prefPane
sleep 1
echo " "
echo " "
countdown "00:00:5"

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Printer Sharing:--------

echo " "
echo "                                            ${bold}/ MACOS SECURITY / PRINTER SHARING /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Printer Sharing relies on the CUPS server, which in its default configuration"
echo "poses a few potential security risks. The CUPS server does not accept remote"
echo "connections and only accepts shared printer information from the local subnet."
echo "But when you share printers and/or enable remote administration, you expose your"
echo "system to potential unauthorized access. Read more here:"
echo " "
echo "https://www.cups.org/doc/security.html"
echo " "
echo "Do you want to disable Printer Sharing on your Mac?"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}DISABLE PRINTER SHARING${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " CON
case $CON in

# -------Input [Y/y]: Disable Printer Sharing:--------

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
echo "------------disable sharing of local printers with other computers------------"
echo " "
echo "cupsctl --no-share-printers"
cupsctl --no-share-printers
sleep 1
echo " "
echo " "
echo "-----------disable printing from any address including the internet-----------"
echo " "
echo "cupsctl --no-remote-any"
cupsctl --no-remote-any
sleep 1
echo " "
echo " "
echo "--------------------disable remote printer administration---------------------"
echo " "
echo "cupsctl --no-remote-admin"
cupsctl --no-remote-admin
sleep 1
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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


# -------About Screen Saver Session Lock:--------

echo " "
echo "                                  ${bold}/ MACOS SECURITY / SCREEN SAVER SESSION LOCK /${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Your screen saver can be set up to require your password when you want to unlock"
echo "it to go back to your account. Also a password may be required for your computer"
echo "to wake up from sleep. That way the screen saver acts as a session lock that"
echo "prevents unauthorized access to your device."
echo " "
echo "Setting the Screen Saver Session Lock with this script works on older versions"
echo "of MacOS. If you are on MacOS Monterey it will not work. In this case, make your"
echo "changes manually in your System Settings. This script will open your System"
echo "Settings for you..."
echo " "
echo "In this menu you can also define the idle time after which your Mac should log"
echo "you out. We recommend to keep this time as low as possible."
echo " "
echo " "
echo "Do you want to enable your screen saver as a session lock?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}ENABLE SCREEN SAVER SESSION LOCK${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " SSS
case $SSS in

# -------Input [Y/y]: Enable Screen Saver Session Lock:--------

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
echo "------require a password to wake the computer from sleep or screen saver------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true"
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true
sleep 1
echo " "
echo " "
echo "-------initiate session lock five seconds after screen saver is started-------"
echo " "
echo "sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5"
sudo defaults write /Library/Preferences/com.apple.screensaver 'askForPasswordDelay' -int 5
sleep 1
echo " "
echo " "
echo "-------------------open system settings security preferences------------------"
echo " "
echo "osascript -e 'quit app \"System Preferences\"'"
osascript -e 'quit app "System Preferences"'
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?General"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?General"
sleep 5
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
sleep 1
echo " "
echo " "
echo " "
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
echo " "
echo " "
echo " "
echo " "
read -s -p "Press ${bold}[ENTER]${reset} when you are ready: "

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Firmware Password Pt.1:--------

echo " "
echo "                                      ${bold}/ MACOS SECURITY / FIRMWARE PASSWORD PT.1/${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "Setting a Firmware Password prevents a Mac from starting up from any device"
echo "other than the startup disk. This may be useful for mitigating some attacks"
echo "which require physical access to hardware. This feature can be helpful if your"
echo "laptop is lost or stolen, protects against Direct Memory Access (DMA) which can"
echo "read your FileVault passwords (which are the key to unlock your data if your"
echo "laptop is encrypted) and inject malicious kernel modules, as the only way to"
echo "reset the firmware password is through an Apple Store, or by using an SPI"
echo "Programmer."
echo " "
echo "Do you want to setup a Firmware Password as an additional security layer?"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}SETUP FIRMWARE PASSWORD${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " FIRM
case $FIRM in

# -------Input [Y/y]: Setup Firmware Password:--------

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
echo "----------------------------setup firmware password---------------------------"
echo " "
echo "sudo firmwarepasswd -setpasswd -setmode command"
sudo firmwarepasswd -setpasswd -setmode command
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
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

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About Firmware Password Pt.2:--------

echo " "
echo "                                      ${bold}/ MACOS SECURITY / FIRMWARE PASSWORD PT.2/${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "A Firmware Password may be bypassed by a determined attacker or Apple, with"
echo "physical access to the computer. However, Apple implements an option that does"
echo "effectively prevent any Firmware Password resets, even by Apple themselves:"
echo " "
echo "For users who want no one but themselves to remove their Firmware Password"
echo "by software means, the -disable-reset-capability option has been added to the"
echo "firmwarepasswd command-line tool in macOS 10.15. Before setting this option,"
echo "users must to acknowledge that if the password is forgotten and needs removal,"
echo "the user must bear the cost of the motherboard replacement necessary to achieve"
echo "this."
echo " "
echo "If you just set a firmware password for the first time in the previous step, you"
echo "have to reboot your Mac before you can disable reset capability. In this case,"
echo "please exit this script and reboot your Mac, or skip this step (for now)."
echo " "
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}PREVENT FIRMWARE PASSWORD RESETS${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel and ${bold}REBOOT${reset} first: " FIRMRE
case $FIRMRE in

# -------Input [Y/y]: Prevent Firmware Password Resets:--------

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
echo "-----------------------prevent firmware password resets-----------------------"
echo " "
echo "sudo firmwarepasswd -disable-reset-capability"
sudo firmwarepasswd -disable-reset-capability
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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

# -------About FileVault:--------

echo " "
echo "                                                   ${bold}/ MACOS SECURITY / FILEVAULT/${reset}"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
echo "FileVault provides full disk encryption on MacOS."
echo " "
echo "FileVault encryption protects data at rest and hardens (but not always prevents)"
echo "someone with physical access from stealing data or tampering with your Mac."
echo "If you can remember the password, there's no reason to save the recovery key."
echo "However, all encrypted data will be lost forever without either the password"
echo "or recovery key."
echo "We do recommend you write down your Recovery Key and/or use a Password Manager"
echo "like KeePassX to keep your Recovery Keys and your Passwords safe."
echo " "
echo "This script helps you set up FileVault through the command line. In case you"
echo "feel more comfortable to set up FileVault through the System Settings instead,"
echo "it also opens the corresponding System Setting for you."
echo " "
echo "Do you want to encrypt your Mac with FileVault now?"
echo " "
echo "--------------------------------------------------------------------------------"
echo " "
while true
do
read -s -p "To ${bold}ENABLE FILEVAULT${reset}, press ${bold}[Y/y]${reset}
Press ${bold}[N/n]${reset} to skip this step, or press ${bold}[C/c]${reset} to cancel: " VAULT
case $VAULT in

# -------Input [Y/y]: Enable Filevault:--------

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
echo "-------------------open system settings filevault preferences------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?FDE"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?FDE"
sleep 1
echo " "
echo " "
echo "-------------------------------enable filevault-------------------------------"
echo " "
echo "sudo fdesetup enable"
sudo fdesetup enable
sleep 1
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:5"

break;;

# -------Input [N/n]: Skip this step:--------

[Nn])
skip
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
echo "                     _/_/_/  _/_/_/_/  _/_/_/_/_/  _/    _/  _/_/_/"
echo "                  _/        _/            _/      _/    _/  _/    _/"
echo "                   _/_/    _/_/_/        _/      _/    _/  _/_/_/"
echo "                      _/  _/            _/      _/    _/  _/"
echo "               _/_/_/    _/_/_/_/      _/        _/_/    _/"
echo " "
echo "                  _/_/_/      _/_/    _/      _/  _/_/_/_/"
echo "                 _/    _/  _/    _/  _/_/    _/  _/"
echo "                _/    _/  _/    _/  _/  _/  _/  _/_/_/"
echo "               _/    _/  _/    _/  _/    _/_/  _/"
echo "              _/_/_/      _/_/    _/      _/  _/_/_/_/"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
countdown "00:00:7"

echo " "
echo " "
echo "------------------------open full disk access preferences-----------------------"
echo " "
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
sleep 5
echo 'sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"'
sudo -u $(stat -f '%Su' /dev/console) open "x-apple.systempreferences:com.apple.preference.security?Advanced"
sleep 1
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
echo " "
echo " "
read -s -n 1 -p  "Before you click ${bold}QUIT & REOPEN${reset}, press ${bold}[ANY KEY]${reset} to exit this script: "
