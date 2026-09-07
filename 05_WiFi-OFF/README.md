# Wifi-OFF

- [01 About Wifi-OFF](#01-about-wifi-off)
- [02 Installation](#02-installation)

# 01 About Wifi-OFF

**MORE INFO**<br>
[https://term7.info/wifi-off/](https://term7.info/wifi-off/)

While macOS is supposed to remember your last Wi-Fi state after a reboot, this isn’t reliable: Wi-Fi may turn back on automatically when you reboot your computer, either due to system processes or simply because you forgot to turn it off before shutdown. Since there’s no built-in setting to reliably enforce this behavior, we created a tool that keeps Wi-Fi disabled after the boot-time SpoofMAC sequence has completed. When you need it, just re-enable Wi-Fi manually with one click.

Your Mac may probe for known networks during startup when Wi-Fi is enabled. Auto-join behavior can make Evil Twin attacks and Man-in-the-Middle attacks more viable. SpoofMAC helps reduce MAC address tracking by randomizing the Wi-Fi interface address before normal network use, while Wifi-OFF switches the Wi-Fi radio off again immediately afterwards.

This is why we have written a simple tool that:

- Keeps Wi-Fi switched off after the boot-time MAC randomization has completed.
- Blocks automatic reconnection to known networks after the SpoofMAC sequence.
- Makes Wi-Fi available only in a user-controlled state after login.
- Helps minimize MAC address tracking, unwanted Wi-Fi activity and automatic connections, especially in sensitive environments.

Wifi-OFF can operate in two different modes depending on whether [04 - SpoofMAC](../04_SpoofMAC) is already installed with automatic MAC randomization enabled.

If SpoofMAC is installed, Wifi-OFF modifies the existing SpoofMAC helper script so that, after the new MAC address has been successfully applied and verified, the Wi-Fi radio is switched off again. No additional Wifi-OFF LaunchDaemons are installed in this mode.
SpoofMAC already runs at boot, temporarily cycles the Wi-Fi radio and randomizes the MAC address before macOS reconnects to a remembered network. Wifi-OFF simply extends this existing boot sequence.

The resulting boot sequence is:

Wi-Fi OFF
    ↓
Wi-Fi ON
    ↓
Randomize MAC address
    ↓
Verify new MAC address
    ↓
Wi-Fi OFF

The Wi-Fi network service itself remains enabled. This means Wi-Fi is still normally available to the logged-in user, but the radio remains switched off until the user deliberately enables Wi-Fi.

If SpoofMAC is not installed with automatic MAC randomization enabled, Wifi-OFF instead installs its own standalone helper scripts and LaunchDaemons. These ensure that Wi-Fi is switched off during startup and remains available for manual use after login.
This means that SpoofMAC is optional: Wifi-OFF works independently, but integrates with SpoofMAC automatically when a complete SpoofMAC boot-time installation is detected.

# 02 Installation

Our [interactive script](script/install_WiFi-OFF.sh) automatically detects whether SpoofMAC is installed with automatic MAC randomization enabled and chooses the appropriate installation method. If SpoofMAC is installed, Wifi-OFF modifies the existing SpoofMAC helper script located at:

```
/Users/Shared/Enhancements/spoof_mac/spoof_mac.sh
```

It adds the commands required to power the Wi-Fi radio off after SpoofMAC has successfully randomized and verified the MAC address.
The existing SpoofMAC LaunchDaemon remains installed and continues to execute the same helper script whenever you boot or reboot your computer. No additional Wifi-OFF LaunchDaemons are installed in this mode.

If a complete automatic SpoofMAC installation is not detected, Wifi-OFF installs its standalone configuration instead. This consists of two helper scripts and two LaunchDaemons that manage the Wi-Fi state during boot and login.

In either installation mode, the goal is the same: Wi-Fi remains switched off after startup while still being available for the logged-in user to enable manually whenever a network connection is needed.

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

If you want to uninstall Wifi-OFF from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_WiFi-OFF.sh) (Codeberg or Github Mirror):

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

***

# **MIRRORS**

This repository is actively maintained on Codeberg:<br>
https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/05_WIFI-OFF

Changes are pushed regularly to our Github Mirror:<br>
https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/05_WIFI-OFF