-- minus.applescript
-- ReduxZero
global savefile
global advanced
global downloadloc
global whichurl
global filesize
global thequotedapppath
global backslash
global parts
global imagesize

property presetall : 0
property presetipod5g : 1
property presetipodclassic : 2
property presetipodnano : 3
property presetipodtouch : 4
property presetiphone : 5
property presetappletv : 6
property presetappletv51 : 7
property presetappletv5120 : 8

--  Created by Tyler Loch on 11/20/05.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.

on clicked theObject
	set advanced to window "advanced"
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	try
		if (do shell script " echo " & (ASCII character 128) & "a") is "a" then
			set backslash to (ASCII character 128)
		else
			set backslash to "\\"
		end if
	on error
		set backslash to "\\"
	end try
	
	if theObject is button "plus" of window "ReduxZero" then
		set video to choose file without invisibles
		set AppleScript's text item delimiters to ""
		set inputvideo to POSIX path of video as string
		if ".eyetv/" is in (((text items -7 through -1 of (POSIX path of video as string))) as string) then
			set inputvideo to (text items 1 through -2 of (POSIX path of video as string)) as string
		end if
		if ".iMovieProject/" is in (((text items -15 through -1 of (POSIX path of video as string))) as string) then
			set inputvideo to (text items 1 through -2 of (POSIX path of video as string)) as string
		end if
		set newrow to make new data row at end of data rows of data source of table view "files" of scroll view "files" of window "ReduxZero"
		set contents of data cell "Files" of newrow to inputvideo
		--		tell button "plus" of window "ReduxZero" to set visible to false
		--		tell button "minus" of window "ReduxZero" to set visible to false
		--		tell button "clearall" of window "ReduxZero" to set visible to false
		--		tell text field "dragfiles" of window "ReduxZero" to set visible to false
		--		tell text field "dragfiles" of window "ReduxZero" to set visible to true
		--		tell button "plus" of window "ReduxZero" to set visible to true
		--		tell button "clearall" of window "ReduxZero" to set visible to true
		--		tell button "minus" of window "ReduxZero" to set visible to true
		update window "ReduxZero"
	end if
	
	if theObject is button "minus" of window "ReduxZero" then
		set deleteds to (selected data rows of table view "files" of scroll view "files" of window "ReduxZero")
		if (count of deleteds) > 0 then
			repeat with deleteeach in every item of deleteds
				delete (deleteeach)
				--				tell button "plus" of window "ReduxZero" to set visible to false
				--				tell button "clearall" of window "ReduxZero" to set visible to false
				--				tell text field "dragfiles" of window "ReduxZero" to set visible to false
				--				tell text field "dragfiles" of window "ReduxZero" to set visible to true
				--				tell button "plus" of window "ReduxZero" to set visible to true
				--				tell button "clearall" of window "ReduxZero" to set visible to true
			end repeat
			update window "ReduxZero"
		end if
	end if
	set parts to "/usr/bin/gunzip"
	if theObject is button "xgrid" of window "ReduxZero" then
		if content of button "xgrid" of window "ReduxZero" is true then
			if ((do shell script "echo `ps -axww | grep xgridcontrollerd | grep -cv grep`") is "0") and ((contents of default entry "xgridcontroller" of user defaults as string) is "") then
				display panel window "xgridsheet" attached to window "ReduxZero"
			else
				if contents of text field "path" of window "ReduxZero" is "" then
					set saveas to choose folder with prompt (localized string "saveloc") as string
					set saveasposix to POSIX path of saveas
					set content of text field "path" of window "ReduxZero" to saveasposix as string
				end if
				tell button "twopass" of window "Advanced" to set enabled to false
			end if
		else
			tell button "twopass" of window "Advanced" to set enabled to true
		end if
	end if
	
	if name of theObject is "startxgrid" then
		set thePath to path of the main bundle as string
		set sysver to (do shell script "uname -r | cut -c 1")
		if sysver > 8 then
			set plistpath to "/etc/xgrid/controller/com.apple.xgrid.controller.plist"
			set maxproc to " "
		else
			display alert "Restart Required" message "This computer will require a restart before an Xgrid conversion will complete successfully." as critical default button "OK" other button (localized string "Cancel")
			if button returned of the result is (localized string "cancel") then
				close panel window of theObject
				set content of button "xgrid" of window "ReduxZero" to false
				error number -128
			end if
			set plistpath to "/Library/Preferences/com.apple.xgrid.controller.plist"
			set maxproc to " ; echo 'kern.maxproc=512' >> /etc/sysctl.conf ; echo 'limit maxproc 512 532' >> /etc/launchd.conf ; sysctl -w kern.maxprocperuid=512 "
		end if
		do shell script "cp " & plistpath & " " & plistpath & ".oldplist$RANDOM ; cp " & thequotedapppath & "/Contents/Resources/com.apple.xgrid.controller.plist " & plistpath & " ; chmod 664 " & plistpath & maxproc & " ; /usr/sbin/xgridctl c on ; /usr/sbin/xgridctl c start  > /dev/null 2>&1 &" with administrator privileges
		close panel window of theObject
		if sysver is 8 then
			display alert "Restart Required" message "You must now restart in order to use Xgrid." as critical default button "Restart" other button (localized string "Cancel")
			if button returned of the result is "Restart" then
				tell application "System Events" to restart
				quit saving no
			end if
		end if
		(*		if contents of text field "path" of window "ReduxZero" is "" then
			set saveas to choose folder with prompt (localized string "saveloc") as string
			set saveasposix to POSIX path of saveas
			set content of text field "path" of window "ReduxZero" to saveasposix as string
		end if *)
	end if
	
	if name of theObject is "xgridcancel" then
		close panel window of theObject
		set content of button "xgrid" of window "ReduxZero" to false
	end if
	
	if name of theObject is "selectdvdaudio" then
		do shell script "/bin/echo " & ((get contents of popup button "dvdaudio" of window "dvdaudio") + 1) & " > /tmp/reduxzero_dvdaudio"
		close panel window of theObject
	end if
	
	
	if name of theObject is "advanced" then
		show window "advanced"
		--	set state of menu item "showadvanced" of menu "window" of main menu to true
	end if
	
	if name of theObject is "prefscancel" then
		set visible of window of theObject to false
	end if
	
	if name of theObject is "prefssave" then
		set contents of default entry "nice" of user defaults to (contents of button "nice" of window "Preferences")
		set contents of default entry "playsound" of user defaults to (contents of button "playsound" of window "Preferences")
		set contents of default entry "path" of user defaults to (contents of text field "path" of window "Preferences")
		--		do shell script "/usr/bin/defaults write com.reduxzeroweb.reduxzero nice " & (contents of button "nice" of window "Preferences")
		--		do shell script "/usr/bin/defaults write com.reduxzeroweb.reduxzero playsound " & (contents of button "playsound" of window "Preferences")
		--		do shell script "/usr/bin/defaults write com.reduxzeroweb.reduxzero path '" & (contents of text field "path" of window "Preferences") & "'"
		set visible of window of theObject to false
	end if
	
	if name of theObject is "fitonoff" then
		if content of button "fitonoff" of advanced is true then
			set content of text field "bitrate" of advanced to ""
			set enabled of text field "bitrate" of advanced to false
			set enabled of text field "bitratetitle" of advanced to false
			set enabled of text field "fit" of advanced to true
			
		else
			set enabled of text field "bitrate" of advanced to true
			set enabled of text field "bitratetitle" of advanced to true
			set enabled of text field "fit" of advanced to false
		end if
	end if
	
	if name of theObject is "forceonoff" then
		if content of button "forceonoff" of advanced is true then
			set enabled of popup button "forcetype" of advanced to true
		else
			set enabled of popup button "forcetype" of advanced to false
		end if
	end if
	
	if name of theObject is "dvdforce" then
		if content of button "dvdforce" of box "dvdadvbox" of advanced is true then
			set enabled of popup button "dvdaspect" of box "dvdadvbox" of advanced to true
		else
			set enabled of popup button "dvdaspect" of box "dvdadvbox" of advanced to false
		end if
	end if
	
	if name of theObject is "whendone" then
		if content of button "whendone" of window "ReduxZero" is true then
			set enabled of popup button "whendonemenu" of window "ReduxZero" to true
		else
			set enabled of popup button "whendonemenu" of window "ReduxZero" to false
		end if
	end if
	
	if name of theObject is "vcd" then
		if content of theObject is true then
			set enabled of slider "quality" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to false
			set enabled of button "mpeg2" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to false
		else
			set enabled of slider "quality" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
			set enabled of button "mpeg2" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
		end if
	end if
	
	if name of theObject is "h264" then
		--	if content of theObject is true then
		--		set content of cell "optim2" of matrix "optim" of tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero" to false
		--		set enabled of cell "optim2" of matrix "optim" of tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero" to false
		--		set content of cell "optim1" of matrix "optim" of tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero" to true
		--	else
		--		set enabled of cell "optim2" of matrix "optim" of tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero" to true
		--	end if
		update window "ReduxZero"
	end if
	
	if name of theObject is "optim1" or name of theObject is "optim2" or name of theObject is "optim3" then
		iphoneoff()
	end if
	
	if name of theObject is "optim4" then
		iphoneon()
	end if
	
	
	if name of theObject is "author" then
		if content of theObject is true then
			set enabled of slider "quality" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" to false
			set content of button "stitch" of window "ReduxZero" to true
			set enabled of button "stitch" of window "ReduxZero" to false
			set enabled of button "fitonoff" of advanced to false
			set enabled of text field "fit" of advanced to false
			set enabled of button "burn" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" to true
		else
			set content of button "stitch" of window "ReduxZero" to false
			set enabled of button "stitch" of window "ReduxZero" to true
			set enabled of button "fitonoff" of advanced to true
			set enabled of slider "quality" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" to true
			set enabled of button "burn" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" to false
		end if
	end if
	
	if name of theObject is "divxprofileonoff" then
		if content of button "divxprofileonoff" of tab view item "avibox" of tab view "tabbox" of window "ReduxZero" is true then
			set enabled of popup button "divxprofile" of tab view item "avibox" of tab view "tabbox" of window "ReduxZero" to true
		else
			set enabled of popup button "divxprofile" of tab view item "avibox" of tab view "tabbox" of window "ReduxZero" to false
		end if
	end if
	
	if name of theObject is "mpegprofileonoff" then
		if content of button "mpegprofileonoff" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" is true then
			set enabled of popup button "mpegprofile" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
			set enabled of button "mpeg2" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to false
			set content of button "mpeg2" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
		else
			set enabled of slider "quality" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
			set enabled of cell "pal" of matrix "format" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
			set enabled of popup button "mpegprofile" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to false
			set enabled of button "mpeg2" of tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero" to true
		end if
	end if
	
	if theObject is button "clearall" of window "ReduxZero" then
		delete every data row of data source of table view "files" of scroll view "files" of window "ReduxZero"
		--		tell button "plus" of window "ReduxZero" to set visible to false
		--		tell button "minus" of window "ReduxZero" to set visible to false
		--		tell text field "dragfiles" of window "ReduxZero" to set visible to false
		--		tell text field "dragfiles" of window "ReduxZero" to set visible to true
		--		tell button "plus" of window "ReduxZero" to set visible to true
		--		tell button "minus" of window "ReduxZero" to set visible to true
		update window "ReduxZero"
	end if
	
	if name of theObject is "saveas" then
		set saveas to choose folder with prompt (localized string "saveloc") as string
		set saveasposix to POSIX path of saveas
		set content of text field "path" of window of theObject to saveasposix as string
	end if
	
	if theObject is button "cancel" of window "ReduxZero" then
		set fullstarttime to contents of text field "fullstarttime" of window "ReduxZero"
		do shell script "echo cancel > /tmp/rztemp/" & fullstarttime & "/reduxzero_cancel"
		set indeterminate of progress indicator "bar" of window "ReduxZero" to true
		set content of text field "timeremaining" of window "ReduxZero" to (localized string "stopping")
		update window "ReduxZero"
	end if
	
	if name of theObject is "settingsclearall" then
		set contents of text field "croptop" of advanced to 0
		set contents of text field "cropbottom" of advanced to 0
		set contents of text field "cropleft" of advanced to 0
		set contents of text field "cropright" of advanced to 0
		set enabled of text field "croptop" of advanced to true
		set enabled of text field "cropbottom" of advanced to true
		set enabled of text field "cropleft" of advanced to true
		set enabled of text field "cropright" of advanced to true
		set contents of text field "width" of advanced to ""
		set contents of text field "height" of advanced to ""
		set contents of text field "bitrate" of advanced to ""
		set contents of button "fitonoff" of advanced to false
		set contents of button "forceonoff" of advanced to false
		set contents of button "twopass" of advanced to false
		set enabled of popup button "forcetype" of advanced to false
		set contents of text field "fit" of advanced to ""
		set contents of text field "videoffmpeg" of advanced to ""
		set contents of text field "audioffmpeg" of advanced to ""
		set contents of text field "framerate" of advanced to ""
		set contents of slider "volume" of advanced to 256
		set contents of button "deinterlace" of advanced to false
		set contents of text field "qmin" of advanced to ""
		set contents of text field "audbitrate" of advanced to ""
		set contents of popup button "audiokhz" of advanced to 0
		set contents of popup button "audiochannels" of advanced to 0
		
		set contents of text field "dvdvolname" of box "dvdadvbox" of advanced to ""
		set contents of popup button "dvdchapters" of box "dvdadvbox" of advanced to 0
		set enabled of popup button "dvdaspect" of box "dvdadvbox" of advanced to false
		set contents of button "dvdforce" of box "dvdadvbox" of advanced to false
		
	end if
	
	if name of theObject is "xgridoff" then
		do shell script "xgridctl c off ; xgridctl c stop" with administrator privileges
		set enabled of button "xgridoff" of window "Preferences" to false
	end if
	
	if theObject is button "showpreview" of advanced then
		if visible of window "Preview" is true then
			--tell application "System Events" to tell process "ReduxZero" to click button "generate" of window "preview"
			try
				do shell script "osascript -e 'tell application \"System Events\" to tell process \"ReduxZero\" to click button \"Generate\" of window \"Preview\"'"
			end try
		else
			show window "Preview"
			--		set state of menu item "showpreview" of menu "window" of main menu to true
		end if
	end if
	
	if theObject is button "settingssave" of advanced then
		set savefilebefore to (choose file name with prompt (localized string "settingssave") default name "settings.redz") --POSIX path of
		set savefile to (POSIX path of savefilebefore)
		set advanced to window "advanced"
		load nib "advloading"
		try
			set uses threaded animation of progress indicator "loader" of window "loading" to true
		end try
		tell progress indicator "loader" of window "loading" to start
		set contents of text field "loading" of window "loading" to (localized string "saving")
		display panel window "loading" attached to advanced
		
		
		do shell script "/usr/bin/defaults write  /tmp/reduxzero_savefile  croptop " & contents of text field "croptop" of advanced & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  cropbottom " & contents of text field "cropbottom" of advanced & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  cropleft " & contents of text field "cropleft" of advanced & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  cropright " & contents of text field "cropright" of advanced & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  width '" & contents of text field "width" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  height '" & contents of text field "height" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  bitrate '" & contents of text field "bitrate" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  fitonoff '" & contents of button "fitonoff" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  forceonoff '" & contents of button "forceonoff" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  twopass '" & contents of button "twopass" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  forcetype '" & (contents of popup button "forcetype" of advanced as string) & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  fit '" & contents of text field "fit" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  videoffmpeg '" & contents of text field "videoffmpeg" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  audioffmpeg '" & contents of text field "audioffmpeg" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  framerate '" & contents of text field "framerate" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  volume '" & contents of slider "volume" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  deinterlace '" & contents of button "deinterlace" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  qmin '" & contents of text field "qmin" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  audbitrate '" & contents of text field "audbitrate" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  audiokhz " & (contents of popup button "audiokhz" of advanced as string) & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  chapterevery " & (contents of popup button "dvdchapters" of box "dvdadvbox" of advanced) & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  dvdaspect " & (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced) & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  dvdforce '" & contents of button "dvdforce" of box "dvdadvbox" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  dvdvolname '" & contents of text field "dvdvolname" of box "dvdadvbox" of advanced & "'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  ver '135'" & " ;
