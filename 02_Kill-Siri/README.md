# KILL SIRI

**MORE INFO**<br>
[https://term7.info/kill-siri/](https://term7.info/kill-siri/)

Apple does not allow you to disable Siri permanently unless you disable your Mac's SIP, because since MacOS BigSur Siri is baked into the core operating system - which is protected by Apple's System Integrity Protection (SIP). In oder to disable Siri completely, you have to first disable SIP, unload Siri and then keep SIP disabled, which will make your computer less secure and more vulnerable to external attacks. As soon as you re-enable SIP Siri will be reactivated too, even if you did disable Siri in your System Preferences.

With SIP enabled and Siri switched off in your System Preferences, depending on your version of MacOS, the following processes will keep to run in the background of your computer (tested on MacOS Monterey 12.5.1, MacOS Ventura 13.0.1 and MacOS Sonoma 14.5):

<em>com.apple.SiriTTSService.TrialProxy
<br>com.apple.siri.embeddedspeech
<br>com.apple.siri-distributed-evaluation
<br>siriactionsd
<br>sirittsd
<br>SiriTTSSynthesizerAU
<br>SiriAUSP
<br>siriknowledged
<br>siriinferenced
<br>assistantd
</em>

When Siri and another helper process (<em>assistantd</em>) become active, they modify files in this location:<br>
`~/Library/Assistant/`
        
Our [interactive script](script/kill-siri.sh) sets up a local <em>LaunchAgent</em> to watch this folder location and a global <em>LaunchDaemon</em> that terminates all processes related to Siri as soon as they are detected by our <em>LaunchAgent</em>.

**BE CAREFUL: YOU SHOULD ALWAYS LOOK AT THE CONTENT OF ANY SHELL SCRIPT YOU DOWNLOAD FROM AN UNKNOWN SOURCE BEFORE YOU EXECUTE IT! VERIFY ITS CONTENT FIRST TO MAKE SURE IT IS SAFE TO EXECUTE.**

To set up this KillSwitch, open the Terminal.app (found with Spotlight or in your Applications -> Utilities Folder) and navigate to your Downloads Folder:
```
cd ~/Downloads
```

Download the interactive script (Codeberg or Github mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/02_Kill-Siri/script/install_kill-siri.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_Kill-Siri/script/kill-siri.sh
```



Give the file execute permissions:
```
chmod +x kill-siri.sh
```

Execute the script:
```
./kill-siri.sh
```

If asked, enter your administrator password and hit [ENTER].
Your password won't be shown by default.

Alternatively you can also download our non-interactive [speedy install script](script/SPEEDY-INSTALL_kill-siri.sh) (Codeberg or Github mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/02_Kill-Siri/script/SPEEDY-INSTALL_kill-siri.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_Kill-Siri/script/SPEEDY-INSTALL_kill-siri.sh
```

We also provide a [script](script/UNINSTALL_kill-siri.sh) to uninstall our KillSwitch (Codeberg or Github mirror):

```
curl -O https://codeberg.org/term7/MacOS-Privacy-and-Security-Enhancements/raw/branch/main/02_Kill-Siri/script/UNINSTALL_kill-siri.sh
```
```
curl -O https://raw.githubusercontent.com/term7/MacOS-Privacy-and-Security-Enhancements/main/02_Kill-Siri/script/UNINSTALL_kill-siri.sh
```
