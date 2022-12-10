# MACOS PRIVACY AND SECURITY SETTINGS

01) [About Privacy and Security Settings](#01---About-MacOS-Privacy-and-Security-Settings)
02) [SETTINGS FEATURE LIST](#02---SETTINGS-FEATURE-LIST)
03) [RESOURCES](#03---RESOURCES)


# 01 - About MacOS Privacy and Security Settings


Our scripts for [MacOS Ventura](script/MacOS-Ventura_Privacy-and-Security-Settings.sh) and for [MacOS Monterey](script/MacOS-Monterey_Privacy-and-Security-Settings.sh) are interactive scripts that guide you through all relevant standard MacOS Privacy and Security Settings. The scripts also give you a brief explanation of each available option, so you can make an informed decision wether or not you want to change the respective system setting. Please note that at the time we do not have access to the latest ARM64 Silicon Mac with M1 Security Chip. We wrote and tested this script on an Intel-based Mac running MacOS Monterey and MacOS Ventura. To run our script, you first have to download it.

BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script for MacOS Monterey or MacOS Ventura:

    # MacOS Monterey:
    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Monterey_Privacy-and-Security-Settings.sh
    # MacOS Ventura:
    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Ventura_Privacy-and-Security-Settings.sh

Give the respective file execute permissions:

    chmod +x MacOS-Monterey_Privacy-and-Security-Settings.sh
    chmod +x MacOS-Ventura_Privacy-and-Security-Settings.sh

Execute the script (depending wether you are on MacOS Monterey or MacOS Ventura):

    ./MacOS-Monterey_Privacy-and-Security-Settings.sh
    ./MacOS-Ventura_Privacy-and-Security-Settings.sh


Our script can adjust most System Preferences that are enabled by default in MacOS. You just have to press [Y/y] + [ENTER] to proceed, [N/n] + [ENTER] to skip a specific option, or [C/c] + [ENTER] to cancel. If manual action is required, this script will open the respective Settings Tab for you, so you can implement the changes yourself. If you want to use a faster version of this script with less explanation (which is useful if you want to skip quickly through the options), you can download our speedy install script for [MacOS Ventura](script/SPEEDY-INSTALL_MacOS-Ventura_Privacy-and-Security-Settings.sh) or [MacOS Monterey](script/SPEEDY-INSTALL_MacOS-Monterey_Privacy-and-Security-Settings.sh) instead:

    # MacOS Monterey:
    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Monterey_Privacy-and-Security-Settings.sh
    # MacOS Ventura:
    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Ventura_Privacy-and-Security-Settings.sh

Furthermore we have written an additional [script](https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/02_Kill-Siri/script/kill-siri.sh) that sets up a [KillSwitch](https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/02_Kill-Siri) for you if you decide to disable Siri, yet you want to keep your Mac's System Integrity Protection (SIP) enabled.

# 02 - SETTINGS FEATURE LIST

Our script guides you through the following Privacy and Security Settings:

### Privacy

01) <i>Turn off Apple Remote Events</i>
02) <i>Disable Apple Remote Management Service</i>
03) <i>Disable Siri</i>
04) <i>Adjust Spotlight Search Settings</i>
05) <i>Disable Spotlight Search Indexing</i>
06) <i>Disable Internet Based Spell Correction</i>
07) <i>Turn off Apple Analytics and Targeted Apple Advertising</i>
08) <i>Turn off Location Services</i>
09) <i>Configure iCLoud Settings</i>
10) <i>Stop storing documents to iCloud by default</i>
11) <i>Turn off Airdrop File Sharing</i>
12) <i>Hide Recent Items in Dock</i>

### Security

01) <i>Disable Captive Portal</i>
02) <i>Enable and configure basic Application Layer Firewall</i>
03) <i>Disable Guest Accounts</i>
04) <i>Disable Unauthorised Connections (SSH, SFTP, TFTP, Bonjour Multicast, Telnet)</i>
05) <i>Disable Printer Sharing (CUPS Server)</i>
06) <i>Setup Screen Saver Session Lock</i>
07) <i>Setup Firmware Password (relevant only for Intel based Macs)</i></i>
08) <i>Prevent Firmware Password Resets (relevant only for Intel based Macs)</i>
09) <i>Enable FileVault (Full Disk Encryption)</i>
10) <i>Lockdown Mode (MacOS Ventura or newer)</i>

# 03 - RESOURCES

Special thanks to https://privacy.sexy/ and https://github.com/drduh/macOS-Security-and-Privacy-Guide.<br>
Without these two resources, this guide would not exist.

Furthermore it is quite difficult to find documentation by Apple on how to open specific System Settings Tabs via the commandline. These resources were very helpful:

https://github.com/piarasj/piarasj.github.io/blob/master/ventura_settings.md#ventura-system-settings<br>
https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Ventura.md<br>
https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Monterey.md