/usr/bin/defaults write  /tmp/reduxzero_savefile  audiochannels " & (contents of popup button "audiochannels" of advanced as string)
		
		
		
		--	try
		----****THE ROUTINE TYPES****----
		set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
		do shell script "/usr/bin/defaults write  /tmp/reduxzero_savefile type " & type
		if type is "ipodbox" then
			ipodeasysave("/tmp/reduxzero_savefile")
		end if
		if type is "dvbox" then
			dveasysave("/tmp/reduxzero_savefile")
		end if
		if type is "mp4box" then
			mp4easysave("/tmp/reduxzero_savefile")
		end if
		if type is "avibox" then
			avieasysave("/tmp/reduxzero_savefile")
		end if
		if type is "wmvbox" then
			wmveasysave("/tmp/reduxzero_savefile")
		end if
		if type is "flashbox" then
			flasheasysave("/tmp/reduxzero_savefile")
		end if
		if type is "pspbox" then
			pspeasysave("/tmp/reduxzero_savefile")
		end if
		if type is "mpegbox" then
			mpegeasysave("/tmp/reduxzero_savefile")
		end if
		if type is "dvdbox" then
			dvdeasysave("/tmp/reduxzero_savefile")
		end if
		--	end try
		
		do shell script "mv /tmp/reduxzero_savefile.plist '" & savefile & "'" -- & ".redz'"
		tell progress indicator "loader" of window "loading" to stop
		close panel window "loading"
	end if
	
	if theObject is button "settingsload" of advanced then
		set savefilebefore to (choose file without invisibles) --POSIX path of
		set savefile to (POSIX path of savefilebefore)
		loadsettings()
	end if
	
	
