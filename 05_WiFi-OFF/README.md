# Wifi-OFF

- [01 About Wifi-OFF](#01-about-wifi-off)
- [02 Installation](#02-installation)

# 01 About Wifi-OFF

**MORE INFO**<br>
[https://term7.info/wifi-off/](https://term7.info/wifi-off/)

While macOS is supposed to remember your last Wi-Fi state after a reboot, this isn’t reliable: Wi-Fi may turn back on automatically when you reboot your computer, either due to system processes or simply because you forgot to turn it off before shutdown. Since there’s no built-in setting to prevent this, we created a tool that keeps Wi-Fi disabled at startup. When you need it, just re-enable Wi-Fi manually with one click.

Your Mac always will probe for known networks are broadcast at boot. MAC address randomization is only used when scanning, not when joining networks. Auto-join behavior makes Evil Twin attacks and Man-in-the-Middle attacks more viable.

This is why we have written a simple tool that:

- Prevents any Wi-Fi traffic or scanning during boot and login.
- Blocks auto-reconnection to known networks.
- Makes Wi-Fi available only in a user-controlled state after login.
- Helps minimize MAC address tracking and probe leaks, especially in sensitive environments.

# 02 Installation

Our [interactive script](script/install_WiFi-OFF.sh) installs sets up two scripts and two <em>LaunchDaemon</em>, that automatically switch off your Wi-Fi every time you reboot your computer.

**BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.**

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:
```
cd ~/Downloads
```

Download the script (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/05_WiFi-OFF/script/install_WiFi-OFF.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/05_WiFi-OFF/script/install_WiFi-OFF.sh
```

Give the respective file execute permissions:
```
chmod +x install_WiFi-OFF.sh
```

Execute the script:
```
./install_WiFi-OFF.sh
```

If you want to uninstall MacPorts from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_SpoofMAC.sh) (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/05_WiFi-OFF/script/UNINSTALL_WiFi-OFF.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/05_WiFi-OFF/script/UNINSTALL_WiFi-OFF.sh
```

Alternatively you can also download our non-interactive [speedy install script](script/SPEEDY-INSTALL_WiFi-OFF.sh) (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/05_WiFi-OFF/script/SPEEDY-INSTALL_WiFi-OFF.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/05_WiFi-OFF/script/SPEEDY-INSTALL_WiFi-OFF.sh
```

### **MIRRORS**

This repository is actively maintained on Codeberg:
https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/05_WIFI-OFF

Changes are puhsed regularly to our Githoub Mirror:
https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/05_WIFI-OFF