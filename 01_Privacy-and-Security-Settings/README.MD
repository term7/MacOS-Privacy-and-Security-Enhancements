# CONTENTS

01) [Privacy and Security Settings](#01---MacOS-Privacy-and-Security-Settings)
02) [FEATURE LIST](#02---FEATURE-LIST)
03) [Siri KillSwitch](#03---Siri-KillSwitch)
04) [RESOURCES](#RESOURCES)


# 01 - MacOS Privacy and Security Settings


Our [script](script/01.1_MacOS-Privacy-and-Security-Settings.sh) is an interactive script that guides you through standard MacOS Privacy and Security Settings. It also gives you a brief explanation of each available option, so you can make an informed decision wether or not you want to change it. Please note that at the time we do not have access to the latest ARM64 Silicon Mac with M1 Security Chip. We wrote and tested this script on an Intel-based Mac running MacOS Monterey. To run our script, you first have to download it.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Privacy-and-Security-Settings.sh

Give the file execute permissions:

    chmod +x MacOS-Privacy-and-Security-Settings.sh

Execute the file:

    ./MacOS-Privacy-and-Security-Settings.sh


Our script can adjust most System Preferences that are enabled by default in MacOS. You just have to press [Y/y] + [ENTER] to proceed, [N/n] + [ENTER] to skip a specific option, or [C/c] + [ENTER] to cancel. If manual action is required, this script will open the respective Settings Tab for you, so you can implement the changes yourself. If you want to use a faster version of this script with less explanation (which is useful if you want to skip quickly through the options), you can download our [speedy install script](script/SPEEDY-INSTALL_MacOS-Privacy-and-Security-Settings.sh) instead:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Privacy-and-Security-Settings.sh

We have written an additional [script](script/kill-siri.sh) that sets up a [KillSwitch](#03---Siri-KillSwitch) for you if you decide to disable Siri, yet you want to keep your Mac's System Integrity Protection (SIP) enabled.

# 02 - FEATURE LIST

Our script guides you through the following Privacy and Security Settings:

### Privacy

01) Turn off Apple Remote Events
02) Disable Apple Remote Management Service
03) Disable Siri
04) Adjust Spotlight Search Settings
05) Disable Spotlight Search Indexing
06) Disable Internet Based Spell Correction
07) Turn off Apple Analytics and Targeted Apple Advertising
08) Turn off Location Services
09) Configure iCLoud Settings
10) Stop storing documents to iCloud by default
11) Turn off Airdrop File Sharing
12) Hide Recent Items in Dock

### Security

01) Disable Captive Portal
02) Enable and configure basic Application Layer Firewall
03) Disable Guest Accounts
04) Disable Unauthorised Connections (SSH, SFTP, TFTP, Bonjour Multicast, Telnet)
05) Disable Printer Sharing (CUPS Server)
06) Setup Screen Saver Session Lock
07) Setup Firmware Password
08) Enable FileVault (Full Disk Encryption)

# 03 - Siri KillSwitch

Apple does not allow you to disable Siri permanently unless you disable your Mac's SIP, because since MacOS BigSur Siri is baked into the core operating system - which is protected by Apple's System Integrity Protection (SIP). In oder to disable Siri completely, you have to first disable SIP, unload Siri and then keep SIP disabled, which will make your computer less secure and more vulnerable to external attacks. As soon as you re-enable SIP Siri will be reactivated too, even if you did disable Siri in your System Preferences.

With SIP enabled and Siri switched off in your System Preferences, the following processes will keep to run in the background of your computer (tested on MacOS Monterey 12.5.1):

<em>siriinferenced
<br>siriactionsd
<br>siriknowledged
<br>com.apple.siri.embeddedspeech
<br>assistantd
</em>

When Siri and another helper process (<em>assistantd</em>) become active, they modify files in this location:

    ~/Library/Assistant/
        
Our [interactive script](script/kill-siri.sh) sets up a local <em>LaunchAgent</em> to watch this folder location and a global <em>LaunchDaemon</em> that terminates all processes related to Siri as soon as they are detected by our <em>LaunchAgent</em>.

To set up this KillSwitch, open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder) and navigate to your Downloads Folder:

    cd ~/Downloads

Download the interactive script:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/kill-siri.sh

Give the file execute permissions:

    chmod +x kill-siri.sh

Execute the file:

    ./kill-siri.sh

If asked, enter your administrator password and hit [ENTER].
Your password won't be shown by default.

Alternatively you can also download our non-interactive [speedy install script](script/SPEEDY-INSTALL_kill-siri.sh):

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_kill-siri.sh

We also provide a [script](script/UNINSTALL_kill-siri.sh) to uninstall our KillSwitch:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/UNINSTALL_kill-siri.sh

# RESOURCES

Special thanks to https://privacy.sexy/ and https://github.com/drduh/macOS-Security-and-Privacy-Guide
Without these two resources, this guide would not exist.
