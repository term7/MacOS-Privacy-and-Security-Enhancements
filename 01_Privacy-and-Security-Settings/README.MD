# MACOS PRIVACY AND SECURITY SETTINGS

- [01 About Privacy and Security Settings](#01-about-macos-privacy-and-security-settings)
- [02 SETTINGS FEATURE LIST](#02-settings-feature-list)
- [03 RESOURCES](#03-resoures)


# 01 About MacOS Privacy and Security Settings

**MORE INFO**<br>
[https://term7.info/macos-privacy-security-settings/](https://term7.info/macos-privacy-security-settings/)

* * *

The installation scripts in this repository are interactive scripts that guide you through all relevant standard MacOS Privacy and Security Settings. The scripts also give you a brief explanation of each available option, so you can make an informed decision wether or not you want to change the respective system setting. Please note that at the time we do not have access to the latest ARM64 Silicon Mac with M1 Security Chip. We wrote and tested this script on an Intel-based Mac running MacOS Monterey and MacOS Ventura. To run our script, you first have to download it.

**COMMENT: BETWEEN MACOS MONTEREY AND MACOS VENTURA, APPLE MADE SOME MAJOR CHANGES TO THEIR OPERATING SYSTEM. OUR SCRIPT HAS BEEN TESTED ON MACOS SONOMA AS WELL - ON AN INTEL BASED MAC (LATE 2019, RUNNING MACOS SONOMA). THE SCRIPT FOR MACOS VENTURA STILL WORKS WITHOUT ANY PROBLEMS.**

**BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.**

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:
```
cd ~/Downloads
```

* * *

#### CODEBERG

**MacOS Sequoia:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/MacOS-Sequoia_Privacy-and-Security-Settings.sh
```

**MacOS Ventura:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/MacOS-Ventura_Privacy-and-Security-Settings.sh
```

**MacOS Monterey:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/MacOS-Monterey_Privacy-and-Security-Settings.sh
```

* * *

#### GITHUB

**MacOS Sequoia:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Sequoia_Privacy-and-Security-Settings.sh
```

**MacOS Ventura:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Ventura_Privacy-and-Security-Settings.sh
```

**MacOS Monterey:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/MacOS-Monterey_Privacy-and-Security-Settings.sh
```

* * *

Give the respective file execute permissions:
```
chmod +x *Privacy-and-Security-Settings.sh
```

Execute the script:
```
 ./*Privacy-and-Security-Settings.sh
 ```


Our script can adjust most System Preferences that are enabled by default in MacOS. You just have to press [Y/y] + [ENTER] to proceed, [N/n] + [ENTER] to skip a specific option, or [C/c] + [ENTER] to cancel. If manual action is required, this script will open the respective Settings Tab for you, so you can implement the changes yourself. If you want to use a faster version of this script with less explanation (which is useful if you want to skip quickly through the options), you can download our speedy install script instead:

* * *

#### CODEBERG

**MacOS Sequoia:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Sequoia_Privacy-and-Security-Settings.sh
```

**MacOS Ventura:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Ventura_Privacy-and-Security-Settings.sh
```

**MacOS Monterey:**
```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Monterey_Privacy-and-Security-Settings.sh
```

* * *

#### GITHUB

**MacOS Sequoia:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Sequoia_Privacy-and-Security-Settings.sh
```

**MacOS Ventura:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Ventura_Privacy-and-Security-Settings.sh
```

**MacOS Monterey:**
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/01_Privacy-and-Security-Settings/script/SPEEDY-INSTALL_MacOS-Monterey_Privacy-and-Security-Settings.sh
```

* * *

Furthermore we have written an additional [script](../02_Kill-Siri/script/kill-siri.sh) that sets up a [KillSwitch](../02_Kill-Siri/Readme.md) for you if you decide to disable Siri, yet you want to keep your Mac's System Integrity Protection (SIP) enabled.

# 02 SETTINGS FEATURE LIST

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

# 03 RESOURCES

Special thanks to https://privacy.sexy/ and https://github.com/drduh/macOS-Security-and-Privacy-Guide.<br>
Without these two resources, this guide would not exist.

Furthermore it is quite difficult to find documentation by Apple on how to open specific System Settings Tabs via the commandline. These resources were very helpful:

[https://github.com/piarasj/piarasj.github.io/blob/master/ventura_settings.md#ventura-system-settings](https://github.com/piarasj/piarasj.github.io/blob/master/ventura_settings.md#ventura-system-settings)<br>
[https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Ventura.md](https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Ventura.md)<br>
[https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Monterey.md](https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Monterey.md)

### **MIRRORS**

This repository is actively maintained on Codeberg:
https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/01_Privacy-and-Security-Settings

Changes are puhsed regularly to our Githoub Mirror:
https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/01_Privacy-and-Security-Settings