end clicked

on choose menu item theObject
	
	if name of theObject is "showlogs" then
		do shell script "open ~/Library/Logs/reduxzeroweb"
	end if
	
	if name of theObject is "showmain" then
		show window "ReduxZero"
	end if
	
	if name of theObject is "optim" then
		iphoneoff()
		if content of theObject is presetipodtouch then
			ipodtouchon()
		end if
		if content of theObject is presetiphone then
			iphoneon()
		end if
	end if
	
	if name of theObject is "showadvanced" then
		if visible of window "Advanced" is true then
			hide window "Advanced"
			--		set state of menu item "showadvanced" of menu "window" of main menu to false
		else
			show window "Advanced"
			--		set state of menu item "showadvanced" of menu "window" of main menu to true
		end if
	end if
	
	if name of theObject is "showpreview" then
		if visible of window "Preview" is true then
			hide window "Preview"
			--		set state of menu item "showpreview" of menu "window" of main menu to false
		else
			show window "Preview"
			--		set state of menu item "showpreview" of menu "window" of main menu to true
		end if
	end if
	
	if name of theObject is "showvidinfo" then
		load nib "vidinfo"
		if visible of window "vidinfo" is true then
			hide window "vidinfo"
			--	set state of menu item "showvidinfo" of menu "window" of main menu to false
		else
			try
				vidinfo((quoted form of (contents of data cell 1 of selected data row of table view "files" of scroll view "files" of window "ReduxZero" as string))) of (load script file (POSIX file ((path of the main bundle as string) & "/Contents/Resources/Scripts/vidinfo.scpt")))
			end try
			show window "vidinfo"
			--	set state of menu item "showvidinfo" of menu "window" of main menu to true
		end if
	end if
	
	if name of theObject is "clear" then
		delete every data row of data source of table view "files" of scroll view "files" of window "ReduxZero"
		update window "ReduxZero"
	end if
	
	if name of theObject is "pause" then
		try
			do shell script "/bin/kill -SIGSTOP " & contents of text field "pid" of window "ReduxZero"
			set enabled of menu item "resume" of menu "file" of main menu to true
			set enabled of menu item "pause" of menu "file" of main menu to false
		end try
	end if
	
	if name of theObject is "resume" then
		try
			do shell script "/bin/kill -SIGCONT " & contents of text field "pid" of window "ReduxZero"
			set enabled of menu item "pause" of menu "file" of main menu to true
			set enabled of menu item "resume" of menu "file" of main menu to false
		end try
	end if
	
	if name of theObject is "divxprofile" then
		set avibox to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
		if contents of popup button "divxprofile" of avibox is 0 then
			set enabled of button "320" of avibox to true
		end if
		if contents of popup button "divxprofile" of avibox is 1 then
			set enabled of button "320" of avibox to true
		end if
		if contents of popup button "divxprofile" of avibox is 2 then
			set content of button "320" of avibox to true
			set enabled of button "320" of avibox to false
		end if
		if contents of popup button "divxprofile" of avibox is 3 then
			set enabled of button "320" of avibox to true
		end if
		if contents of popup button "divxprofile" of avibox is 4 then
			set enabled of button "320" of avibox to true
		end if
	end if
	
	if name of theObject is "mpegprofile" then
		set mpegbox to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
		if contents of popup button "mpegprofile" of mpegbox is 0 then
			set content of button "mpeg2" of mpegbox to false
			set enabled of slider "quality" of mpegbox to false
			set enabled of cell "pal" of matrix "format" of mpegbox to true
		end if
		if contents of popup button "mpegprofile" of mpegbox is 1 then
			set content of button "mpeg2" of mpegbox to true
			set enabled of slider "quality" of mpegbox to true
			set enabled of cell "pal" of matrix "format" of mpegbox to true
		end if
		if contents of popup button "mpegprofile" of mpegbox is 2 then
			set content of button "mpeg2" of mpegbox to true
			set content of button "mpeg2" of mpegbox to true
			set enabled of cell "pal" of matrix "format" of mpegbox to true
			set enabled of slider "quality" of mpegbox to true
		end if
		if contents of popup button "mpegprofile" of mpegbox is 3 then
			set content of button "mpeg2" of mpegbox to true
			set content of button "mpeg2" of mpegbox to true
			set enabled of slider "quality" of mpegbox to true
			set content of cell "pal" of matrix "format" of mpegbox to false
			set enabled of cell "pal" of matrix "format" of mpegbox to false
			set content of cell "ntsc" of matrix "format" of mpegbox to true
		end if
		if contents of popup button "mpegprofile" of mpegbox is 4 then
			set content of button "mpeg2" of mpegbox to true
			set content of button "mpeg2" of mpegbox to true
			set enabled of slider "quality" of mpegbox to true
			set enabled of cell "pal" of matrix "format" of mpegbox to true
		end if
		if contents of popup button "mpegprofile" of mpegbox is 5 then
			set content of button "mpeg2" of mpegbox to true
			set content of button "mpeg2" of mpegbox to true
			set enabled of cell "pal" of matrix "format" of mpegbox to false
			set enabled of slider "quality" of mpegbox to false
		end if
		if contents of popup button "mpegprofile" of mpegbox is 6 then
			set content of button "mpeg2" of mpegbox to true
			set content of button "mpeg2" of mpegbox to true
			set enabled of cell "pal" of matrix "format" of mpegbox to false
			set enabled of slider "quality" of mpegbox to false
		end if
	end if
	
	if theObject is menu item "add" of menu "file" of main menu then
		set video to choose file without invisibles
		set AppleScript's text item delimiters to ""
		set inputvideo to POSIX path of video as string
		if ".eyetv/" is in (((text items -7 through -1 of (POSIX path of video as string))) as string) then
			set inputvideo to (text items 1 through -2 of (POSIX path of video as string)) as string
		end if
		if ".iMovieProject/" is in (((text items -15 through -1 of (POSIX path of video as string))) as string) then
			set inputvideo to (text items 1 through -2 of (POSIX path of video as string)) as string
		end if
		set newrow to make new data row at end of data rows of data source of table view "files" of scroll view "files" of window "ReduxZero"
		set contents of data cell "Files" of newrow to inputvideo
		update window "ReduxZero"
	end if
	
	if theObject is menu item "preferences" of menu "vismenu" of main menu then
		show window "Preferences"
		try
			set contents of text field "path" of window "Preferences" to (contents of default entry "path" of user defaults as string)
		end try
		set enabled of button "xgridoff" of window "Preferences" to false
		try
			set sysver to (do shell script "uname -r | cut -c 1") as number
			if sysver is 4 then
				if "xgridcontrollerd" is in (do shell script "xgridctl status") then
					set enabled of button "xgridoff" of window "Preferences" to true
				else
					set enabled of button "xgridoff" of window "Preferences" to false
				end if
			end if
		end try
		
		try
			if (contents of default entry "playsound" of user defaults as string) is "true" then
				set contents of button "playsound" of window "Preferences" to true
			else
				set contents of button "playsound" of window "Preferences" to false
			end if
		end try
		try
			if (contents of default entry "nice" of user defaults as string) is "true" then
				set contents of button "nice" of window "Preferences" to true
			else
				set contents of button "nice" of window "Preferences" to false
			end if
		end try
	end if
	
	
	if name of theObject is "resetreduxzero" then
		display alert (localized string "resettitle") message (localized string "resettext") as warning default button (localized string "OK") alternate button (localized string "Cancel")
		if button returned of the result is (localized string "ok") then
			set tilde to ""
			set rzver to "135"
			set quotedapppath to quoted form of (path of main bundle as string)
			set ffmpegloc to (quotedapppath & "/Contents/Resources/")
			do shell script "/bin/sh -c '/bin/rm ~/Library/Preferences/com.reduxzeroweb.reduxzero.plist ; /bin/rm /Library/Preferences/com.reduxzeroweb.reduxzero.plist ; /bin/rm -r /tmp/rztemp ; /usr/bin/killall ReduxZero ; /bin/sleep 1 ; /usr/bin/open '" & quotedapppath & "' ; exit 0' &> /dev/null &"
		end if
	end if
	
	
