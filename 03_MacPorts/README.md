# MACPORTS

01) [About MacPorts](#01-about-macports)
02) [Installation](#02-installation)
03) [Automatic Updates](#03-automatic-updates)
04) [Usage](#04-usage)
05) [Resources](#05-resources)


# 01 - About MacPorts

The MacPorts Project is an open-source community initiative that enables you to compile software that runs natively on Linux (UNIX). We use MacPorts to install FOSS, software and command line tools that are otherwise not available on MacOS, but very useful to enhance our digital security and our online privacy.
 
MacPorts requires XCODE and XCODE COMMAND LINE TOOLS to be installed on your system. Please install Xcode from the Apple AppStore. Alternatively you can dowload Xcode from the [Apple Developer Website](https://developer.apple.com/xcode/resources/).


# 02 - Installation

Our [installation script](install_MacPorts.sh) for MacPorts is an interactive script that will help you to compile MacPorts from source. Furthermore it can set up a System Service that updates MacPorts on a regular basis. To run our script, you first have to download it.

BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script:

   curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/03_MacPorts/install_MacPorts.sh

Github Mirror:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/03_MacPorts/install_MacPorts.sh

Give the respective file execute permissions:

    chmod +x install_MacPorts.sh

Execute the script:

    ./install_MacPorts.sh

If you want to uninstall MacPorts from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_MacPorts.sh):

   curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/03_MacPorts/UNINSTALL_MacPorts.sh

Github Mirror:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/03_MacPorts/UNINSTALL_MacPorts.sh

# 03 - Automatic Updates

Our installation script can set up automatic updates for you. If you decide to install everything manually, i.e. if you decide to follow the instructions of the [MacPorts project](https://www.macports.org/install.php) to install MacPorts on your system instead of using our installation script, but you want to implement our autmatic update mechanism, this is how it works:

A [LaunchDaemon](macports_updater/info.term7.macports.updater.plist) runs a [script](macports_updater/macports_updater.sh) with the required MacPorts commands 5min after every reboot. Error messages will be written to temporary logfiles that will be overwritten with each reboot.

Please Notice:

We use the Shared Folder on our machine to run our own scripts. In our setup the location for the Macports Updater Script is: */Users/Shared/Enhancements/macports_updater*. If you want to use another location for the script, you will have to adjust the path variable in the [LaunchDaemon](macports_updater/info.term7.macports.updater.plist) accordingly. To copy our setup, you first have to create the required folder structure:

    mkdir /Users/Shared/Enhancements && mkdir /Users/Shared/Enhancements/macports_updater

Navigate to the Macorts Updater Folder:

    cd /Users/Shared/Enhancements/macports_updater

Download the script:

   curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/03_MacPorts/macports_updater/macports_updater.sh

Github Mirror:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/03_MacPorts/macports_updater/macports_updater.sh

Setup the log files:

    touch macports.err.log && touch macports.out.log

Setup ownership and permissions:

    sudo chown root:wheel macports_updater.sh;
    sudo chown $(stat -f '%Su' /dev/console):admin macports.err.log macports.out.log;
    sudo chmod 744 macports_updater.sh;
    sudo chmod 644 macports.err.log macports.out.log

Next you want to setup the LaunchDaemon that runs the updater. Navigate to the default location where LaunchDaemons are stored:

    cd /Library/LaunchDaemons

Download the LaunchDaemon:

   curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/src/branch/main/03_MacPorts/macports_updater/info.term7.macports.updater.plist

Github Mirror:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/03_MacPorts/macports_updater/info.term7.macports.updater.plist

Setup ownership and permissions:

    sudo chown root:wheel info.term7.macports.updater.plist;
    sudo chmod 644 info.term7.macports.updater.plist

Manually start the LaunchDaemon (only required once):

    sudo launchctl load info.term7.macports.updater.plist

# 04 - Usage

If you do not want to use our LaunchDaemon to update MacPorts automatically, you can also update and maintain your MacPorts installation manually. To do so, open a Terminal Window to type commands. You can also search for specific packages, look up additional info, select variants, etc. We list here only a few commands as examples.

Please refer to the MacPorts documentation for a full manual: [https://guide.macports.org/](https://guide.macports.org/)

Update MacPorts:

    sudo port -v selfupdate

Upgrade your MacPorts Installations:

    sudo port -v upgrade outdated


Unclutter your MacPorts Installation:

    sudo port uninstall inactive;
    sudo port uninstall leaves

# 05 - Resources

The MacPorts Project: https://www.macports.org/
