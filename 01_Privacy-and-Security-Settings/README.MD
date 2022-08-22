# 01 - Privacy and Security Settings


Our [script](script/01.1_MacOS-Privacy-and-Security-Settings.sh) is an interactive script that guides you through standard MacOS Privacy and Security Settings. It also gives you a brief explanation of each option, so you can decide wether or not you want to change it. To run our script, you have to download it first.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/01.1_MacOS-Privacy-and-Security-Settings.sh

Give the file execute permissions:

    chmod +x 01.1_MacOS-Privacy-and-Security-Settings.sh

Execute the file:

    ./01.1_MacOS-Privacy-and-Security-Settings.sh


Our script can adjust most of your System Preferences that are enabled by default in MacOS. You just have to press [Y/y] to proceed, [N/n] to skip a specific option, or [C/c] to cancel. If manual action is required, this script will open the required Settings Tab for you, so you can implement the changes manually. If you want to use a faster version of this script with less explanantion you can download our [speedy install script](script/02.1_SPEEDY-INSTALL_MacOS-Privacy-and-Security-Settings.sh) instead:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/02.1_SPEEDY-INSTALL_MacOS-Privacy-and-Security-Settings.sh


We have written an additional [script](#02---Siri-KillSwitch) that sets up a [02 - Siri KillSwitch](#02---Siri-KillSwitch) should you decide to disable Siri. yet you want to keep your Mac's System Integrity Protection (SIP) enabled.

## FEATURE LIST

Our script guides you through the following Privacy and Security Settings:

### Privacy

01) Turn off Apple Remote Events
02) Disable Apple Remote Management Service
03) Disable Siri (<em>-> we provide an additional script to setup a Siri KillSwitch if you don't want to disable SIP</em>)
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

# 02 - Siri KillSwitch