end choose menu item


on open theObject
	--theObject as alias
	try
		set text item delimiters to "."
		first item of theObject as string
		set ext to last text item of the result
		--		tell application "Finder" to set ext to get name extension of file the result
		if ext is "redz" then
			set savefile to (POSIX path of theObject)
			show window "Advanced"
			loadsettings()
		else
			-- For every item in the list, make a new data row and set it's contents
			
			repeat with theItem in theObject
				set newrow to make new data row at end of data rows of data source of table view "files" of scroll view "files" of window "ReduxZero"
				set contents of data cell "files" of newrow to theItem
			end repeat
			update window "ReduxZero"
			return true
		end if
	end try
end open

on resized theObject
	try
		set {winwidth, winheight} to get size of window "ReduxZero"
		set width of table column "files" of (table view "files" of scroll view "files" of window "ReduxZero") to (winwidth - 80)
		set thePath to path of the main bundle as string
		set thequotedapppath to quoted form of thePath
		--delay 0.1
		do shell script thequotedapppath & "/Contents/Resources/resizer > /dev/null 2>&1 &" -- "if /bin/test -f /tmp/reduxzero_sizer; then exit 0; fi; " & 
		update window "ReduxZero"
		--do shell script "sh -c " & backslash  & ""osascript -l AppleScript -e 'tell application " & backslash  & "" & backslash  & "" & backslash  & ""ReduxZero" & backslash  & "" & backslash  & "" & backslash  & "" to update window " & backslash  & "" & backslash  & "" & backslash  & ""ReduxZero" & backslash  & "" & backslash  & "" & backslash  & ""'" & backslash  & ""  > /dev/null 2>&1 &"
	end try
end resized

on should close theObject
	set visible of theObject to false
end should close

on selected tab view item theObject tab view item tabViewItem
	set advanced to window "advanced"
	set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
	if type is "ipodbox" then
		set enabled of button "stitch" of window "ReduxZero" to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "dvbox" then
		set enabled of button "stitch" of window "ReduxZero" to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to false
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to false
		set enabled of button "fitonoff" of advanced to false
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "mp4box" then
		set enabled of button "stitch" of window "ReduxZero" to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "avibox" then
		set enabled of button "stitch" of window "ReduxZero" to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "wmvbox" then
		set enabled of button "stitch" of window "ReduxZero" to false
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to false
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "flashbox" then
		set enabled of button "stitch" of window "ReduxZero" to false
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "pspbox" then
		set visible of box "pspadvbox" of advanced to true
		set enabled of button "stitch" of window "ReduxZero" to false
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set size of window "advanced" to {388, 460}
		set visible of box "dvdadvbox" of advanced to false
	end if
	if type is "mpegbox" then
		set enabled of button "stitch" of window "ReduxZero" to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set size of window "advanced" to {388, 393}
		set enabled of text field "fit" of advanced to true
		set enabled of button "fitonoff" of advanced to true
		set visible of box "dvdadvbox" of advanced to false
		set visible of box "pspadvbox" of advanced to false
	end if
	if type is "dvdbox" then
		set visible of box "dvdadvbox" of advanced to true
		set content of button "stitch" of window "ReduxZero" to false
		set enabled of button "stitch" of window "ReduxZero" to false
		set enabled of button "twopass" of advanced to true
		set enabled of button "fitonoff" of advanced to false
		set enabled of text field "fit" of advanced to false
		set size of window "advanced" to {388, 480}
		set visible of box "pspadvbox" of advanced to false
	end if
end selected tab view item


on should quit theObject
	if content of text field "timeremaining" of window "ReduxZero" is not "" then
		if (localized string "Cancel") is "Cancel" then
			set thiscancel to "Continue"
		else
			set thiscancel to (localized string "Cancel")
		end if
		display alert (localized string "quitwarn1") message (localized string "quitwarn2") as critical default button "Quit" other button thiscancel
		if button returned of the result is "Quit" then
			return true
		else
			return false
		end if
	else
		return true
	end if
end should quit


on will quit theObject
	try
		set {winwidth, winheight} to get size of window "ReduxZero"
		set {winx, winy} to get position of window "ReduxZero"
		if winwidth is 0 or winheight is 0 or winx < 0 or winy < 0 then
			error
		end if
		set contents of default entry "winwidth" of user defaults to winwidth
		set contents of default entry "winheight" of user defaults to winheight
		set contents of default entry "winx" of user defaults to winx
		set contents of default entry "winy" of user defaults to winy
	end try
	try
		set {winx, winy} to get position of window "advanced"
		if winx < 0 or winy < 0 then
			error
		end if
		set contents of default entry "advopen" of user defaults to (visible of window "advanced" as string)
		set contents of default entry "advx" of user defaults to winx
		set contents of default entry "advy" of user defaults to winy
	end try
	set visible of window "ReduxZero" to false
	set visible of window "advanced" to false
	try
		do shell script "/bin/kill " & contents of text field "pid" of window "ReduxZero"
	end try
	try
		if contents of button "forceonoff" of advanced is true then
			if (get contents of popup button "forcetype" of advanced) is 2 then
				do shell script "killall clivlc"
			end if
		end if
	end try
	try
		if content of button "xgrid" of window "ReduxZero" is true then
			do shell script "killall httpd"
		end if
	end try
	try
		do shell script "rm /tmp/reduxzero_*"
	end try
	--	try
	--		do shell script "/bin/rm -rf /tmp/redz_DVD"
	--	end try
	try
		----****THE ROUTINE TYPES****----
		set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
		set contents of default entry "type" of user defaults to type
		if type is "ipodbox" then
			ipodeasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "dvbox" then
			dveasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "mp4box" then
			mp4easysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "avibox" then
			avieasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "wmvbox" then
			wmveasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "flashbox" then
			flasheasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "pspbox" then
			pspeasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "mpegbox" then
			mpegeasysave("com.reduxzeroweb.reduxzero")
		end if
		if type is "dvdbox" then
			dvdeasysave("com.reduxzeroweb.reduxzero")
		end if
	end try
	return true
