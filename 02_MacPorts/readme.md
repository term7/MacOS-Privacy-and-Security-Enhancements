# MACPORTS

01) [About MacPorts](#01---About-MacPorts)
02) [Installation](#02---Installation)
03) [Usage](#03---Automatic-Updates)
04) [Usage](#03---Usage)
05) [Resources](#03---Resources)


# 01 - About MacPorts

The MacPorts Project is an open-source community initiative that enables you to compile software that runs natively on Linux (UNIX). We use MacPorts to install FOSS, software and command line tools that are otherwise not available on MacOS, but very useful to enhance our digital security and our online privacy.
 
MacPorts requires XCODE and XCODE COMMAND LINE TOOLS to be installed on your system. Please install Xcode from the Apple AppStore. Alternatively you can dowload Xcode from the [Apple Developer Website](https://developer.apple.com/xcode/resources/).


# 02 - Installation

Our [installation script](script/install_MacPorts.sh) for MacPorts is an interactive script that will help you to compile MacPorts from source. Furthermore it can set up a System Service that updates MacPorts on a regular basis. To run our script, you first have to download it.

BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_MacPorts/script/install_MacPorts.sh

Give the respective file execute permissions:

    chmod +x install_MacPorts.sh

Execute the script:

    ./install_MacPorts.sh

If you want to uninstall MacPorts from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_MacPorts.sh):

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_MacPorts/script/UNINSTALL_MacPorts.sh

# 03 - Automatic Updates

Our installation script can set up automatic updates for you. If you decide to install everything manually, this is how our update mechanism works:

A [LaunchDaemon](System Service/info.term7.macports.updater.plist) runs a [script](System Service/macports_updater.sh) with the required MacPorts commands 5min after every reboot.



# 04 - Usage

If you do not want to use our System Service to update MacPorts automatically, you can also update and maintain your MacPorts installation manually. To do so, open a Terminal Window to type commands. You can also search for specific packages, look up additional info, select variants, etc. We list here only a few commands as examples. Please refer to the MacPorts documentation for a full manual: 

* [https://guide.macports.org/](https://guide.macports.org/)


Update MacPorts:

    sudo port -v selfupdate


Upgrade your MacPorts Installations:

    sudo port -v upgrade outdated


Unclutter your MacPorts Installation:

    sudo port uninstall inactive
    sudo port uninstall leaves

# 05 - Resources

The MacPorts Project: https://www.macports.org/
