#!/usr/bin/env bash

#   SPEEDY-INSTALL_kill-siri.sh
#   term7 / 03.12.2022
##
##   MIT License
#   Copyright (c) 2022 term7
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# -------Variables:--------

WATCH_LOCATION=~/Library/Assistant/
ENHANCEMENTS=/Users/Shared/Enhancements
TRIGGER_LOCATION=$ENHANCEMENTS/trigger
TRIGGER=$TRIGGER_LOCATION/.trigger

LOCAL_DAEMON_FOLDER=/Library/LaunchAgents
LOCAL_DAEMON_NAME=info.term7.killall.siri.helper
LOCAL_DAEMON=$LOCAL_DAEMON_FOLDER/$LOCAL_DAEMON_NAME.plist

GLOBAL_DAEMON_FOLDER=/Library/LaunchDaemons
GLOBAL_DAEMON_NAME=info.term7.killall.siri
GLOBAL_DAEMON=$GLOBAL_DAEMON_FOLDER/$GLOBAL_DAEMON_NAME.plist

TRIGGER_COMMAND="touch $TRIGGER; rm $TRIGGER; rm -f -- ~/Library/Assistant/SiriAnalytics.db; rm -f -- ~/Library/Assistant/SiriAnalytics.db-shm; rm -f -- ~/Library/Assistant/SiriAnalytics.db-wal; rm -f -- ~/Library/Assistant/assistantdDidLaunch; rm -f -- ~/Library/Assistant/session_did_finish_timestamp; if [ -d ~/Library/Assistant/SiriVocabulary ]; then rm -rf ~/Library/Assistant/SiriVocabulary; fi; if [ -d ~/Library/Assistant/CustomVocabulary ]; then rm -rf ~/Library/Assistant/CustomVocabulary; fi; if [ -d ~/Library/Assistant/SiriReferenceResolution ]; then rm -rf ~/Library/Assistant/SiriReferenceResolution; fi"
KILLALL_COMMAND="if pgrep SiriAUSP; then kill -9 \$(pgrep SiriAUSP); fi; if pgrep siriinferenced; then kill -9 \$(pgrep siriinferenced); fi; if pgrep siriactionsd; then kill -9 \$(pgrep siriactionsd); fi; if pgrep siriknowledged; then kill -9 \$(pgrep siriknowledged); fi; if pgrep sirittsd; then kill -9 \$(pgrep sirittsd); fi; if pgrep SiriTTSSynthesizerAU; then kill -9 \$(pgrep SiriTTSSynthesizerAU); fi;  if pgrep assistantd; then kill -9 \$(pgrep assistantd); fi; if pgrep com.apple.siri.embeddedspeech; then kill -9 \$(pgrep com.apple.siri.embeddedspeech); fi; if pgrep com.apple.SiriTTSService.TrialProxy; then kill -9 \$(pgrep com.apple.SiriTTSService.TrialProxy); fi"
if [ ! -d "$ENHANCEMENTS" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir $ENHANCEMENTS
fi

if [ ! -d "$TRIGGER_LOCATION" ]; then
    sudo -u $(stat -f '%Su' /dev/console) mkdir $TRIGGER_LOCATION
fi

sudo chown $(stat -f '%Su' /dev/console):wheel "$ENHANCEMENTS"
sudo chown $(stat -f '%Su' /dev/console):staff "$TRIGGER_LOCATION"

sudo chmod 775 "$TRIGGER_LOCATION"

# -------Local Helper Daemon:--------

sudo tee "$LOCAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${LOCAL_DAEMON_NAME}</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/sh</string>
		<string>-c</string>
		<string>${TRIGGER_COMMAND}</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>~/Library/Assistant</string>
	</array>
</dict>
</plist>
EOF

# -------Global Unload Daemon:--------

sudo tee "$GLOBAL_DAEMON" << EOF > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>${GLOBAL_DAEMON_NAME}</string>
	<key>ProgramArguments</key>
	<array>
		<string>/bin/sh</string>
		<string>-c</string>
		<string>${KILLALL_COMMAND}</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>${TRIGGER_LOCATION}</string>
	</array>
</dict>
</plist>
EOF

# -------Ownership, Permission:--------

sudo chown root:wheel "$LOCAL_DAEMON"
sudo chmod 644 "$LOCAL_DAEMON"
sudo chown root:wheel "$GLOBAL_DAEMON"
sudo chmod 644 "$GLOBAL_DAEMON"

# -------Load Daemons:--------

sudo -u $(stat -f '%Su' /dev/console) launchctl load "$LOCAL_DAEMON"
sudo launchctl load "$GLOBAL_DAEMON"

# -------Trigger Daemons:--------

sudo -u $(stat -f '%Su' /dev/console) touch /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp
sudo -u $(stat -f '%Su' /dev/console) rm /Users/$(stat -f '%Su' /dev/console)/Library/Assistant/.tmp

echo "Setup Finished! Press ${bold}[ANY KEY]${reset} to exit: "
read -n 1 -s