end will quit

on rows changed theObject
	update window "ReduxZero"
end rows changed


on selection changed theObject
	if name of theObject is "videoffmpeg" then
		set thecombo to combo box "videoffmpeg" of window "advanced"
		set whichone to (get current item of thecombo)
		if whichone is 1 then
			set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
			if type is not "mp4box" then
				do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-refs 2 -mbd 2 -me full -subq 6 -me_range 21 -me_threshold 6 -i_qfactor 0.71428572" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
			else
				do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-refs 5 -mbd 2 -me full -subq 6 -me_range 21 -me_threshold 6 -i_qfactor 0.71428572" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
			end if
		end if
		if whichone is 2 then
			set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
			if type is not "mp4box" then
				do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-refs 2 -mbd 2 -me full -subq 6 -me_range 21 -me_threshold 6 -i_qfactor 0.71428572 -deblockalpha 1 -deblockbeta 1" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
			else
				do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-refs 5 -mbd 2 -me full -subq 6 -me_range 21 -me_threshold 6 -i_qfactor 0.71428572 -deblockalpha 1 -deblockbeta 1" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
			end if
		end if
		if whichone is 3 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-vframes n" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
		if whichone is 4 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-ss n" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
		if whichone is 5 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-vcodec copy" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
		if whichone is 6 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-vcodec xvid -mbd 2 -me full -flags +4mv+trell -aic 2 -cmp 2 -subcmp 2" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
		if whichone is 7 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-g n" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
		if whichone is 8 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"videoffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-async 0" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
	end if
	if name of theObject is "audioffmpeg" then
		set thecombo to combo box "audioffmpeg" of window "advanced"
		set whichone to (get current item of thecombo)
		if whichone is 1 then
			do shell script "sh -c \"osascript -l AppleScript -e 'tell application " & backslash & "\"ReduxZero" & backslash & "\"' -e 'set contents of combo box " & backslash & "\"audioffmpeg" & backslash & "\" of window " & backslash & "\"advanced" & backslash & "\" to " & backslash & "\"-acodec copy" & backslash & "\"' -e 'end tell'\"  > /dev/null 2>&1 &"
		end if
	end if
end selection changed





