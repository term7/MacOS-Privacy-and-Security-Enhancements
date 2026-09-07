# SpoofMAC

- [01 About SpoofMAC](#01-about-spoofmac)
- [02 Why install SpoofMAC](#02-why-install-spoofmac)
- [03 Installation](#03-installation)
- [04 How to use SpoofMAC](#04-how-to-use-spoofmac)
- [05 How a random MAC address is generated](#05-how-a-random-mac-address-is-generated)
- [06 MAC Address Tracking](#06-mac-address-tracking)
- [07 Resources](#07-resources)
- [08 Proprietary Software License Issues](#08-proprietary-software-license-issues)
- [09 Troubleshooting SpoofMAC](#09-troubleshooting-spoofmac)


# 01 About SpoofMAC

**MORE INFO**<br>
[https://term7.info/spoofmac/](https://term7.info/spoofmac/)<br>
[https://term7.info/troubleshooting-spoofmac/](https://term7.info/troubleshooting-spoofmac/)

* * *

SpoofMAC randomizes your Mac's MAC Adress.

SpoofMAC originally was written in Python by feross:
* [https://github.com/feross/SpoofMAC](https://github.com/feross/SpoofMAC)

Feross also provides a node.js port of this package:
* [https://github.com/feross/spoof](https://github.com/feross/spoof)

Earlier versions of this chapter installed that node.js package. They no longer do. SpoofMAC is now a small shell script that only uses tools which are already part of macOS:

* `/dev/urandom` generates the random address
* `/usr/sbin/networksetup` finds your Wi-Fi Card and cycles its radio
* `/sbin/ifconfig` applies the new address

There is **nothing left to install**. No MacPorts, no Node.js, no npm. If you followed this guide only in order to get SpoofMAC working, you no longer need chapter [03 - MacPorts](../03_MacPorts) at all. It remains in this guide as an optional chapter for those who want MacPorts for other reasons.


# 02 Why install SpoofMAC


*"The MAC address is a unique identifier tied to your physical Network Interface (Wired Ethernet or Wi-Fi) and could of course be used to track you if it is not randomized."*

(The Hitchhiker's Guide to Online Anonymity)

*"I made SpoofMAC because changing your MAC address in Mac OS X is harder than it should be. The biggest annoyance is that the Wi-Fi card (Airport) needs to be manually disassociated from any connected networks in order for the change to be applied correctly. Doing this manually every time is tedious and lame."*

(Feross Aboukhadijeh / Maker of SpoofMAC)

To spoof your MAC address is especially recommended if you are working on a laptop using public Wifi, in order to mitigate tracking methods that identify and track your devices MAC address.

Feross is right that the Wi-Fi Card has to be disassociated from any connected network before a new address will stick. His tool did that with Apple's private `airport` command line utility. Apple deprecated that utility in macOS 14.4 and has since removed it. The rewrite of SpoofMAC to use macOS built-in tools instead of the previous Node.js/npm implementation was contributed by [OpenHat Security](https://github.com/openhat-security), the developer behind [OnionGate](https://github.com/openhat-security/oniongate). We subsequently adapted the Wi-Fi power sequence for current macOS: we switch the Wi-Fi radio off with `networksetup`, switch it straight back on, and immediately apply the new address with `ifconfig` before macOS reconnects to a network. During early boot the Wi-Fi interface may not yet be ready even though `networksetup` successfully powered it on, so the script retries the complete sequence up to five times.

Modern versions of macOS also provide Apple's built-in **Private Wi-Fi Address** feature with Off, Fixed and Rotating modes. Apple manages this setting per Wi-Fi network: **Fixed** uses a private address that normally stays unchanged and is the default for WPA2 or stronger networks, while **Rotating** changes the private address every two weeks and is the default for weakly secured or open networks. Apple states that Fixed reduces tracking across different networks, while Rotating additionally reduces tracking by the same network over time. For most users this already provides strong MAC address privacy and has the advantage of managing private addresses per Wi-Fi network.

SpoofMAC remains useful if you want a new, explicitly scriptable interface MAC address on every boot. In our testing on macOS Tahoe, even with Private Wi-Fi Address set to **Fixed**, the MAC assigned by SpoofMAC became the address shown in System Settings and the address seen by the Wi-Fi router. This effectively changes an otherwise fixed network-visible MAC on every reboot. Apple's **Rotating** mode also changes the address periodically, but SpoofMAC does so on every boot.

Apple currently provides no documented `networksetup` command to enable or select Private Wi-Fi Address modes from Terminal, and the setting is configured per network rather than through a global “Rotating” switch. This interaction with manually assigned `ifconfig` addresses is based on our testing and is not documented by Apple.

Apple documentation:
Apple (Use private Wi-Fi addresses on Apple devices): [https://support.apple.com/en-ie/102509](https://support.apple.com/en-ie/102509)
Apple (Use a private Wi-Fi address on Mac): [https://support.apple.com/en-in/guide/mac-help/mchlb1cb3eb4/mac](https://support.apple.com/en-in/guide/mac-help/mchlb1cb3eb4/mac)


# 03 Installation

Our [interactive script](script/install_SpoofMAC.sh) installs a small helper script to `/Users/Shared/Enhancements/spoof_mac/spoof_mac.sh` and sets up a <em>LaunchDaemon</em>, that automatically randomizes your Mac's MAC Adress every time you reboot your computer.

If an existing standalone [05 - WiFi-OFF](../05_WiFi-OFF) installation is detected, the installer automatically preserves its behavior by integrating Wifi-OFF into the new SpoofMAC helper script. When **AUTOMATIC MAC RANDOMIZATION** is enabled, the old standalone Wifi-OFF helper scripts and LaunchDaemons are removed, and the SpoofMAC LaunchDaemon takes over the complete boot sequence.

**THIS SCRIPT HAS NO PREREQUISITES.** It uses macOS built-in tools only.

**BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.**

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:
```
cd ~/Downloads
```

Download the script (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/04_SpoofMAC/script/install_SpoofMAC.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/04_SpoofMAC/script/install_SpoofMAC.sh
```

Give the respective file execute permissions:
```
chmod +x install_SpoofMAC.sh
```

Execute the script:
```
./install_SpoofMAC.sh
```

If you want to remove SpoofMAC from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_SpoofMAC.sh) (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/04_SpoofMAC/script/UNINSTALL_SpoofMAC.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/04_SpoofMAC/script/UNINSTALL_SpoofMAC.sh
```

Alternatively you can also download our non-interactive [speedy install script](script/SPEEDY-INSTALL_SpoofMAC.sh) (Codeberg or Github Mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/04_SpoofMAC/script/SPEEDY-INSTALL_SpoofMAC.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/04_SpoofMAC/script/SPEEDY-INSTALL_SpoofMAC.sh
```


# 04 How to use SpoofMAC

Once installed, SpoofMAC runs on its own every time you boot or reboot. You can also use it manually via the command line. To do so, open a Terminal Window to type commands.

Randomize your Wi-Fi MAC address right now (requires root). This is exactly what the LaunchDaemon runs at boot. It switches your Wi-Fi radio off, switches it immediately back on, and applies a new random address before macOS reconnects. During early boot it may retry the complete sequence up to five times while the Wi-Fi interface becomes ready, so **your Wi-Fi will briefly disconnect**:
```
sudo /Users/Shared/Enhancements/spoof_mac/spoof_mac.sh
```


Read the log of the last run:
```
cat /Users/Shared/Enhancements/spoof_mac/spoof_mac.log
```


List all available devices and the MAC address that is currently set on each of them:
```
networksetup -listallhardwareports
```

Example Output:
```
Hardware Port: Ethernet
Device: en1
Ethernet Address: 70:56:51:be:b3:00

Hardware Port: Wi-Fi
Device: en0
Ethernet Address: 70:56:51:be:b3:01
```

Note that `networksetup` reports the **hardware** address that is burned into the card. To read the address that is **currently set** on your Wi-Fi Card, ask `ifconfig` instead:

```
ifconfig en0 | grep ether
```

Example Output:
```
	ether 92:d1:44:ec:95:cc
```

Find out which device your Wi-Fi Card actually is. It is not always `en0` - a Thunderbolt dock, a USB Ethernet adapter or a tethered iPhone can shift it to `en1`, `en2` or later, which is why our script never hardcodes a device name:
```
networksetup -listallhardwareports | awk '/^Hardware Port: Wi-Fi$/ { getline; print $2 }'
```

Set your Wi-Fi Card to a specific MAC address (requires root). IMPORTANT: you first have to switch off your Wi-Fi radio, otherwise this command will fail to execute:

```
sudo networksetup -setairportpower en0 off
```
```
sudo networksetup -setairportpower en0 on
```
```
sudo ifconfig en0 ether 02:11:22:33:44:55
```

Reset the MAC address applied by SpoofMAC: simply reboot your computer with the SpoofMAC LaunchDaemon removed. The address applied by SpoofMAC is not written to disk, so it disappears on the next boot. macOS may then use the hardware address or, if Private Wi-Fi Address is enabled for the network, a private Wi-Fi address.

# 05 How a random MAC address is generated

A MAC address is six bytes. Our script reads those six bytes from `/dev/urandom`, the kernel's cryptographically secure random number generator. We deliberately do not use the shell's `$RANDOM`, which is a weak, seeded generator and a poor source for an identifier that is supposed to be unlinkable across the places you visit.

Six random bytes alone are not yet a valid address. The two least significant bits of the **first octet** are not part of the random identifier, they are flags, and getting them wrong is the single easiest mistake to make when you spoof a MAC address by hand:

| bit | name | meaning | what we do |
| --- | --- | --- | --- |
| `0x01` | I/G bit | `0` = individual (unicast), `1` = group (multicast) | force it to `0` |
| `0x02` | U/L bit | `0` = universally administered, `1` = locally administered | force it to `1` |

The I/G bit **must** be `0`. An address with the multicast bit set is not a valid station address, and your Wi-Fi driver or the access point will simply reject it. This is the failure mode people run into when they spoof a MAC address from `/dev/urandom` without correcting the first octet: roughly half of all randomly generated addresses are unusable.

The U/L bit **must** be `1`. Setting it declares "this address was made up locally", which is exactly what we did. It also guarantees that we are not accidentally impersonating some real manufacturer's registered OUI.

In the script this is one line:

```
first=$(( (bytes[0] | 0x02) & 0xFE ))
```

`| 0x02` forces the locally administered bit on, `& 0xFE` forces the multicast bit off. The remaining five bytes stay fully random.

# 06 MAC Address Tracking

The MAC address of a wireless device constitutes an excellent unique identifier to track its owner. MAC addresses of wireless devices are collected and stored by several systems. For instance logs of wireless routers include the MAC address of all devices that have been connected. Those logs contain events related to management aspects of the wireless network (association, authentication, disconnection, etc.) and each event associates a MAC address with a timestamp.
Another example is Radio-Frequency tracking systems that are specifically designed to track the movement of individuals thanks to the wireless devices that they are wearing. Those systems are based on a set of sensors collecting wireless signals that triangulate and track the movement of individuals over time. Those systems are deployed in areas such as shopping centres, museums, roads, subway stations, etc. - where they provide valuable information on mobility patterns and shopping habits.

# 07 Resources

Wikipedia: [https://en.wikipedia.org/wiki/MAC_address](https://en.wikipedia.org/wiki/MAC_address)<br>
Wikipedia (Organizationally unique identifier): [https://en.wikipedia.org/wiki/Organizationally_unique_identifier](https://en.wikipedia.org/wiki/Organizationally_unique_identifier)<br>
The Hitchhiker's Guide to Online Anonymity: [https://anonymousplanet.org/guide#your-wi-fi-or-ethernet-mac-address](https://anonymousplanet.org/guide#your-wi-fi-or-ethernet-mac-address)<br>
Github (feross): [https://github.com/feross/spoof](https://github.com/feross/spoof)

# 08 Proprietary Software License Issues

Sometimes when you purchase proprietary software, you have to enter a license key in order to use it. Depending on the software, after you restart your computer with SpoofMac installed as a service, it suddenly stops working unless you enter your license key again. This can quickly become very annoying and is an indicator that the software you purchased checks the MAC address of your computer in order to verify that it is the machine that was connected to a specific license key. If it cannot find the MAC address you used when you registered the product, the software thinks it is on a new machine and will force you to do the registration process again.
The only way to avoid re-registration is to change your devices MAC address back to the MAC address you used when you registered the software. Please be aware that it is not necessarily the original MAC address of your computer! It can be a spoofed MAC address already.

# 09 Troubleshooting SpoofMAC

#### Read the log

Every run of SpoofMAC writes what it did to a log file. If your MAC address did not change, look there first:

```
cat /Users/Shared/Enhancements/spoof_mac/spoof_mac.log
```

The script logs the address it generated and the address the card actually reports afterwards. If the two differ it says so explicitly and exits with an error.

#### Early-boot retries

During early boot, `networksetup` may successfully power Wi-Fi on before the Wi-Fi interface is fully ready to accept a new link-layer address. In that state, `ifconfig` can fail with:

```
ifconfig: ioctl (SIOCAIFADDR): Network is down
```

SpoofMAC therefore retries the complete OFF -> ON -> MAC-change sequence up to five times. Repeating the power cycle also forces Wi-Fi back into an unassociated state on each attempt, giving `ifconfig` a fresh opportunity to change the address before macOS reconnects to a remembered network.

#### Example AppleScript for DaVinci Resolve

If you use the free version of DaVinci Resolve, there are no licensing issues. However, if you purchased the professional version of DaVinci Resolve, you may encounter the issue described above, depending on your licensing method and system configuration. In our experience, this issue persisted if you purchased an activation key for the software - still on MacOS Sonoma. If you do encounter it, we wrote a small [AppleScript](misc/DaVinci_Startup.app) that changes its MAC address back to the MAC address you used when you registered your license key before it proceeds to start DaVinci Resolve (THIS IS AN EXAMPLE THAT USES A RANDOM MAC ADDRESS). Here a link to our Tutorial:

[https://term7.info/troubleshooting-spoofmac/](https://term7.info/troubleshooting-spoofmac/)

***

# **MIRRORS**

This repository is actively maintained on Codeberg:<br>
https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/04_SpoofMAC

Changes are pushed regularly to our Github Mirror:<br>
https://github.com/term7/MacOS-Privacy-and-Security-Enhancements/tree/main/04_SpoofMAC
