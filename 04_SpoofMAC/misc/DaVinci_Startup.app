on run
	do shell script "/usr/sbin/networksetup -setairportpower en0 off && sudo /opt/local/bin/node /opt/local/bin/spoof set 00:05:69:2A:96:68 wi-fi" with administrator privileges
	tell application "/Applications/DaVinci Resolve/DaVinci Resolve.app"
		activate
		
	end tell
end run