on loadsettings()
	set advanced to window "advanced"
	load nib "advloading"
	try
		set uses threaded animation of progress indicator "loader" of window "loading" to true
	end try
	tell progress indicator "loader" of window "loading" to start
	set contents of text field "loading" of window "loading" to (localized string "loading")
	display panel window "loading" attached to advanced
	do shell script "cp '" & savefile & "' /tmp/rzsettings.plist"
	set contents of text field "croptop" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings croptop")
	set contents of text field "cropbottom" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings cropbottom")
	set contents of text field "cropleft" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings cropleft")
	set contents of text field "cropright" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings cropright")
	set contents of text field "width" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings width")
	set contents of text field "height" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings height")
	set contents of text field "bitrate" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings bitrate")
	if (do shell script "/usr/bin/defaults read /tmp/rzsettings deinterlace") is "true" then
		set contents of button "deinterlace" of advanced to true
	else
		set contents of button "deinterlace" of advanced to false
	end if
	set contents of text field "framerate" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings framerate")
	set contents of text field "qmin" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings qmin")
	set contents of text field "fit" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings fit")
	if (do shell script "/usr/bin/defaults read /tmp/rzsettings fitonoff") is "true" then
		set contents of button "fitonoff" of advanced to true
		set enabled of text field "bitrate" of advanced to false
	else
		set contents of button "fitonoff" of advanced to false
		set enabled of text field "bitrate" of advanced to true
	end if
	if (do shell script "/usr/bin/defaults read /tmp/rzsettings twopass") is "true" then
		set contents of button "twopass" of advanced to true
	else
		set contents of button "twopass" of advanced to false
	end if
	set contents of text field "audbitrate" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings audbitrate")
	set (contents of popup button "forcetype" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings forcetype")
	set (contents of popup button "audiokhz" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings audiokhz")
	set (contents of popup button "audiochannels" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings audiochannels")
	try
		set (contents of popup button "dvdchapters" of box "dvdadvbox" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings chapterevery")
		set (contents of text field "dvdvolname" of box "dvdadvbox" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings dvdvolname")
		
		set (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced) to (do shell script "/usr/bin/defaults read /tmp/rzsettings dvdaspect")
		if (do shell script "/usr/bin/defaults read /tmp/rzsettings dvdforce") is "true" then
			set (contents of button "dvdforce" of box "dvdadvbox" of advanced) to true
			set enabled of popup button "dvdaspect" of box "dvdadvbox" of advanced to true
		else
			set (contents of button "dvdforce" of box "dvdadvbox" of advanced) to false
			set enabled of popup button "dvdaspect" of box "dvdadvbox" of advanced to false
		end if
	end try
	
	if (do shell script "/usr/bin/defaults read /tmp/rzsettings forceonoff") is "true" then
		set contents of button "forceonoff" of advanced to true
		set enabled of popup button "forcetype" of advanced to true
	else
		set contents of button "forceonoff" of advanced to false
		set enabled of popup button "forcetype" of advanced to false
	end if
	set contents of text field "videoffmpeg" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings videoffmpeg")
	set contents of text field "audioffmpeg" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings audioffmpeg")
	set contents of text field "framerate" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings framerate")
	set contents of slider "volume" of advanced to (do shell script "/usr/bin/defaults read /tmp/rzsettings volume")
	try
		----****THE ROUTINE TYPES****----
		set type to do shell script "defaults read /tmp/rzsettings type"
		if type is "ipodbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
			ipodeasyset("/tmp/rzsettings")
		end if
		if type is "dvbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "dvbox" of tab view "tabbox" of window "ReduxZero"
			dveasyset("/tmp/rzsettings")
		end if
		if type is "mp4box" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "mp4box" of tab view "tabbox" of window "ReduxZero"
			mp4easyset("/tmp/rzsettings")
		end if
		if type is "avibox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
			avieasyset("/tmp/rzsettings")
		end if
		if type is "wmvbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "wmvbox" of tab view "tabbox" of window "ReduxZero"
			wmveasyset("/tmp/rzsettings")
		end if
		if type is "flashbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "flashbox" of tab view "tabbox" of window "ReduxZero"
			flasheasyset("/tmp/rzsettings")
		end if
		if type is "pspbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
			pspeasyset("/tmp/rzsettings")
		end if
		if type is "mpegbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
			mpegeasyset("/tmp/rzsettings")
		end if
		if type is "dvdbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero"
			dvdeasyset("/tmp/rzsettings")
		end if
	end try
	tell progress indicator "loader" of window "loading" to stop
	close panel window "loading"
	try
		do shell script "rm /tmp/rzsettings.plist"
	end try
end loadsettings


on iphoneoff()
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	set content of text field "ipodtiny" of ipodbox to content of text field "psptiny" of pspbox
	set content of text field "ipodlow" of ipodbox to content of text field "psplow" of pspbox
	set content of text field "ipodstandard" of ipodbox to content of text field "pspstandard" of pspbox
	update window "ReduxZero"
end iphoneoff

on iphoneon()
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	set content of text field "ipodtiny" of ipodbox to "EDGE"
	set content of text field "ipodlow" of ipodbox to "3G"
	set content of text field "ipodstandard" of ipodbox to "WiFi"
	update window "ReduxZero"
end iphoneon

on ipodtouchon()
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	set content of text field "ipodlow" of ipodbox to "WiFi"
	update window "ReduxZero"
end ipodtouchon

on launched theObject
	--	load nib "nothing"
	--	show window "nothing"
	make new default entry at end of default entries of user defaults with properties {name:"name", contents:"none"}
	make new default entry at end of default entries of user defaults with properties {name:"email", contents:"none"}
	make new default entry at end of default entries of user defaults with properties {name:"serial", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"path", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"playsound", contents:"true"}
	make new default entry at end of default entries of user defaults with properties {name:"nice", contents:"true"}
	make new default entry at end of default entries of user defaults with properties {name:"winwidth", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"winheight", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"winx", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"winy", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"vlcloc", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"type", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"advx", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"advy", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"advopen", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"tmpdir", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"xgridcontroller", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"dvdlanguage", contents:""}
	make new default entry at end of default entries of user defaults with properties {name:"dvd4.38", contents:"false"}
	make new default entry at end of default entries of user defaults with properties {name:"ver", contents:"132"}
	make new default entry at end of default entries of user defaults with properties {name:"dvdpipe", contents:"play_title"}
	make new default entry at end of default entries of user defaults with properties {name:"alwaysfaststart", contents:"false"}
	
	
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	
	systemhealth()
	
	
	--clean up all temp files
	try
		do shell script "rm -rf /tmp/reduxzero* /tmp/*.m4a /tmp/*.wav /tmp/*.mp4"
	end try
	
	set advanced to window "advanced"
	
	set visible of box "dvdadvbox" of advanced to false
	set visible of box "pspadvbox" of advanced to false
	
	--REBUILD ITUNES OPTIM LIST
	tell menu of popup button "optim" of tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
		set localizedall to title of menu item 1
		delete every menu item
		make new menu item at end of menu items with properties {title:localizedall}
		make new menu item at end of menu items with properties {title:"iPod 5G"}
		make new menu item at end of menu items with properties {title:"iPod classic"}
		make new menu item at end of menu items with properties {title:"iPod nano"}
		make new menu item at end of menu items with properties {title:"iPod touch"}
		make new menu item at end of menu items with properties {title:"iPhone"}
		make new menu item at end of menu items with properties {title:"Apple TV"}
		make new menu item at end of menu items with properties {title:"Apple TV 5.1"}
		make new menu item at end of menu items with properties {title:"Apple TV 5.1 + 2.0"}
	end tell
	
	try
		----****THE ROUTINE TYPES****----
		set type to contents of default entry "type" of user defaults as string
		if type is "ipodbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
			ipodeasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "dvbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "dvbox" of tab view "tabbox" of window "ReduxZero"
			dveasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "mp4box" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "mp4box" of tab view "tabbox" of window "ReduxZero"
			mp4easyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "avibox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
			avieasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "wmvbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "wmvbox" of tab view "tabbox" of window "ReduxZero"
			wmveasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "flashbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "flashbox" of tab view "tabbox" of window "ReduxZero"
			flasheasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "pspbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
			pspeasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "mpegbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
			mpegeasyset("com.reduxzeroweb.reduxzero")
		end if
		if type is "dvdbox" then
			set current tab view item of tab view "tabbox" of window "ReduxZero" to tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero"
			dvdeasyset("com.reduxzeroweb.reduxzero")
		end if
	end try
	
	tell button "cancel" of window "ReduxZero" to set visible to false
	
	try
		if (do shell script " echo " & (ASCII character 128) & "a") is "a" then
			set backslash to (ASCII character 128)
		else
			set backslash to "\\"
		end if
	on error
		set backslash to "\\"
	end try
	
	-- Create the data source for the table view
	set theDataSource to make new data source at end of data sources with properties {name:"files"}
	--	set allows reordering of theDataSource to true
	try
		set allows reordering of theDataSource to true
	end try
	--set auto resizes all columns to fit of theDataSource to true
	-- Create the "files" data column
	make new data column at end of data columns of theDataSource with properties {name:"files"}
	
	
	-- Assign the data source to the table view
	--set data source of theObject to theDataSource --table view "files" of scroll view "files" of window "ReduxZero"
	--	set data source of table view "dragger" of scroll view "dragger" of window "ReduxZero" to theDataSource
	set data source of table view "files" of scroll view "files" of window "ReduxZero" to theDataSource
	set data source of table view "dragger" of scroll view "dragger" of window "ReduxZero" to theDataSource
	
	-- Register for the "color" and "file names" drag types
	tell table view "dragger" of scroll view "dragger" of window "ReduxZero" to register drag types {"file names"}
	--	set allows reordering of table view "files" of scroll view "files" of window "ReduxZero" to true
	--	set auto resizes all columns to fit of (table view "files" of scroll view "files" of window "ReduxZero") to true
	
	
	try
		set smallsysver to text item 4 of (system version of (system info))
		if smallsysver < 4 or smallsysver > 4 then
			set visible of button "xgrid" of window "ReduxZero" to false
		end if
	on error
		set visible of button "xgrid" of window "ReduxZero" to false
	end try
	set enabled of menu item "resume" of menu "file" of main menu to false
	set enabled of menu item "pause" of menu "file" of main menu to false
	
	
	set rzver to "135"
	set downloadingfirst to false
	set ffmpegloc to (thequotedapppath & "/Contents/Resources/")
	if "admin" is not in (do shell script "/usr/bin/id") then
		if (do shell script "test -f ~/Library/Preferences/com.reduxzeroweb.reduxzero.plist ; echo $?") is "1" then
			try
				do shell script "cp /Library/Preferences/com.reduxzeroweb.reduxzero.plist ~/Library/Preferences/com.reduxzeroweb.reduxzero.plist"
			end try
		end if
	end if
	
	
	try
		set contents of text field "path" of window "ReduxZero" to (contents of default entry "path" of user defaults as string)
	end try
	try
		set winwidth to (contents of default entry "winwidth" of user defaults as number)
		set winheight to (contents of default entry "winheight" of user defaults as number)
		set winx to (contents of default entry "winx" of user defaults as number)
		set winy to (contents of default entry "winy" of user defaults as number)
		if winwidth is 0 or winheight is 0 or winx < 0 or winy < 0 then
			error
		end if
		set size of window "ReduxZero" to {winwidth, winheight}
		set position of window "ReduxZero" to {winx, winy}
	end try
	try
		set winx to (contents of default entry "advx" of user defaults as number)
		set winy to (contents of default entry "advy" of user defaults as number)
		if winx < 0 or winy < 0 then
			error
		end if
		set position of window "advanced" to {winx, winy}
	end try
	
	try
		if comlink() of (load script file (POSIX file (thePath & "/Contents/Resources/Scripts/automation.scpt"))) is true then
			set title of window "ReduxZero" to "ReduxZero 1.x Automation Tech Preview"
		end if
	end try
	
	show window "ReduxZero"
	
	try
		if (contents of default entry "advopen" of user defaults as string) is "true" then
			show window "advanced"
			--	set state of menu item "showadvanced" of menu "window" of main menu to true
		end if
	end try
	
end launched

on systemhealth()
	set errors to 0
	set tmpok to true
	set headok to true
	set pathok to true
	set uucodeok to true
	set bzipok to true
	set gzipok to true
	set perlok to true
	
	try
		do shell script "echo test ; exit 0"
	on error
		show window "ReduxZero"
		display alert (localized string "Fatal System Error") message ("Critical components of Mac OS X are missing or damaged on your system. Without them, ReduxZero is unable to continue.
The affected components is/are:

AppleScript's Standard Additions. This may require a reinstallation of Mac OS X.

ReduxZero will now quit.") as warning default button "Quit"
		quit
		error number -128
	end try
	
	do shell script "echo test > /tmp/rztest ; exit 0"
	do shell script "/bin/cat /tmp/rztest ; exit 0"
	if the result is not "test" then
		try
			do shell script "/bin/chmod -R 777 /tmp ; exit 0"
			do shell script "/bin/rm -f /tmp/rztest ; exit 0"
		end try
		do shell script "echo test > /tmp/rztest ; exit 0"
		do shell script "/bin/cat /tmp/rztest ; exit 0"
		if the result is not "test" then
			set errors to (errors + 1)
			set tmpok to false
		end if
	end if
	do shell script "echo 'test
tset' | /usr/bin/head -1 ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set headok to false
	end if
	do shell script "echo 'test,test' | awk -F , '{print $1}' ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set pathok to false
	end if
	do shell script "echo test | /usr/bin/uuencode -m - | /usr/bin/uudecode -p ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set uucodeok to false
	end if
	do shell script "echo test | /usr/bin/gzip | /usr/bin/gunzip ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set gzipok to false
	end if
	do shell script "echo test | /usr/bin/bzip2 | /usr/bin/bunzip2 ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set bzipok to false
	end if
	do shell script "/bin/echo \"print 'test';\" | /usr/bin/perl - ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set perlok to false
	end if
	if errors is 0 then
		return true
	else
		show window "ReduxZero"
		set whichbrokens to ""
		if tmpok is false then
			set whichbrokens to (whichbrokens & "- /tmp Temporary Directory. Try Repairing Permissions using Disk Utility.
")
		end if
		if headok is false then
			set whichbrokens to (whichbrokens & "- UNIX command 'head' - This is caused by additional Perl software overwriting the built-in 'head' command. 
")
		end if
		if pathok is false then
			set whichbrokens to (whichbrokens & "- UNIX $PATH. If you have modified your $PATH, make sure it contains '/usr/bin:/bin:/usr/sbin:/sbin'. 
")
		end if
		if uucodeok is false then
			set whichbrokens to (whichbrokens & "- uuencode/uudecode. This may require a reinstallation of Mac OS X.
")
		end if
		if gzipok is false then
			set whichbrokens to (whichbrokens & "- gzip compression library. This may require a reinstallation of Mac OS X.
")
		end if
		if bzipok is false then
			set whichbrokens to (whichbrokens & "- bzip2 compression library. This may require a reinstallation of Mac OS X.
")
		end if
		if perlok is false then
			set whichbrokens to (whichbrokens & "- perl scripting library. This may require a reinstallation of Mac OS X.
")
		end if
		display alert (localized string "Fatal System Error") message ("Critical components of Mac OS X are missing or damaged on your system. Without them, ReduxZero is unable to continue.
The affected components is/are:

" & whichbrokens & "
ReduxZero will now quit.") as warning default button "Quit"
		quit
		error number -128
		return false
	end if
end systemhealth

on should select row theObject row theRow
	try
		set vidinfoopen to visible of window "vidinfo"
	on error
		set vidinfoopen to false
	end try
	if vidinfoopen is true then
		vidinfo((quoted form of (contents of data cell 1 of data row theRow of data column "Files" of the data source of table view "files" of scroll view "files" of window "ReduxZero" as string))) of (load script file (POSIX file ((path of the main bundle as string) & "/Contents/Resources/Scripts/vidinfo.scpt")))
	end if
	return true
end should select row

on mouse exited theObject event theEvent
	(*Add your script here.*)
end mouse exited

on mouse entered theObject event theEvent
	(*Add your script here.*)
end mouse entered

on ipodeasyset(prefloc)
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	iphoneoff()
	set content of popup button "optim" of ipodbox to presetall
	if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim1") is "true" then
		set content of popup button "optim" of ipodbox to presetipod5g
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim3") is "true" then
		set content of popup button "optim" of ipodbox to presetappletv
	end if
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim4") is "true" then
			set content of popup button "optim" of ipodbox to presetiphone
			iphoneon()
		end if
	end try
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim5") is "true" then
			set content of popup button "optim" of ipodbox to presetipodnano
		end if
	end try
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim6") is "true" then
			set content of popup button "optim" of ipodbox to presetipodclassic
		end if
	end try
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim7") is "true" then
			set content of popup button "optim" of ipodbox to presetipodtouch
			ipodtouchon()
		end if
	end try
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim8") is "true" then
			set content of popup button "optim" of ipodbox to presetappletv51
		end if
	end try
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " ipodoptim9") is "true" then
			set content of popup button "optim" of ipodbox to presetappletv5120
		end if
	end try
	if (do shell script "/usr/bin/defaults read " & prefloc & " ipodautoadd") is "true" then
		set contents of button "autoadd" of ipodbox to true
	else
		set contents of button "autoadd" of ipodbox to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " ipodh264") is "true" then
		set contents of button "h264" of ipodbox to true
	else
		set contents of button "h264" of ipodbox to false
	end if
	set contents of slider "quality" of ipodbox to (do shell script "/usr/bin/defaults read " & prefloc & " ipodquality")
end ipodeasyset

on pspeasyset(prefloc)
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	set visible of box "pspadvbox" of window "advanced" to true
	if (do shell script "/usr/bin/defaults read " & prefloc & " pspoptim1") is "true" then
		set content of cell "optim1" of matrix "optim" of pspbox to true
		set content of cell "optim2" of matrix "optim" of pspbox to false
	else
		set content of cell "optim1" of matrix "optim" of pspbox to false
		set content of cell "optim2" of matrix "optim" of pspbox to true
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " pspthumb") is "true" then
		set contents of button "thumb" of pspbox to true
	else
		set contents of button "thumb" of pspbox to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " psph264") is "true" then
		set contents of button "h264" of pspbox to true
	else
		set contents of button "h264" of pspbox to false
	end if
	set contents of slider "quality" of pspbox to (do shell script "/usr/bin/defaults read " & prefloc & " pspquality")
end pspeasyset

on dveasyset(prefloc)
	set dvbox to tab view item "dvbox" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " dvntsc") is "true" then
		set content of cell "ntsc" of matrix "format" of dvbox to true
		set content of cell "pal" of matrix "format" of dvbox to false
	else
		set content of cell "ntsc" of matrix "format" of dvbox to false
		set content of cell "pal" of matrix "format" of dvbox to true
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " dvwidescreen") is "true" then
		set contents of button "widescreen" of dvbox to true
	else
		set contents of button "widescreen" of dvbox to false
	end if
	try
		if (do shell script "/usr/bin/defaults read " & prefloc & " dvfcp") is "true" then
			set contents of button "fcp" of dvbox to true
		else
			set contents of button "fcp" of dvbox to false
		end if
	end try
end dveasyset


on dvdeasyset(prefloc)
	set dvdbox to tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero"
	set visible of box "dvdadvbox" of window "advanced" to true
	if (do shell script "/usr/bin/defaults read " & prefloc & " dvdntsc") is "true" then
		set content of cell "ntsc" of matrix "format" of dvdbox to true
		set content of cell "pal" of matrix "format" of dvdbox to false
	else
		set content of cell "ntsc" of matrix "format" of dvdbox to false
		set content of cell "pal" of matrix "format" of dvdbox to true
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " dvdauthor") is "true" then
		set contents of button "author" of dvdbox to true
		set enabled of slider "quality" of dvdbox to false
		set enabled of button "fitonoff" of advanced to false
		set enabled of text field "fit" of advanced to false
	else
		set enabled of button "fitonoff" of advanced to true
		set contents of button "author" of dvdbox to false
		set enabled of slider "quality" of dvdbox to true
	end if
	set contents of slider "quality" of dvdbox to (do shell script "/usr/bin/defaults read " & prefloc & " dvdquality")
	if (do shell script "/usr/bin/defaults read " & prefloc & " dvdburn") is "true" then
		set contents of button "burn" of dvdbox to true
	else
		set contents of button "burn" of dvdbox to false
	end if
end dvdeasyset

on avieasyset(prefloc)
	set avibox to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " avi320") is "true" then
		set content of button "320" of avibox to true
	else
		set content of button "320" of avibox to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " avidivxprofileonoff") is "true" then
		set contents of button "divxprofileonoff" of avibox to true
		set enabled of popup button "divxprofile" of avibox to true
	else
		set contents of button "divxprofileonoff" of avibox to false
		set enabled of popup button "divxprofile" of avibox to true
	end if
	set contents of slider "quality" of avibox to (do shell script "/usr/bin/defaults read " & prefloc & " aviquality")
	set contents of popup button "divxprofile" of avibox to (do shell script "/usr/bin/defaults read " & prefloc & " avidivxprofile")
end avieasyset

on mp4easyset(prefloc)
	set mp4box to tab view item "mp4box" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " mp4320") is "true" then
		set content of button "320" of mp4box to true
	else
		set content of button "320" of mp4box to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " mp4hint") is "true" then
		set contents of button "hint" of mp4box to true
	else
		set contents of button "hint" of mp4box to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " mp4h264") is "true" then
		set contents of button "h264" of mp4box to true
	else
		set contents of button "h264" of mp4box to false
	end if
	set contents of slider "quality" of mp4box to (do shell script "/usr/bin/defaults read " & prefloc & " mp4quality")
end mp4easyset

on wmveasyset(prefloc)
	set wmvbox to tab view item "wmvbox" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " wmv320") is "true" then
		set content of button "320" of wmvbox to true
	else
		set content of button "320" of wmvbox to false
	end if
	set contents of slider "quality" of wmvbox to (do shell script "/usr/bin/defaults read " & prefloc & " wmvquality")
end wmveasyset

on mpegeasyset(prefloc)
	set mpegbox to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " mpegntsc") is "true" then
		set content of cell "ntsc" of matrix "format" of mpegbox to true
		set content of cell "pal" of matrix "format" of mpegbox to false
	else
		set content of cell "ntsc" of matrix "format" of mpegbox to false
		set content of cell "pal" of matrix "format" of mpegbox to true
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " mpegmpegprofileonoff") is "true" then
		set enabled of button "mpeg2" of mpegbox to false
		set contents of button "mpegprofileonoff" of mpegbox to true
		set enabled of popup button "mpegprofile" of mpegbox to true
	else
		set contents of button "mpegprofileonoff" of mpegbox to false
		set enabled of cell "pal" of matrix "format" of mpegbox to true
		set enabled of popup button "mpegprofile" of mpegbox to false
	end if
	set contents of popup button "mpegprofile" of mpegbox to (do shell script "/usr/bin/defaults read " & prefloc & " mpegmpegprofile")
	if contents of popup button "mpegprofile" of mpegbox is 0 then
		set enabled of slider "quality" of mpegbox to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " mpegmpeg2") is "true" then
		set content of button "mpeg2" of mpegbox to true
	else
		set content of button "mpeg2" of mpegbox to false
	end if
	set contents of slider "quality" of mpegbox to (do shell script "/usr/bin/defaults read " & prefloc & " mpegquality")
