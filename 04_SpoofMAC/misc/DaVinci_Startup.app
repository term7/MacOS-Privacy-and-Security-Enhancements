on run
	do shell script "/usr/sbin/networksetup -setairportpower en0 off && sleep 2 && /sbin/ifconfig en0 ether 00:05:69:2A:96:68 && /usr/sbin/networksetup -setairportpower en0 on" with administrator privileges
	tell application "/Applications/DaVinci Resolve/DaVinci Resolve.app"
		activate
		
	end tell
end run
