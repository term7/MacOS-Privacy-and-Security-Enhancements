# CONTENTS

01) [About MacPorts](#01---About-MacPorts)
02) [Installation](#02---Installation)
03) [Resources](#03---Resources)


# 01 - About MacPorts

The MacPorts Project is an open-source community initiative that enables you to compile software that runs natively on Linux (UNIX). We use MacPorts to install software and command line tools that are otherwise not available on MacOS, but very useful to enhance our digital security and our online privacy.
 
MacPorts requires XCODE and XCODE COMMAND LINE TOOLS to be installed on your system. Please install Xcode from the Apple AppStore. Alternatively you can dowload Xcode from the [Apple Developer Website](https://developer.apple.com/xcode/resources/).


# 02 - Installation

Our installation script for [MacPorts](script/install_MacPorts.sh) is an interactive script that will help you to compile MacPorts from source. To run our script, you first have to download it.

BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.

Open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder).
In your Terminal, navigate to your Downloads Folder:

    cd ~/Downloads

Download the script for MacOS Monterey or MacOS Ventura:

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_MacPorts/script/install_MacPorts.sh

Give the respective file execute permissions:

    chmod +x install_MacPorts.sh

Execute the script:

    ./install_MacPorts.sh

If you want to uninstall MacPorts from your system, please download and execute our [UNINSTALL SCRIPT](script/UNINSTALL_MacPorts.sh):

    curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_MacPorts/script/UNINSTALL_MacPorts.sh

# 03 - Resources

The MacPorts Project: https://www.macports.org/