end mpegeasyset

on flasheasyset(prefloc)
	set flashbox to tab view item "flashbox" of tab view "tabbox" of window "ReduxZero"
	if (do shell script "/usr/bin/defaults read " & prefloc & " flash320") is "true" then
		set content of button "320" of flashbox to true
	else
		set content of button "320" of flashbox to false
	end if
	if (do shell script "/usr/bin/defaults read " & prefloc & " flashrawflv") is "true" then
		set content of button "rawflv" of flashbox to true
	else
		set content of button "rawflv" of flashbox to false
	end if
	set contents of slider "quality" of flashbox to (do shell script "/usr/bin/defaults read " & prefloc & " flashquality")
end flasheasyset

(*
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
*)

on ipodeasysave(prefloc)
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim1 " & ((content of popup button "optim" of ipodbox is presetipod5g) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim3 " & ((content of popup button "optim" of ipodbox is presetappletv) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim4 " & ((content of popup button "optim" of ipodbox is presetiphone) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim5 " & ((content of popup button "optim" of ipodbox is presetipodnano) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim6 " & ((content of popup button "optim" of ipodbox is presetipodclassic) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim7 " & ((content of popup button "optim" of ipodbox is presetipodtouch) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim8 " & ((content of popup button "optim" of ipodbox is presetappletv51) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodoptim9 " & ((content of popup button "optim" of ipodbox is presetappletv5120) as string))
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodautoadd " & content of button "autoadd" of ipodbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodh264 " & content of button "h264" of ipodbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " ipodquality " & contents of slider "quality" of ipodbox)
end ipodeasysave

on pspeasysave(prefloc)
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " pspoptim1 " & content of cell "optim1" of matrix "optim" of pspbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " pspthumb " & content of button "thumb" of pspbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " psph264 " & content of button "h264" of pspbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " pspquality " & contents of slider "quality" of pspbox)
end pspeasysave

