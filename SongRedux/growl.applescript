-- growl.applescript
-- SongRedux
(*
on startgrowl()
	tell application "GrowlHelperApp"
		set the allNotificationsList to {"Conversion Complete", "File Complete"}
		set the enabledNotificationsList to {"Conversion Complete", "File Complete"}
		register as application "SongRedux" all notifications allNotificationsList default notifications enabledNotificationsList icon of application "SongRedux"
	end tell
end startgrowl

on completenotify(whichnotify, growltitle, growlstring)
	tell application "GrowlHelperApp" to notify with name whichnotify title growltitle description growlstring application name "SongRedux"
end completenotify
*)
--  Created by Tyler Loch on 2/24/08.
--  Copyright 2008 Techspansion LLC. All rights reserved.
