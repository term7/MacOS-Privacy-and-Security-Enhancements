# SPOOFMAC

01) [About SpoofMac](#01---About-SpoofMac)
02) [Why install SpoofMac?](#02---Why-install-SpoofMac?)
03) [Installation](#03---Install-SpoofMac)
04) [How to use SpoofMac](#04---How-to-use-SpoofMac)
05) [MAC Address Tracking](#05---MAC-Address-Tracking)
06) [Resources](#06---Resources)


# 01 - About SpoofMac

SpoofMac randomizes your Mac's MAC Adress.

SpoofMac originally was written in Python by feross:
* [https://github.com/feross/SpoofMAC](https://github.com/feross/SpoofMAC)

Feross also provides a node.js port of this package:
* [https://github.com/feross/spoof](https://github.com/feross/spoof)



# 02 - Why install SpoofMAC?


*"The MAC address is a unique identifier tied to your physical Network Interface (Wired Ethernet or Wi-Fi) and could of course be used to track you if it is not randomized."*

(The Hitchhiker's Guide to Online Anonymity)

*"I made SpoofMac because changing your MAC address in Mac OS X is harder than it should be. The biggest annoyance is that the Wi-Fi card (Airport) needs to be manually disassociated from any connected networks in order for the change to be applied correctly. Doing this manually every time is tedious and lame."*

(Feross Aboukhadijeh / Maker of SpoofMac)

To spoof your MAC address is especially recommended if you are working on a laptop using public Wifi, in order to mitigate tracking methods that identify and track your devices MAC address.



# 03 - Installation

Our [installation script](script/install_SpoofMAC.sh) installs [spoof](https://github.com/feross/spoof) by Github user *feross* and sets up a <em>LaunchDaemon</em>, that automatically randomizes your Mac's MAC Adress every time you reboot your computer. To install *spoof* you need to install *nodejs*. Our script takes care of that too, but it requires [MacPorts](https://www.macports.org/) to install the required software packages. If you have not yet installed MacPorts, please install MacPorts first! We have written an easy [MacPorts installation script](../03_MacPorts/script/install_MacPorts.sh) that guides you through the installation of MacPorts.

BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.

# 04 - How to use SpoofMac

You can use SpoofMac to manually change your MAC addresses via the command line. To do so, open a Terminal Window to type commands.


List all usage instructions:

    spoof --help


List all available devices:

    spoof list

        - "Ethernet" on device "en0" with MAC address 70:56:51:BE:B3:00
        - "Wi-Fi" on device "en1" with MAC address 70:56:51:BE:B3:01 
          currently set to 00:05:69:2B:6A:23
        - "Bluetooth PAN" on device "en1"


List available devices, but only those on Wi-Fi:

    spoof list --wifi

        - "Wi-Fi" on device "en1" with MAC address 70:56:51:BE:B3:01 
          currently set to 00:05:69:2B:6A:23


Randomize MAC address (requires root) using hardware port name. IMPORTANT: You first have to switch off wifi, otherwise this command will fail to execute:

    networksetup -setairportpower en0 off
    sudo spoof randomize wi-fi


Set device MAC address to something specific (requires root). IMPORTANT: You first have to switch off wifi, otherwise this command will fail to execute:

    networksetup -setairportpower en0 off
    sudo spoof set 00:00:00:00:00:00 wi-fi

Reset device to its original MAC address (requires root):
    
    sudo spoof reset wi-fi


# 05 - MAC Address Tracking

The MAC address of a wireless device constitutes an excellent unique identifier to track its owner. MAC addresses of wireless devices are collected and stored by several systems. For instance logs of wireless routers include the MAC address of all devices that have been connected. Those logs contain events related to management aspects of the wireless network (association, authentication, disconnection, etc.) and each event associates a MAC address with a timestamp.
Another example is Radio-Frequency tracking systems that are specifically designed to track the movement of individuals thanks to the wireless devices that they are wearing. Those systems are based on a set of sensors collecting wireless signals that triangulate and track the movement of individuals over time. Those systems are deployed in areas such as shopping centres, museums, roads, subway stations, etc. - where they provide valuable information on mobility patterns and shopping habits.

# 06 - Resources

Wikipedia: https://en.wikipedia.org/wiki/MAC_address
The Hitchhiker's Guide to Online Anonymity: https://anonymousplanet.org/guide#your-wi-fi-or-ethernet-mac-address
Github (feross): https://github.com/feross/spoof