on dveasysave(prefloc)
	set dvbox to tab view item "dvbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " dvntsc " & content of cell "ntsc" of matrix "format" of dvbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " dvwidescreen " & content of button "widescreen" of dvbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " dvfcp " & content of button "fcp" of dvbox as string)
end dveasysave


on dvdeasysave(prefloc)
	set dvdbox to tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " dvdntsc " & content of cell "ntsc" of matrix "format" of dvdbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " dvdauthor " & content of button "author" of dvdbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " dvdquality " & contents of slider "quality" of dvdbox)
	(do shell script "/usr/bin/defaults write " & prefloc & " dvdburn " & content of button "burn" of dvdbox as string)
end dvdeasysave

on avieasysave(prefloc)
	set avibox to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " avi320 " & content of button "320" of avibox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " avidivxprofileonoff " & content of button "divxprofileonoff" of avibox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " aviquality " & contents of slider "quality" of avibox)
	(do shell script "/usr/bin/defaults write " & prefloc & " avidivxprofile " & contents of popup button "divxprofile" of avibox)
end avieasysave

on mp4easysave(prefloc)
	set mp4box to tab view item "mp4box" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " mp4320 " & content of button "320" of mp4box as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mp4hint " & content of button "hint" of mp4box as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mp4h264 " & content of button "h264" of mp4box as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mp4quality " & contents of slider "quality" of mp4box)
end mp4easysave

on wmveasysave(prefloc)
	set wmvbox to tab view item "wmvbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " wmv320 " & content of button "320" of wmvbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " wmvquality " & contents of slider "quality" of wmvbox)
end wmveasysave

on mpegeasysave(prefloc)
	set mpegbox to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " mpegntsc " & content of cell "ntsc" of matrix "format" of mpegbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mpegmpegprofileonoff " & content of button "mpegprofileonoff" of mpegbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mpegmpegprofile " & contents of popup button "mpegprofile" of mpegbox)
	(do shell script "/usr/bin/defaults write " & prefloc & " mpegmpeg2 " & content of button "mpeg2" of mpegbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " mpegquality " & contents of slider "quality" of mpegbox)
end mpegeasysave

on flasheasysave(prefloc)
	set flashbox to tab view item "flashbox" of tab view "tabbox" of window "ReduxZero"
	(do shell script "/usr/bin/defaults write " & prefloc & " flash320 " & content of button "320" of flashbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " flashrawflv " & content of button "rawflv" of flashbox as string)
	(do shell script "/usr/bin/defaults write " & prefloc & " flashquality " & contents of slider "quality" of flashbox)
end flasheasysave
