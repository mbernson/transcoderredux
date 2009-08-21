-- buttons.applescript
-- SongRedux
property fullpathcell : 1
property statustextcell : 2
property statusiconcell : 3
property shortnamecell : 4
property starttimecell : 5
property pidcell : 6
property exportfilecell : 7
property outputfilecell : 8
property durationnumcell : 9
property durationcell : 10

property ahver : 104
global thequotedapppath
global lossy
global aac
global mp3
global wma
global threeg
global ogg
global lossless
global aiff
global wav
global applelossless
global flac
global burn
global audiocd
global mp3cd
global ffmpeg
global tmpdir
global howmany
global ext
global fullstarttime
global toformat
global ffmpeg
global theinfo

global iscd
global cdtracknum
global stitch

global advvisible
--  Created by Tyler Loch on 5/27/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.

on launched theObject
	tell user defaults
		make new default entry at end of default entries with properties {name:"ffmpegloc", contents:""}
		make new default entry at end of default entries with properties {name:"qualitywide", contents:false}
		make new default entry at end of default entries with properties {name:"playsound", contents:true}
		make new default entry at end of default entries with properties {name:"batcherrorcancel", contents:true}
		make new default entry at end of default entries with properties {name:"saveloc", contents:""}
		make new default entry at end of default entries with properties {name:"nice", contents:false}
		make new default entry at end of default entries with properties {name:"moddate", contents:false}
		make new default entry at end of default entries with properties {name:"creationdate", contents:false}
		make new default entry at end of default entries with properties {name:"tmploc", contents:"/tmp/"}
		make new default entry at end of default entries with properties {name:"vlcloc", contents:""}
		make new default entry at end of default entries with properties {name:"timeremainingall", contents:true}
		make new default entry at end of default entries with properties {name:"keepcancel", contents:true}
		make new default entry at end of default entries with properties {name:"workflowopen", contents:false}
		make new default entry at end of default entries with properties {name:"lastformat", contents:2}
		make new default entry at end of default entries with properties {name:"madenewqueue", contents:false}
		make new default entry at end of default entries with properties {name:"ver", contents:95}
		make new default entry at end of default entries with properties {name:"maxcd", contents:4790}
		make new default entry at end of default entries with properties {name:"fulldur", contents:true}
		make new default entry at end of default entries with properties {name:"useburner", contents:0}
		make new default entry at end of default entries with properties {name:"burnspeed", contents:5}
		make new default entry at end of default entries with properties {name:"mb1", contents:0}
		make new default entry at end of default entries with properties {name:"mb2", contents:0}
		make new default entry at end of default entries with properties {name:"mb3", contents:0}
		make new default entry at end of default entries with properties {name:"mb4", contents:0}
		make new default entry at end of default entries with properties {name:"ab1", contents:0}
		make new default entry at end of default entries with properties {name:"ab2", contents:0}
		make new default entry at end of default entries with properties {name:"ab3", contents:0}
		make new default entry at end of default entries with properties {name:"ab4", contents:0}
		make new default entry at end of default entries with properties {name:"advvisible", contents:false}
		make new default entry at end of default entries with properties {name:"growl", contents:false}
		make new default entry at end of default entries with properties {name:"updatefrequency", contents:3}
		make new default entry at end of default entries with properties {name:"frombelpha1", contents:false}
		make new default entry at end of default entries with properties {name:"hidepanels", contents:true}
		make new default entry at end of default entries with properties {name:"itunesdelete", contents:false}
		make new default entry at end of default entries with properties {name:"initialsettings", contents:""}
		make new default entry at end of default entries with properties {name:"multiconv", contents:0}
		make new default entry at end of default entries with properties {name:"faac", contents:false}
		make new default entry at end of default entries with properties {name:"addunknowns", contents:true}
	end tell
	call method "synchronize" of object user defaults
	
	systemhealth()
	
	prefsload()
	
	--FIX OLDBAD FFMPEGLOC
	set contents of default entry "frombelpha1" of user defaults to false
	
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	
	-- LEOPARD OR TIGER? --
	set sysver to (do shell script "/usr/bin/uname -r | /usr/bin/cut -c 1")
	if sysver > 8 then
		call method "_setTexturedBackground:" of window "SongRedux" with parameter 1
		set visible of image view "burntbar" of window "SongRedux" to false
	else
		tell box "box" of window "SongRedux"
			set bezel style of popup button "formats" to rounded bezel
			set bezel style of button "advanced" to rounded bezel
			set {bux, buy} to size of button "advanced"
			set size of button "advanced" to {bux, 20}
		end tell
	end if
	
	-- FIGURE NUMBER OF CORES
	if contents of default entry "updatefrequency" of user defaults is 3 then
		set contents of default entry "updatefrequency" of user defaults to ((do shell script "/usr/sbin/sysctl -n hw.availcpu") as integer)
	end if
	
	-- DISABLE THE FORMAT MENU HEADERS --
	--formatinit()
	tell popup button "formats" of box "box" of window "SongRedux"
		set enabled of menu item 0 to false
		set enabled of menu item 8 to false
		set enabled of menu item 14 to false
	end tell
	
	-- RESET THE QUALITY SLIDER
	set {bx1, by1, bx2, by2} to bounds of box "qualitybox" of box "box" of window "SongRedux"
	set bounds of box "qualitybox" of box "box" of window "SongRedux" to {bx1 - 105, by1, bx2, by2}
	set contents of default entry "qualitywide" of user defaults to true
	
	--SIZE THE WINDOW
	tell user defaults
		set workflowopen to contents of default entry "workflowopen"
		set mainbounds to {contents of default entry "mb1", contents of default entry "mb2", contents of default entry "mb3", contents of default entry "mb4"}
		set advbounds to {contents of default entry "ab1", contents of default entry "ab2", contents of default entry "ab3", contents of default entry "ab4"}
		set advvisible to contents of default entry "advvisible"
	end tell
	if 0 is not in mainbounds then
		set bounds of window "SongRedux" to mainbounds
	end if
	if 0 is not in advbounds then
		set bounds of window "Advanced" to advbounds
	end if
	--open workflow?
	if workflowopen is true then
		set contents of button "workflowtoggle" of box "workflowbox" of box "box" of window "SongRedux" to true
		workflowtoggle(-50)
	end if
	
	set enabled of button "stitch" of box "workflowbox" of box "box" of window "SongRedux" to false
	
	try
		-- CREATE THE TOOLBARS --
		set documentToolbar to make new toolbar at end with properties {name:"document toolbar", identifier:"document toolbar identifier", allows customization:true, auto sizes cells:true, display mode:default display mode, size mode:default size mode}
		set allowed identifiers of documentToolbar to {"Add Item", "Remove Item", "Clear All", "Info", "Preview", "Preferences", "Advanced", "flexible space item identifer", "space item identifier", "separator item identifier"}
		set default identifiers of documentToolbar to {"Add Item", "Remove Item", "Clear All", "flexible space item identifer", "Info", "Preview"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Advanced", name:"Advanced", enabled:false, label:"Advanced", palette label:"Advanced", tool tip:"Advanced", image name:"advanced"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Preferences", name:"Preferences", enabled:false, label:"Preferences", palette label:"Preferences", tool tip:"Preferences", image name:"prefs"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Preview", name:"Preview", enabled:true, label:"Preview", palette label:"Preview", tool tip:"Preview", image name:"preview"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Info", name:"Info", enabled:true, label:"Info", palette label:"Info", tool tip:"File Info", image name:"info"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Add Item", name:"Add Item", enabled:true, label:"Add", palette label:"Add Item", tool tip:"Add Item...", image name:"add"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Remove Item", name:"Remove Item", enabled:true, label:"Remove", palette label:"Remove Item", tool tip:"Remove Item...", image name:"delete"}
		make new toolbar item at end of toolbar items of documentToolbar with properties {identifier:"Clear All", name:"Clear All", enabled:true, label:"Clear All", palette label:"Clear All", tool tip:"Clear All", image name:"clearall"}
		set toolbar of window "SongRedux" to documentToolbar
		
		-- Preferences Toolbar
		set preferencesToolbar to make new toolbar at end with properties {name:"preferences toolbar", identifier:"preferences toolbar identifier", allows customization:false, auto sizes cells:true, display mode:default display mode, size mode:default size mode}
		make new toolbar item at end of toolbar items of preferencesToolbar with properties {identifier:"General", name:"General", enabled:true, label:"General", palette label:"General", tool tip:"General", image name:"prefs"}
		make new toolbar item at end of toolbar items of preferencesToolbar with properties {identifier:"File Handling", name:"File Handling", enabled:true, label:"File Handling", palette label:"File Handling", tool tip:"File Handling", image name:"add"}
		make new toolbar item at end of toolbar items of preferencesToolbar with properties {identifier:"Burning", name:"Burning", enabled:true, label:"Burning", palette label:"Burning", tool tip:"Burning", image name:"burn"}
		make new toolbar item at end of toolbar items of preferencesToolbar with properties {identifier:"Notifications", name:"Notifications", enabled:true, label:"Notifications", palette label:"Notifications", tool tip:"Notifications", image name:"notifications"}
		set allowed identifiers of preferencesToolbar to {"General", "File Handling", "Burning", "Notifications"}
		set default identifiers of preferencesToolbar to {"General", "File Handling", "Burning", "Notifications"}
		set selectable identifiers of preferencesToolbar to {"General", "File Handling", "Burning", "Notifications"}
		set toolbar of window "Preferences" to preferencesToolbar
		set selected item identifier of preferencesToolbar to "General"
	end try
	
	-- PREP THE TABLE VIEW
	opener() of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
	
	-- MORE PRETTY
	set contents of text field "timeremaining" of window "SongRedux" to (localized string "addandclickstarttostart")
	
	-- SET MENU
	tell menu "conversionmenu" of main menu
		set enabled of menu item "conversionmenuresume" to false
		set enabled of menu item "conversionmenucancel" to false
		set enabled of menu item "conversionmenuassembly" to true
		set enabled of menu item "conversionmenustart" to true
	end tell
	
	--PREP ADVANCED PANEL
	resetstartend(false)
	set enabled of button "trimonoff" of tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced" to false
	
	--LOAD THE PREVIOUS SETTINGS
	set contents of popup button "formats" of box "box" of window "SongRedux" to contents of default entry "lastformat" of user defaults
	formatinit()
	set toformat to contents of default entry "lastformat" of user defaults
	set theplist to "~/Library/Preferences/com.techspansion.songredux"
	try
		if toformat is in {aac, mp3, wma, threeg, ogg} then
			lossiesload(theplist)
		end if
		if toformat is in {wav, aiff, flac, applelossless} then
			losslessload(theplist)
		end if
		if toformat is in {audiocd, mp3cd} then
			cdload(theplist)
		end if
	end try
	activate
	
	-- READY TO GO --
	show window "SongRedux"
	-- FIND FFMPEG
	set ffmpegloc to whereffmpeg(true) of (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
	
	set initialsettings to contents of default entry "initialsettings" of user defaults
	if initialsettings is not "" then
		try
			loadfiles({initialsettings as string})
		on error
			set initialsettings to ""
		end try
	end if
	if advvisible then
		show window "Advanced"
	end if
end launched


on clicked theObject
	set thename to name of theObject
	
	if thename is "advancedtabs" then
		set whichtab to content of theObject
		tell window "advanced"
			set enabled of button "settingssave" to true
			set enabled of button "settingsload" to true
			set enabled of button "settingsclearall" to true
			tell tab view "advancedbox"
				if whichtab is 0 then
					set current tab view item to tab view item "advancedaudiobox"
				end if
				if whichtab is 1 then
					set current tab view item to tab view item "advancedoneoffbox"
				end if
				if whichtab is 2 then
					set current tab view item to tab view item "advancedinfobox"
					tell window of theObject
						set enabled of button "settingssave" to false
						set enabled of button "settingsload" to false
						set enabled of button "settingsclearall" to false
					end tell
				end if
			end tell
		end tell
		if whichtab is 2 then
			try
				audinfo(null) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
			end try
		end if
	end if
	
	if thename is "fitonoff" then
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			if contents of button "fitonoff" is true then
				tell text field "audiobitrate"
					set enabled to false
					set contents to ""
				end tell
				set enabled of text field "fit" to true
			else
				tell text field "fit"
					set enabled to false
					set contents to ""
				end tell
				set enabled of text field "audiobitrate" to true
			end if
		end tell
		advchanges()
	end if
	
	if thename is "workflowtoggle" then
		if content of theObject is true then
			set sizechange to -50
		else
			set sizechange to 50
		end if
		workflowtoggle(sizechange)
	end if
	
	
	if thename is "viewtags" then
		try
			set snippets to (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
			set ffmpeg to whereffmpeg(false) of snippets
			set stitch to false
			tmpgetter(true) of snippets
			try
				set thisrow to contents of data cell fullpathcell of selected data row of table view "table" of scroll view "table" of window "SongRedux"
			on error
				set thisrow to contents of data cell fullpathcell of data row 1 of data source of table view "table" of scroll view "table" of window "SongRedux"
			end try
			pathings(thisrow) of snippets
			set {theformat, thedur, thesize, thecodec, thebitdepth, thehz, thechan, thebitrate, thetitle, theartist, thealbum, theyear, thecomment, thetrack, thegenre} to quickinfo(thisrow, fullstarttime, false) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
			tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
				set contents of text field "oneofftitle" to thetitle
				set contents of text field "oneoffartist" to theartist
				set contents of text field "oneoffalbum" to thealbum
				set contents of text field "oneofftrack" to thetrack
				if theyear is not "0" then set contents of text field "oneoffyear" to theyear
				set contents of text field "oneoffgenre" to thegenre
				set contents of text field "oneoffcomment" to thecomment
			end tell
		end try
	end if
	
	if thename is "advanced" then
		show window "advanced"
	end if
	
	if thename is "postactiononoff" then
		tell box "workflowbox" of box "box" of window "SongRedux"
			if contents of button "postactiononoff" is true then
				set enabled of popup button "postaction" to true
			else
				set enabled of popup button "postaction" to false
			end if
		end tell
	end if
	
	if thename is "pause" then
		pauser(title of theObject)
	end if
	
	if thename is "cancel" then
		canceller()
	end if
	
	if thename is "prefssave" then
		set fileprefs to tab view item "prefsfile" of tab view "prefstabs" of window "preferences"
		set generalprefs to tab view item "prefsgeneral" of tab view "prefstabs" of window "preferences"
		set notificationprefs to tab view item "prefsnotification" of tab view "prefstabs" of window "preferences"
		set burnprefs to tab view item "prefsburn" of tab view "prefstabs" of window "preferences"
		set content of default entry "playsound" of user defaults to (contents of button "playsound" of notificationprefs)
		set content of default entry "growl" of user defaults to (contents of button "growl" of notificationprefs)
		set content of default entry "saveloc" of user defaults to (contents of text field "saveto" of fileprefs) as string
		set contents of text field "saveto" of box "workflowbox" of box "box" of window "SongRedux" to (contents of text field "saveto" of fileprefs)
		set content of default entry "initialsettings" of user defaults to (contents of text field "initialsettings" of generalprefs) as string
		set content of default entry "batcherrorcancel" of user defaults to (contents of cell 1 of matrix "batcherror" of generalprefs)
		set content of default entry "multiconv" of user defaults to (contents of popup button "multiconv" of generalprefs)
		set content of default entry "hidepanels" of user defaults to (contents of cell 1 of matrix "hidepanels" of generalprefs)
		set content of default entry "keepcancel" of user defaults to (contents of cell 1 of matrix "keepcancel" of fileprefs)
		set content of default entry "itunesdelete" of user defaults to (contents of cell 2 of matrix "itunesdelete" of fileprefs)
		set content of default entry "nice" of user defaults to (contents of button "nice" of generalprefs)
		set content of default entry "creationdate" of user defaults to (contents of button "creationdate" of fileprefs)
		set content of default entry "addunknowns" of user defaults to (contents of button "addunknowns" of fileprefs)
		set content of default entry "moddate" of user defaults to (contents of button "moddate" of fileprefs)
		set content of default entry "tmploc" of user defaults to (contents of text field "tmplocpref" of fileprefs) as string
		set content of default entry "useburner" of user defaults to (contents of popup button "burners" of burnprefs)
		set content of default entry "burnspeed" of user defaults to (contents of popup button "burnspeed" of burnprefs)
		call method "synchronize" of object user defaults
		close panel window "preferences"
	end if
	
	if thename is "prefscancel" then
		prefsload()
		close panel window "preferences"
	end if
	
	if thename is "savetoprefedit" or thename is "savetoedit" then
		set saveas to choose folder with prompt (localized string "saveloc") as string
		set saveasposix to POSIX path of saveas
		if thename is "savetoedit" then
			set wherebutton to box "workflowbox" of box "box" of window "SongRedux"
		else
			set wherebutton to tab view item "prefsfile" of tab view "prefstabs" of window "preferences"
		end if
		set content of text field "saveto" of wherebutton to saveasposix as string
	end if
	
	if thename is "savetoprefclear" then
		set content of text field "saveto" of tab view item "prefsfile" of tab view "prefstabs" of window "preferences" to ""
	end if
	
	if thename is "initialsettingsprefedit" or thename is "initialsettingsedit" then
		set whichsrdx to (choose file of type "com.techspansion.songredux.srdx" without invisibles) --POSIX path of
		set whichsrdxposix to POSIX path of whichsrdx
		set content of text field "initialsettings" of tab view item "prefsgeneral" of tab view "prefstabs" of window "preferences" to whichsrdxposix as string
	end if
	
	if thename is "initialsettingsprefclear" then
		set content of text field "initialsettings" of tab view item "prefsgeneral" of tab view "prefstabs" of window "preferences" to ""
	end if
	
	if thename is "downloadgrowl" then
		do shell script "/usr/bin/open http://growl.info"
	end if
	
	if thename is "tmplocprefedit" then
		set saveas to (choose folder with prompt (localized string "tmploc") with invisibles) as string
		set saveasposix to POSIX path of saveas
		set content of text field "tmplocpref" of tab view item "prefsfile" of tab view "prefstabs" of window "preferences" to saveasposix as string
	end if
	
	if thename is "tmplocprefreset" then
		set content of text field "tmplocpref" of tab view item "prefsfile" of tab view "prefstabs" of window "preferences" to "/tmp/"
	end if
	
	if thename is "detectburners" then
		burnerpicker()
	end if
	
	if thename is "codectype" then
		formatchecks()
	end if
	
	if thename is "wannayes" then
		if contents of text field "wannawhat" of window "wannabox" is "cancel" then
			tell window "SongRedux"
				update
				set contents of text field "wanter" to "cancel"
				set contents of text field "timeremaining" to (localized string "cancelling")
			end tell
			close panel window "wannabox"
			delay 4
			if contents of text field "timeremaining" of window "SongRedux" is not in {(localized string "addandclickstarttostart"), (localized string "clickstarttostart"), ""} then
				stoprun() of (load script (scripts path of main bundle & "/main.scpt" as POSIX file))
			end if
		end if
		--		if contents of text field "wannawhat" of window "wannabox" is "quit" then
		--			display dialog "wannaquit"
		--			close panel window "wannabox"
		--		end if
		if contents of text field "wannawhat" of window "wannabox" is "done" then
			set contents of text field "wannawhat" of window "wannabox" to "ok"
			close panel window "wannabox"
		end if
	end if
	
	if thename is "wannano" then
		if contents of text field "wannawhat" of window "wannabox" is "done" then
			set contents of text field "wannawhat" of window "wannabox" to "log"
		end if
		close panel window "wannabox"
	end if
	
	if thename is "trimonoff" then
		if contents of button "trimonoff" of tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced" is true then
			resetstartend(true)
		else
			resetstartend(false)
		end if
	end if
	
	if thename is "settingsclearall" then
		settingsclearall()
	end if
	
	if thename is "settingssave" then
		settingssave()
	end if
	
	if thename is "settingsload" then
		set savefilebefore to (choose file of type "com.techspansion.songredux.srdx" without invisibles) --POSIX path of
		set savefile to quoted form of (POSIX path of savefilebefore)
		settingsload(savefile)
	end if
end clicked

on update toolbar item theObject
	try
		return true
	end try
end update toolbar item

on should quit theObject
	shouldquit()
end should quit

on shouldquit()
	set whatstatus to contents of text field "timeremaining" of window "SongRedux"
	if whatstatus is not in {(localized string "addandclickstarttostart"), (localized string "clickstarttostart"), ""} then
		display alert (localized string "sureyouwannaquit") message (localized string "quittext") as warning default button (localized string "quit") alternate button (localized string "continue")
		if button returned of the result is (localized string "quit") then
			try
				do shell script "/bin/kill " & contents of text field "pid" of window "SongRedux"
			end try
			return true
		else
			return false
		end if
	else
		return true
	end if
end shouldquit

on will quit
	-- IMPORTANT PREFS
	set advvisible to visible of window "Advanced"
	set visible of window "SongRedux" to false
	set visible of window "Advanced" to false
	
	savewindowsandformats()
	
	-- Last one left turn out the light
	tell application "System Events" to set howmanyhubs to count of (every process whose name contains "SongRedux")
	if howmanyhubs is 1 then
		try
			do shell script "/bin/rm -rf /tmp/ahtemp"
		end try
	end if
end will quit

on savewindowsandformats()
	set {mb1, mb2, mb3, mb4} to bounds of window "SongRedux"
	set {ab1, ab2, ab3, ab4} to bounds of window "Advanced"
	set workflowopen to contents of button "workflowtoggle" of box "workflowbox" of box "box" of window "SongRedux"
	if workflowopen is true then
		set workflowopensize to 50
	else
		set workflowopensize to 0
	end if
	set toformat to contents of popup button "formats" of box "box" of window "SongRedux"
	formatinit()
	tell user defaults
		set contents of default entry "workflowopen" to workflowopen
		set contents of default entry "advvisible" to advvisible
		set contents of default entry "mb1" to mb1
		set contents of default entry "mb2" to (mb2 + workflowopensize + 55) --wrong for some reason
		set contents of default entry "mb3" to mb3
		set contents of default entry "mb4" to mb4
		set contents of default entry "ab1" to ab1
		set contents of default entry "ab2" to ab2
		set contents of default entry "ab3" to ab3
		set contents of default entry "ab4" to ab4
		set contents of default entry "lastformat" to toformat
	end tell
	call method "synchronize" of object user defaults
	set theplist to "~/Library/Preferences/com.techspansion.songredux"
	try
		if toformat is in {aac, mp3, wma, threeg, ogg} then
			lossiesset(theplist)
		end if
		if toformat is in {wav, aiff, flac, applelossless} then
			losslessset(theplist)
		end if
		if toformat is in {audiocd, mp3cd} then
			cdset(theplist)
		end if
	end try
end savewindowsandformats

on choose menu item theObject
	set thename to name of theObject
	
	if thename is "formats" then
		formatchecks()
	end if
	
	if thename is "add" then
		additem()
	end if
	
	if thename is "pregap" then
		gethowmany()
	end if
	
	if thename is "newqueue" then
		if contents of default entry "madenewqueue" of user defaults is false then
			display alert (localized string "newqueue") message (localized string "newqueuetext") as informational default button "OK" --attached to window "SongRedux"
			set contents of default entry "madenewqueue" of user defaults to true
		end if
		set advvisible to visible of window "Advanced"
		savewindowsandformats()
		tell application "SystemUIServer" to activate
		call method "synchronize" of object user defaults
		set thePath to path of the main bundle as string
		set thequotedapppath to quoted form of thePath
		do shell script thequotedapppath & "/Contents/MacOS/SongRedux &> /dev/null &"
		set {qx, qy} to position of window "SongRedux"
		repeat 10 times
			set qx to (qx + 2)
			set qy to (qy - 2)
			set position of window "SongRedux" to {qx, qy}
		end repeat
		return true
	end if
	
	if thename is "clearall" then
		clearall()
	end if
	
	if thename is "save" then
		settingssave()
	end if
	
	if thename is "load" then
		set savefilebefore to (choose file of type "com.techspansion.songredux.srdx" without invisibles) --POSIX path of
		set savefile to quoted form of (POSIX path of savefilebefore)
		settingsload(savefile)
	end if
	
	if thename is "resetsongredux" then
		display alert (localized string "resettitle") message (localized string "resettext") as warning default button (localized string "ok") alternate button (localized string "cancel")
		if button returned of the result is (localized string "ok") then
			set quotedapppath to quoted form of (path of main bundle as string)
			do shell script "/bin/sh -c '/bin/rm ~/Library/Preferences/com.techspansion.songredux.plist ; /bin/rm /Library/Preferences/com.techspansion.songredux.plist ; /bin/rm -r /tmp/ahtemp ; /usr/bin/killall SongRedux ; /bin/sleep 1 ; /usr/bin/open '" & quotedapppath & "' ; exit 0' &> /dev/null &"
		end if
	end if
	
	if thename is "conversionmenustart" then
		readygo() of (load script (scripts path of main bundle & "/SongRedux.scpt" as POSIX file))
	end if
	
	if thename is "conversionmenupause" or thename is "conversionmenuresume" then
		pauser(title of button "pause" of window "SongRedux")
	end if
	
	if thename is "conversionmenucancel" then
		canceller()
	end if
	
	if thename is "conversionmenulog" then
		if state of theObject as boolean is true then
			set state of theObject to false
		else
			set state of theObject to true
		end if
	end if
	
	if thename is "preferences" then
		prefsopen()
	end if
	
	if thename is "infopanel" then
		openinfo()
	end if
	
	if thename is "advancedpanel" then
		show window "advanced"
	end if
	
	if thename is "previewpanel" then
		dopreview() of (load script (scripts path of main bundle & "/preview.scpt" as POSIX file))
	end if
	
	if thename is "postaction" then
		if contents of popup button "postaction" of box "workflowbox" of box "box" of window "SongRedux" is 8 then
			try
				set whichscript to choose file of type "osas" with prompt (localized string "scriptloc") without invisibles
				set contents of text field "runscript" of window "SongRedux" to POSIX path of whichscript
			on error
				set contents of popup button "postaction" of box "workflowbox" of box "box" of window "SongRedux" to 3
			end try
		end if
		return true
	end if
	
	if thename is "clearlogarchive" then
		display alert (localized string "sureyouwannaclearlog") message (localized string "clearlogtext") as warning default button (localized string "delete") alternate button (localized string "cancel")
		if button returned of the result is (localized string "delete") then
			do shell script "/bin/rm -f ~/Library/Logs/Techspansion/ah*"
		end if
	end if
	
	if thename is "logarchive" then
		do shell script "/usr/bin/open ~/Library/Logs/Techspansion"
	end if
	
end choose menu item

on settingsclearall()
	tell window "advanced"
		tell tab view item "advancedaudiobox" of tab view "advancedbox"
			set contents of combo box "audiohz" to "Auto"
			set contents of popup button "audiochannels" to 0
			set contents of button "fitonoff" to false
			tell text field "fit"
				set enabled to false
				set contents to ""
			end tell
			tell text field "audiobitrate"
				set enabled to true
				set contents to ""
			end tell
			set contents of popup button "decoder" to 0
			set contents of popup button "audiotrack" to 0
			set contents of slider "vol" to 256
			set contents of button "normalize" to false
			set contents of text field "ffaudio" to ""
			set contents of text field "xxaudio" to ""
		end tell
		tell tab view item "advancedoneoffbox" of tab view "advancedbox"
			my resetstartend(false)
			set contents of text field "oneofftitle" to ""
			set contents of text field "oneoffartist" to ""
			set contents of text field "oneoffalbum" to ""
			set contents of text field "oneofftrack" to ""
			set contents of text field "oneoffyear" to ""
			set contents of text field "oneoffgenre" to ""
			set contents of text field "oneoffcomment" to ""
		end tell
	end tell
end settingsclearall

on settingssave()
	set toformat to contents of popup button "formats" of box "box" of window "SongRedux"
	tell window "advanced"
		tell tab view item "advancedaudiobox" of tab view "advancedbox"
			set audiohz to contents of combo box "audiohz"
			set audiochannels to contents of popup button "audiochannels"
			set fitonoff to contents of button "fitonoff"
			set fitcontents to contents of text field "fit"
			set audiobitrate to contents of text field "audiobitrate"
			set decoder to contents of popup button "decoder"
			set audiotrack to contents of popup button "audiotrack"
			set vol to contents of slider "vol"
			set normalize to contents of button "normalize"
			set ffaudio to contents of text field "ffaudio"
			set xxaudio to contents of text field "xxaudio"
		end tell
		tell tab view item "advancedoneoffbox" of tab view "advancedbox"
			set oneofftitle to contents of text field "oneofftitle"
			set oneoffartist to contents of text field "oneoffartist"
			set oneoffalbum to contents of text field "oneoffalbum"
			set oneofftrack to contents of text field "oneofftrack"
			set oneoffyear to contents of text field "oneoffyear"
			set oneoffgenre to contents of text field "oneoffgenre"
			set oneoffcomment to contents of text field "oneoffcomment"
		end tell
	end tell
	set fullstarttime to do shell script "/bin/date +%s"
	set theplist to "/tmp/ah_savefile" & fullstarttime
	do shell script "/usr/bin/defaults write  " & theplist & " lastformat -int " & toformat & " ;
/usr/bin/defaults write  " & theplist & "  audiohz " & quoted form of audiohz & " ;
/usr/bin/defaults write  " & theplist & "  audiochannels -int " & audiochannels & " ;
/usr/bin/defaults write  " & theplist & "  fitonoff -bool " & fitonoff & " ;
/usr/bin/defaults write  " & theplist & "  fitcontents " & quoted form of fitcontents & " ;
/usr/bin/defaults write  " & theplist & "  audiochannels -int " & audiochannels & " ;
/usr/bin/defaults write  " & theplist & "  audiobitrate " & quoted form of audiobitrate & " ;
/usr/bin/defaults write  " & theplist & "  decoder -int " & decoder & " ;
/usr/bin/defaults write  " & theplist & "  audiotrack -int " & audiotrack & " ;
/usr/bin/defaults write  " & theplist & "  vol -int " & vol & " ;
/usr/bin/defaults write  " & theplist & "  normalize -bool " & normalize & " ;
/usr/bin/defaults write  " & theplist & "  ffaudio " & quoted form of ffaudio & " ;
/usr/bin/defaults write  " & theplist & "  xxaudio " & quoted form of xxaudio & " ;
/usr/bin/defaults write  " & theplist & "  oneofftitle " & quoted form of oneofftitle & " ;
/usr/bin/defaults write  " & theplist & "  oneoffartist " & quoted form of oneoffartist & " ;
/usr/bin/defaults write  " & theplist & "  oneoffalbum " & quoted form of oneoffalbum & " ;
/usr/bin/defaults write  " & theplist & "  oneofftrack " & quoted form of oneofftrack & " ;
/usr/bin/defaults write  " & theplist & "  oneoffyear " & quoted form of oneoffyear & " ;
/usr/bin/defaults write  " & theplist & "  oneoffgenre " & quoted form of oneoffgenre & " ;
/usr/bin/defaults write  " & theplist & "  oneoffcomment " & quoted form of oneoffcomment & " ;
/usr/bin/defaults write  " & theplist & "  ver " & ahver & " ; exit 0"
	
	try
		if toformat is in {aac, mp3, wma, threeg, ogg} then
			lossiesset(theplist)
		end if
		if toformat is in {wav, aiff, flac, applelossless} then
			losslessset(theplist)
		end if
		if toformat is in {audiocd, mp3cd} then
			cdset(theplist)
		end if
	end try
	
	set savefilebefore to (choose file name with prompt (localized string "settingssave") default name "settings.srdx") --POSIX path of
	set savefile to quoted form of (POSIX path of savefilebefore)
	do shell script "/bin/mv " & theplist & ".plist " & savefile
	
end settingssave

on settingsload(savefile)
	
	set fullstarttime to do shell script "/bin/date +%s"
	set theplist to "/tmp/ah_savefile" & fullstarttime
	do shell script "/bin/cp " & savefile & " " & theplist & ".plist"
	
	set toformat to (do shell script "/usr/bin/defaults read " & theplist & " lastformat") as number
	set audiohz to do shell script "/usr/bin/defaults read " & theplist & " audiohz"
	set audiochannels to (do shell script "/usr/bin/defaults read " & theplist & " audiochannels") as number
	set fitonoff to (do shell script "/usr/bin/defaults read " & theplist & " audiohz") as boolean
	set fitcontents to do shell script "/usr/bin/defaults read " & theplist & " fitcontents"
	set audiochannels to (do shell script "/usr/bin/defaults read " & theplist & " audiochannels") as number
	set audiobitrate to do shell script "/usr/bin/defaults read " & theplist & " audiobitrate"
	set decoder to (do shell script "/usr/bin/defaults read " & theplist & " decoder") as number
	set audiotrack to (do shell script "/usr/bin/defaults read " & theplist & " audiotrack") as number
	set vol to (do shell script "/usr/bin/defaults read " & theplist & " vol") as number
	set normalize to (do shell script "/usr/bin/defaults read " & theplist & " normalize") as boolean
	set ffaudio to do shell script "/usr/bin/defaults read " & theplist & " ffaudio"
	set xxaudio to do shell script "/usr/bin/defaults read " & theplist & " xxaudio"
	set oneofftitle to do shell script "/usr/bin/defaults read " & theplist & " oneofftitle"
	set oneoffartist to do shell script "/usr/bin/defaults read " & theplist & " oneoffartist"
	set oneoffalbum to do shell script "/usr/bin/defaults read " & theplist & " oneoffalbum"
	set oneofftrack to do shell script "/usr/bin/defaults read " & theplist & " oneofftrack"
	set oneoffyear to do shell script "/usr/bin/defaults read " & theplist & " oneoffyear"
	set oneoffgenre to do shell script "/usr/bin/defaults read " & theplist & " oneoffgenre"
	set oneoffcomment to do shell script "/usr/bin/defaults read " & theplist & " oneoffcomment"
	
	set contents of popup button "formats" of box "box" of window "SongRedux" to toformat
	formatinit()
	
	try
		if toformat is in {aac, mp3, wma, threeg, ogg} then
			lossiesload(theplist)
		end if
		if toformat is in {wav, aiff, flac, applelossless} then
			losslessload(theplist)
		end if
		if toformat is in {audiocd, mp3cd} then
			cdload(theplist)
		end if
	end try
	
	tell window "advanced"
		tell tab view item "advancedaudiobox" of tab view "advancedbox"
			set contents of combo box "audiohz" to audiohz
			set contents of popup button "audiochannels" to audiochannels
			set contents of button "fitonoff" to fitonoff
			tell text field "fit"
				if fitonoff is true then
					set enabled to false
				else
					set enabled to false
				end if
			end tell
			tell text field "audiobitrate"
				if fitonoff is true then
					set enabled to false
				else
					set contents to audiobitrate
					set enabled to true
				end if
			end tell
			set contents of popup button "decoder" to decoder
			set contents of popup button "audiotrack" to audiotrack
			set contents of slider "vol" to vol
			set contents of button "normalize" to normalize
			set contents of text field "ffaudio" to ffaudio
			set contents of text field "xxaudio" to xxaudio
		end tell
		tell tab view item "advancedoneoffbox" of tab view "advancedbox"
			my resetstartend(false)
			set contents of text field "oneofftitle" to oneofftitle
			set contents of text field "oneoffartist" to oneoffartist
			set contents of text field "oneoffalbum" to oneoffalbum
			set contents of text field "oneofftrack" to oneofftrack
			set contents of text field "oneoffyear" to oneoffyear
			set contents of text field "oneoffgenre" to oneoffgenre
			set contents of text field "oneoffcomment" to oneoffcomment
		end tell
	end tell
	
	do shell script "/bin/rm " & theplist & ".plist"
	
end settingsload

on clicked toolbar item theObject
	try
		set toolname to identifier of theObject
		set heightneeded to 0
		if toolname is "Add Item" then
			additem()
		end if
		if toolname is "Remove Item" then
			removeitem()
		end if
		if toolname is "Clear All" then
			clearall()
		end if
		if toolname is "Info" then
			openinfo()
		end if
		if toolname is "Preview" then
			dopreview() of (load script (scripts path of main bundle & "/preview.scpt" as POSIX file))
		end if
		if toolname is "Advanced" then
			show window "advanced"
		end if
		if toolname is "Preferences" then
			prefsopen()
		end if
		--******ALL THIS SIZING CODE IS FINE NOW
		set prefstab to tab view "prefstabs" of window "preferences"
		if toolname is "General" then
			set heightneeded to 590
			set current tab view item of prefstab to tab view item "prefsgeneral" of prefstab
		end if
		if toolname is "File Handling" then
			set heightneeded to 595
			set current tab view item of prefstab to tab view item "prefsfile" of prefstab
		end if
		if toolname is "Burning" then
			set heightneeded to 273
			set current tab view item of prefstab to tab view item "prefsburn" of prefstab
		end if
		if toolname is "Notifications" then
			set heightneeded to 235
			set current tab view item of prefstab to tab view item "prefsnotification" of prefstab
		end if
		if heightneeded > 0 then
			set {ox1, oy1, ox2, oy2} to bounds of window "preferences"
			-- HOT HOT RESIZING
			set midoy to (oy1 - (oy2 - heightneeded))
			set midoys to (midoy * 0.2)
			set oysizer to 0
			set visible of prefstab to false
			repeat 6 times
				set bounds of window "preferences" to {ox1, (oy1 + oysizer), ox2, oy2}
				set oysizer to (oysizer - midoys)
			end repeat
			set visible of prefstab to true
			--		set bounds of window "preferences" to {ox1, (oy2 - heightneeded), ox2, oy2}
			update window "Preferences"
		end if
	end try
end clicked toolbar item

on open theObject
	loadfiles(theObject)
end open

on selection changed theObject
	advchanges()
end selection changed

on changed theObject
	advchanges()
end changed

on selection changing theObject
	advchanges()
end selection changing

on action theObject
	startend()
end action

on should close theObject
	shouldquit()
	if the result is true then
		quit saving no
		return true
	else
		return false
	end if
end should close

on startend()
	tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
		set fulldur to maximum value of slider "ss"
		set totalleft to ((fulldur - (contents of slider "ss")) - (fulldur - (contents of slider "t"))) as integer
		set contents of text field "startat" to ((localized string "startatcolonspace") & my timeswap(contents of slider "ss" as integer))
		set contents of text field "endat" to ((localized string "endatcolonspace") & my timeswap(contents of slider "t" as integer))
		if totalleft < 0 then
			set text color of text field "total" to {65535, 0, 0}
			set contents of text field "total" to (localized string "error")
		else
			set text color of text field "total" to {0, 0, 0}
			set contents of text field "total" to ((localized string "totalcolonspace") & my timeswap(totalleft))
		end if
	end tell
	return true
end startend

on resetstartend(isrow)
	try
		if isrow is true then
			set filedurcolon to (contents of data cell durationcell of selected data row of table view "table" of scroll view "table" of window "SongRedux" as Unicode text)
			set filedur to timeswap(filedurcolon)
			tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
				set enabled of slider "ss" to true
				set enabled of slider "t" to true
				set enabled of text field "startat" to true
				set enabled of text field "endat" to true
			end tell
		else
			error
		end if
	on error
		tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
			set contents of button "trimonoff" to false
			set enabled of slider "ss" to false
			set enabled of slider "ss" to false
			set enabled of slider "t" to false
			set enabled of text field "startat" to false
			set contents of text field "startat" to (localized string "startatcolonspace")
			set contents of text field "endat" to (localized string "endatcolonspace")
			set enabled of text field "endat" to false
			set contents of text field "total" to ""
			set filedur to 999999
		end tell
	end try
	setstartend(filedur)
	if contents of button "trimonoff" of tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced" is true then
		startend()
	end if
	update window "advanced"
	return true
end resetstartend

on setstartend(filedur)
	tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
		tell slider "ss"
			set maximum value to filedur
			set minimum value to 0
			set contents to 0
		end tell
		tell slider "t"
			set maximum value to filedur
			set minimum value to 0
			set contents to filedur
		end tell
	end tell
	return true
end setstartend

on loadfiles(theObject)
	set AppleScript's text item delimiters to "."
	set ext to last text item of (theObject as string)
	if (count of items of theObject) is 1 and ext is "srdx" then
		settingsload(quoted form of POSIX path of theObject)
	else
		set snippets to load script (scripts path of main bundle & "/snippets.scpt" as POSIX file)
		tmpgetter(true) of snippets
		set ffmpeg to whereffmpeg(false) of snippets
		do shell script "/bin/mkdir -p /tmp/ahtemp/" & fullstarttime
		set contents of text field "dragfiles" of window "SongRedux" to (localized string "checkingfiles")
		repeat with theItem in theObject
			--	if (do shell script "/usr/bin/file -b " & quoted form of POSIX path of theItem & " ; exit 0") is "directory" then
			set theinsidefiles to (do shell script "/usr/bin/find " & quoted form of POSIX path of theItem & " -type f '!' -name '.*' '!' -path '.*' ; exit 0")
			set AppleScript's text item delimiters to return
			set theinsidefileslist to (text items of theinsidefiles)
			repeat with theinsideitem in theinsidefileslist
				tableadder(theinsideitem, fullstarttime) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
			end repeat
			--else
			--	tableadder((POSIX path of theItem), fullstarttime) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
			--end if
		end repeat
		gethowmany()
		tmpcleaner(false) of snippets
	end if
end loadfiles

on additem()
	set theItems to choose file with multiple selections allowed without invisibles
	set snippets to load script (scripts path of main bundle & "/snippets.scpt" as POSIX file)
	set ffmpeg to whereffmpeg(false) of snippets
	set AppleScript's text item delimiters to "/"
	tmpgetter(true) of snippets
	do shell script "/bin/mkdir -p /tmp/ahtemp/" & fullstarttime
	repeat with theItem in theItems
		tableadder((POSIX path of theItem), fullstarttime) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
		gethowmany()
	end repeat
	tmpcleaner(false) of snippets
end additem

on removeitem()
	set thetableview to table view "table" of scroll view "table" of window "SongRedux"
	if enabled of thetableview is true then
		set deleteds to (selected data rows of thetableview)
		if (count of deleteds) > 0 then
			repeat with deleteeach in every item of deleteds
				delete (deleteeach)
			end repeat
		end if
		gethowmany()
	else
		display alert (localized string "disabledtable") attached to window "SongRedux"
		error number -128
	end if
end removeitem

on clearall()
	set thetableview to table view "table" of scroll view "table" of window "SongRedux"
	if enabled of thetableview is true then
		tell window "SongRedux"
			delete every data row of data source of table view "table" of scroll view "table"
		end tell
		gethowmany()
	else
		display alert (localized string "disabledtable") attached to window "SongRedux"
		error number -128
	end if
end clearall

on pauser(thestatus)
	tell window "SongRedux"
		if thestatus is (localized string "pause") then
			set title of button "pause" to (localized string "resume")
			set contents of text field "timeremaining" to (localized string "paused")
			try
				do shell script "/bin/kill -SIGSTOP " & contents of text field "pid"
			end try
		else
			try
				do shell script "/bin/kill -SIGCONT " & contents of text field "pid"
			end try
			set title of button "pause" to (localized string "pause")
			set contents of text field "timeremaining" to (localized string "resuming")
			delay 2
		end if
	end tell
end pauser

on burnerpicker()
	set burners to (do shell script "/usr/bin/drutil list | /usr/bin/grep -v SupportLevel ; echo test ; exit 0")
	set AppleScript's text item delimiters to return
	
	delete every menu item of menu of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences"
	make new menu item at end of menu items of menu of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" with properties {title:"Auto"}
	repeat with thisburner in (every text item of burners)
		if "R" is in thisburner then
			make new menu item at end of menu items of menu of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" with properties {title:thisburner}
		end if
	end repeat
	set enabled of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" to true
end burnerpicker

on canceller()
	tell window "wannabox"
		set title of button "wannayes" to (localized string "yes")
		set title of button "wannano" to (localized string "continue")
		set contents of text field "wannadotext" to ""
		set contents of text field "wannado" to (localized string "sureyouwannacancel")
		set contents of text field "wannawhat" to "cancel"
	end tell
	display window "wannabox" attached to window "SongRedux"
	(*	set arecancelling to button returned of (display alert (localized string "sureyouwannacancel") default button (localized string "yes") alternate button (localized string "continue"))
	if arecancelling is (localized string "yes") then
		tell window "SongRedux"
			update
			set contents of text field "wanter" to "cancel"
			set contents of text field "timeremaining" to (localized string "cancelling")
		end tell
	end if *)
	return true
end canceller

on prefsopen()
	display window "preferences" attached to window "SongRedux"
	update window "preferences"
end prefsopen

on prefsload()
	set fileprefs to tab view item "prefsfile" of tab view "prefstabs" of window "preferences"
	set generalprefs to tab view item "prefsgeneral" of tab view "prefstabs" of window "preferences"
	set notificationprefs to tab view item "prefsnotification" of tab view "prefstabs" of window "preferences"
	set contents of button "playsound" of notificationprefs to content of default entry "playsound" of user defaults
	set contents of button "growl" of notificationprefs to content of default entry "growl" of user defaults
	tell application "System Events" to set hasgrowl to ((count of (every process whose name is "GrowlHelperApp")) > 0)
	set enabled of button "growl" of notificationprefs to hasgrowl
	update window "preferences"
	set saveloc to content of default entry "saveloc" of user defaults
	set contents of cell 1 of matrix "batcherror" of generalprefs to content of default entry "batcherrorcancel" of user defaults
	if (content of default entry "batcherrorcancel" of user defaults) is false then
		set contents of cell 2 of matrix "batcherror" of generalprefs to true
	end if
	set hidepanels to content of default entry "hidepanels" of user defaults
	if hidepanels is true then
		set contents of cell 1 of matrix "hidepanels" of generalprefs to true
		set contents of cell 2 of matrix "hidepanels" of generalprefs to false
		set hides when deactivated of window "Advanced" to true
		set hides when deactivated of window "preview" to true
	else
		set contents of cell 2 of matrix "hidepanels" of generalprefs to true
		set contents of cell 1 of matrix "hidepanels" of generalprefs to false
		set hides when deactivated of window "Advanced" to false
		set hides when deactivated of window "preview" to false
		set floating of window "Advanced" to false
		--	set floating of window "preview" to false
	end if
	set contents of text field "initialsettings" of generalprefs to content of default entry "initialsettings" of user defaults
	set contents of popup button "multiconv" of generalprefs to content of default entry "multiconv" of user defaults
	set contents of button "nice" of generalprefs to content of default entry "nice" of user defaults
	--FILE PREFS
	set contents of text field "saveto" of fileprefs to saveloc
	set contents of text field "saveto" of box "workflowbox" of box "box" of window "SongRedux" to saveloc
	set contents of cell 1 of matrix "keepcancel" of fileprefs to content of default entry "keepcancel" of user defaults
	if (content of default entry "keepcancel" of user defaults) is false then
		set contents of cell 2 of matrix "keepcancel" of fileprefs to true
	end if
	set contents of cell 2 of matrix "itunesdelete" of fileprefs to content of default entry "itunesdelete" of user defaults
	if (content of default entry "itunesdelete" of user defaults) is true then
		set contents of cell 1 of matrix "itunesdelete" of fileprefs to false
	end if
	set contents of button "moddate" of fileprefs to content of default entry "moddate" of user defaults
	set contents of button "creationdate" of fileprefs to content of default entry "creationdate" of user defaults
	set contents of button "addunknowns" of fileprefs to content of default entry "addunknowns" of user defaults
	set contents of text field "tmplocpref" of fileprefs to content of default entry "tmploc" of user defaults
	
	--BURNER
	--burner thing doesn't like being variabled...
	delete every menu item of menu of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences"
	make new menu item at end of menu items of menu of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" with properties {title:(localized string "auto")}
	if content of default entry "useburner" of user defaults is 0 then
		set enabled of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" to false
	else
		burnerpicker()
		try
			set contents of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" to (content of default entry "useburner" of user defaults)
		end try
		if contents of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" < 1 then
			set contents of popup button "burners" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" to 0
		end if
	end if
	set contents of popup button "burnspeed" of tab view item "prefsburn" of tab view "prefstabs" of window "preferences" to (content of default entry "burnspeed" of user defaults)
	
end prefsload

on gethowmany()
	tell window "SongRedux"
		set therows to count of data rows of data source of table view "table" of scroll view "table"
		if therows > 1 then
			set contents of text field "dragfiles" to ((therows as string) & (localized string "...files") as Unicode text)
			set visible of text field "barruntime" to true
			set enabled of button "stitch" of box "workflowbox" of box "box" to true
		end if
		if therows is 1 then
			set contents of text field "dragfiles" to ((therows as string) & (localized string "file") as Unicode text)
			set visible of text field "barruntime" to true
			set enabled of button "stitch" of box "workflowbox" of box "box" to false
		end if
		if therows is 0 then
			set contents of text field "dragfiles" to (localized string "dragfiles" as Unicode text)
			set visible of text field "barruntime" to false
			set enabled of button "stitch" of box "workflowbox" of box "box" to false
		end if
		tell text field "timeremaining"
			if contents is (localized string "addandclickstarttostart") or contents is (localized string "clickstarttostart") then
				if therows is 0 then
					set contents to (localized string "addandclickstarttostart")
				else
					set contents to (localized string "clickstarttostart")
				end if
			end if
		end tell
	end tell
	
	-- CD TAB
	formatinit()
	set toformat to contents of popup button "formats" of box "box" of window "SongRedux"
	if toformat is in {audiocd, mp3cd} then
		set alldurs to contents of data cell durationnumcell of every data row of data source of table view "table" of scroll view "table" of window "SongRedux"
		set fulldur to calcbigdur(alldurs) of (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
		if toformat is audiocd then
			set pregap to (therows * (contents of popup button "pregap" of tab view item "cd" of tab view "formatbox" of box "box" of window "SongRedux"))
		else
			set pregap to 0
		end if
		set fulldur to (fulldur + pregap)
		set fulltime to (timeswap(fulldur))
		set toobig to false
		if toformat is audiocd then
			if fulldur > (contents of default entry "maxcd" of user defaults) then
				set toobig to true
			end if
			set runtimemeter to fulldur
		else
			if fulldur > 58000 then
				set toobig to true
			end if
			set runtimemeter to ((fulldur / 161.1111) + 4440) -- / 60)
			if fulldur < 43000 then
				set runtimemeter to ((fulldur / 51.183) + 3600)
			end if
			if fulldur < 29000 then
				set runtimemeter to (fulldur / 8.06) --483.33) -- / 60)
			end if
		end if
		tell tab view item "cd" of tab view "formatbox" of box "box" of window "SongRedux"
			set contents of control "totalruntime" to runtimemeter
			if toobig then
				set text color of text field "totalruntimetitle" to {65535, 0, 0}
				set contents of text field "totalruntimetitle" to (localized string "maxruntimeexceeded")
			else
				set text color of text field "totalruntimetitle" to {0, 0, 0}
				set contents of text field "totalruntimetitle" to (localized string "totalruntimecolonspace") & fulltime
			end if
		end tell
	end if
	update window "SongRedux"
	return therows
	
end gethowmany

on formatinit()
	set lossy to 0
	set aac to 1
	set mp3 to 2
	set wma to 3
	set threeg to 4
	set ogg to 5
	set lossless to 7
	set aiff to 8
	set wav to 9
	set applelossless to 10
	set flac to 11
	set burn to 13
	set audiocd to 14
	set mp3cd to 15
end formatinit

on workflowtoggle(sizechange)
	--call method "NSDisableScreenUpdates"
	tell window "SongRedux"
		set {pos1, pos2} to position of scroll view "table"
		set {boxpos1, boxpos2} to position of box "box"
		set oldsize to bounds of scroll view "table"
		set {x1, y1, x2, y2} to bounds
		set {tx1, ty1, tx2, ty2} to bounds of scroll view "table"
		--set {min1, min2} to minimum size
		--set visible of box "box" to false
		call method "disableFlushWindow" of it
		call method "disableScreenUpdatesUntilFlush" of it
		call method "disableUpdatesUntilFlush" of it
		set position of box "box" to {boxpos1, (boxpos2 + (sizechange) * -1)}
		set {bx1, by1, bx2, by2} to bounds of box "box"
		set bounds of image view "graybox" to {bx1, (by1 + sizechange), bx2, by2}
		set bounds of box "box" to {bx1, (by1 + sizechange), bx2, by2}
		set bounds of scroll view "table" to {tx1, (ty1 - sizechange), tx2, (ty2)}
		--		set bounds of scroll view "table" to {tx1, (ty1 - sizechange), tx2, (ty2 - sizechange)}
		set position of button "dragger" to {pos1, (pos2 - sizechange)}
		set bounds of button "dragger" to {tx1, (ty1 - sizechange), tx2, (ty2 - sizechange)}
		
		set bounds to {x1, (y1 + sizechange), x2, y2}
		--set minimum size to {min1, (min2 - sizechange)}
		--set visible of box "box" to true
		--update
		call method "enableFlushWindow" of it
	end tell
	--	call method "NSEnableScreenUpdates"
	return true
end workflowtoggle

on formatchecks()
	formatinit()
	-- SWAP BETWEEN EASY SETTINGS VIEWS --
	tell box "box" of window "SongRedux"
		set theformat to contents of popup button "formats"
	end tell
	set isamr to false
	--text field "xxaudio" of tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
	--text field "xxaudiotext" of tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
	tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
		set contents of text field "xxaudio" to ""
		set visible of text field "xxaudio" to false
		set visible of text field "xxaudiotext" to false
	end tell
	
	if theformat is aac then
		set formatimage to (load image "aac")
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			set contents of text field "xxaudiotext" to (localized string "extrafaacflags")
			set visible of text field "xxaudio" to true
			set visible of text field "xxaudiotext" to true
		end tell
	end if
	if theformat is mp3 then
		set formatimage to (load image "mp3")
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			set contents of text field "xxaudiotext" to (localized string "extralameflags")
			set visible of text field "xxaudio" to true
			set visible of text field "xxaudiotext" to true
		end tell
	end if
	if theformat is wma then
		set formatimage to (load image "wma")
	end if
	if theformat is threeg then
		set formatimage to (load image "3g")
		if current row of matrix "codectype" of tab view item "lossy" of tab view "formatbox" of box "box" of window "SongRedux" > 1 then
			set isamr to true
		end if
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			if isamr is false then
				set contents of text field "xxaudiotext" to (localized string "extrafaacflags")
				set visible of text field "xxaudio" to true
				set visible of text field "xxaudiotext" to true
			end if
		end tell
	end if
	if theformat is ogg then
		set formatimage to (load image "ogg")
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			set contents of text field "xxaudiotext" to (localized string "extraoggencflags")
			set visible of text field "xxaudio" to true
			set visible of text field "xxaudiotext" to true
		end tell
	end if
	if theformat is applelossless then
		set formatimage to (load image "applelossless")
	end if
	if theformat is aiff then
		set formatimage to (load image "aiff")
	end if
	if theformat is wav then
		set formatimage to (load image "wav")
	end if
	if theformat is flac then
		set formatimage to (load image "flac")
		tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
			set contents of text field "xxaudiotext" to (localized string "extraflacflags")
			set visible of text field "xxaudio" to true
			set visible of text field "xxaudiotext" to true
		end tell
	end if
	if theformat is in {audiocd, mp3cd} then
		set formatimage to (load image "cd")
	end if
	
	tell box "box" of window "SongRedux"
		--FORMAT NAME, then PICTURE
		set contents of text field "formatname" to title of popup button "formats"
		set image of image view "formaticon" to formatimage
		
		tell box "qualitybox"
			if theformat is not in {aac, mp3, wma, threeg, ogg} then
				set visible to false
			end if
			if isamr is true then
				set contents of text field "1" to (localized string "Tinyquality")
				set contents of text field "3" to (localized string "Standardquality")
			else
				set contents of text field "1" to (localized string "AMquality")
				set contents of text field "3" to (localized string "auto")
			end if
		end tell
		tell tab view "formatbox"
			set visible of text field "codec" of tab view item "lossy" to false
			set visible of matrix "codectype" of tab view item "lossy" to false
			if theformat is in {aac, mp3, wma, threeg, ogg} then
				set current tab view item to tab view item "lossy"
				if theformat is threeg then
					set visible of text field "codec" of tab view item "lossy" to true
					set visible of matrix "codectype" of tab view item "lossy" to true
				end if
			end if
			if theformat is in {aiff, wav, applelossless, flac} then
				set current tab view item to tab view item "lossless"
			end if
			if theformat is in {audiocd, mp3cd} then
				set current tab view item to tab view item "cd"
				if theformat is mp3cd then
					set visible of popup button "pregap" of tab view item "cd" to false
					set visible of text field "pregaptitle" of tab view item "cd" to false
				else
					set visible of popup button "pregap" of tab view item "cd" to true
					set visible of text field "pregaptitle" of tab view item "cd" to true
				end if
				my gethowmany()
			end if
		end tell
		tell box "workflowbox"
			if theformat is not in {aac, mp3, aiff, wav, applelossless} then
				set enabled of menu item 0 of popup button "postaction" to false
				set enabled of menu item 1 of popup button "postaction" to false
				set enabled of menu item 2 of popup button "postaction" to false
				set enabled of menu item 3 of popup button "postaction" to false
				if contents of popup button "postaction" is in {0, 1, 2} then
					set contents of popup button "postaction" to 3
					set enabled of popup button "postaction" to false
					set contents of button "postactiononoff" to false
				end if
			else
				set enabled of menu item 0 of popup button "postaction" to true
				set enabled of menu item 1 of popup button "postaction" to true
				if theformat is aac then
					set enabled of menu item 2 of popup button "postaction" to true
					set enabled of menu item 3 of popup button "postaction" to true
				else
					set enabled of menu item 2 of popup button "postaction" to false
					set enabled of menu item 3 of popup button "postaction" to false
				end if
			end if
		end tell
	end tell
	if theformat > 0 and theformat < 6 then
		set visible of box "qualitybox" of box "box" of window "SongRedux" to true
		if theformat is not threeg then
			if contents of default entry "qualitywide" of user defaults is false then
				set {bx1, by1, bx2, by2} to bounds of box "qualitybox" of box "box" of window "SongRedux"
				set bounds of box "qualitybox" of box "box" of window "SongRedux" to {bx1 - 105, by1, bx2, by2}
				set contents of default entry "qualitywide" of user defaults to true
			end if
		else
			if contents of default entry "qualitywide" of user defaults is true then
				set {bx1, by1, bx2, by2} to bounds of box "qualitybox" of box "box" of window "SongRedux"
				set bounds of box "qualitybox" of box "box" of window "SongRedux" to {bx1 + 105, by1, bx2, by2}
				set contents of default entry "qualitywide" of user defaults to false
			end if
		end if
	end if
end formatchecks

on openinfo()
	tell window "advanced"
		set content of control "advancedtabs" to 2
		set current tab view item of tab view "advancedbox" to tab view item "advancedinfobox" of tab view "advancedbox"
		show
		set enabled of button "settingssave" to false
		set enabled of button "settingsload" to false
		set enabled of button "settingsclearall" to false
	end tell
	try
		audinfo(null) of (load script (scripts path of main bundle & "/table.scpt" as POSIX file))
	end try
end openinfo

on advchanges()
	tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
		if (current item of combo box "audiohz" is 9 or contents of combo box "audiohz" is "" or contents of combo box "audiohz" is "Auto") and contents of text field "audiobitrate" is "" and contents of button "fitonoff" is false then
			set visible of text field "advancedaudiochanges" to false
			set visible of box "separator" to true
		else
			set visible of text field "advancedaudiochanges" to true
			set visible of box "separator" to false
		end if
	end tell
end advchanges

on timeswap(whattime)
	if "?" is in whattime or "DRM" is in whattime then
		return 0
	end if
	if ":" is in whattime then
		set text item delimiters to ":"
		if (count of text items of (whattime as string)) is 3 then
			set hoursandminutes to (((text item 1 of whattime) * 3600) + ((text item 2 of whattime) * 60))
		else
			set hoursandminutes to ((text item 1 of whattime) * 60)
		end if
		set thenewseconds to hoursandminutes + (last text item of whattime)
		return thenewseconds as number
	else
		set theminutes to (round (whattime / 60) rounding down)
		set theseconds to (((theminutes) * 60) - whattime) * -1
		set text item delimiters to ""
		if (count of text items of (theseconds as string)) is 1 then
			set theseconds to ("0" & (theseconds))
		end if
		if theminutes > 59 then
			set thenewminutes to timeswap(theminutes)
		else
			set thenewminutes to theminutes
		end if
		set thetime to (thenewminutes & ":" & theseconds as string)
	end if
	return thetime
end timeswap

on lossiesset(theplist)
	tell box "box" of window "SongRedux"
		if contents of popup button "formats" is threeg then
			tell tab view "formatbox"
				set codecs to (contents of every cell of matrix "codectype" of tab view item "lossy")
				if item 1 of codecs then
					set whichcodec to 1 as integer
				end if
				if item 2 of codecs then
					set whichcodec to 2 as integer
				end if
				if item 3 of codecs then
					set whichcodec to 3 as integer
				end if
				--	tell application "System Events"
				--					make new property list item at end of property list items of property list file theplist with properties {name:"lossy3gcodec", value:1}
				--					set value of property list item "lossy3gcodec" of property list file theplist to whichcodec
				--	end tell
				do shell script "/usr/bin/defaults write " & theplist & " lossy3gcodec -int " & whichcodec
			end tell
		end if
		set qualitylevel to contents of slider "quality" of box "qualitybox" as integer
		--	tell application "System Events"
		--		make new property list item at end of property list items of property list file theplist with properties {name:"lossyquality", value:3}
		--		set value of property list item "lossyquality" of property list file theplist to qualitylevel
		--	end tell
		do shell script "/usr/bin/defaults write " & theplist & " lossyquality -int " & qualitylevel
	end tell
end lossiesset

on lossiesload(theplist)
	--	tell application "System Events"
	--		set loadplist to property list file theplist
	--		if toformat is threeg then
	--			set whichcodec to value of property list item "lossy3gcodec" of loadplist
	--		end if
	--		set quality to value of property list item "lossyquality" of loadplist
	--	end tell
	try
		if toformat is threeg then
			set whichcodec to (do shell script "/usr/bin/defaults read " & theplist & " lossy3gcodec") as integer
		end if
		set quality to (do shell script "/usr/bin/defaults read " & theplist & " lossyquality") as integer
	on error
		if toformat is threeg then
			set whichcodec to 1
		end if
		set quality to 3
	end try
	tell box "box" of window "SongRedux"
		if contents of popup button "formats" is threeg then
			tell matrix "codectype" of tab view item "lossy" of tab view "formatbox"
				set {contents of cell 1, contents of cell 2, contents of cell 3} to {false, false, false}
				set contents of cell whichcodec to true
			end tell
		end if
		set contents of slider "quality" of box "qualitybox" to quality
	end tell
	formatchecks()
end lossiesload

on losslessset(theplist)
	return true
end losslessset

on losslessload(theplist)
	formatchecks()
end losslessload

on cdset(theplist)
	set pregap to contents of popup button "pregap" of tab view item "cd" of tab view "formatbox" of box "box" of window "SongRedux"
	--	tell application "System Events"
	--		make new property list item at end of property list items of property list file theplist with properties {name:"cdpregap", value:2}
	--		set value of property list item "cdpregap" of property list file theplist to pregap
	--	end tell
	do shell script "/usr/bin/defaults write " & theplist & " cdpregap -int " & pregap
end cdset

on cdload(theplist)
	--	display dialog "what"
	try
		set pregap to (do shell script "/usr/bin/defaults read " & theplist & " cdpregap") as integer
	on error
		set pregap to 2
	end try
	set contents of popup button "pregap" of tab view item "cd" of tab view "formatbox" of box "box" of window "SongRedux" to pregap
	formatchecks()
end cdload

on systemhealth()
	set errors to 0
	set tmpok to true
	set headok to true
	set pathok to true
	set uucodeok to true
	set bzipok to true
	set gzipok to true
	set idok to true
	set perlok to true
	
	try
		do shell script "echo test ; exit 0"
	on error
		show window "SongRedux"
		display alert (localized string "fatalsystemerror") message (localized string "standardadditionsfull") as warning default button "Quit"
		quit
		error number -128
	end try
	
	do shell script "echo test > /tmp/ahtest ; exit 0"
	do shell script "/bin/cat /tmp/ahtest ; exit 0"
	if the result is not "test" then
		try
			do shell script "/bin/chmod -R 777 /tmp ; exit 0"
			do shell script "/bin/rm -f /tmp/ahtest ; exit 0"
		end try
		do shell script "echo test > /tmp/ahtest ; exit 0"
		do shell script "/bin/cat /tmp/ahtest ; exit 0"
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
	do shell script "echo test | uuencode -m - | uudecode -p ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set uucodeok to false
	end if
	do shell script "echo test | gzip | gunzip ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set gzipok to false
	end if
	do shell script "echo test | bzip2 | bunzip2 ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set bzipok to false
	end if
	do shell script "/usr/bin/id | /usr/bin/cut -c 1-3 ; exit 0"
	if the result is not "uid" then
		set errors to (errors + 1)
		set idok to false
	end if
	
	do shell script "echo \"print 'test';\" | /usr/bin/perl - ; exit 0"
	if the result is not "test" then
		set errors to (errors + 1)
		set perlok to false
	end if
	if errors is 0 then
		return true
	else
		show window "SongRedux"
		set whichbrokens to ""
		if tmpok is false then
			set whichbrokens to (whichbrokens & (localized string "tmpdirerror"))
		end if
		if headok is false then
			set whichbrokens to (whichbrokens & (localized string "headerror"))
		end if
		if pathok is false then
			set whichbrokens to (whichbrokens & (localized string "headerror"))
		end if
		if uucodeok is false then
			set whichbrokens to (whichbrokens & (localized string "uucodeerror"))
		end if
		if gzipok is false then
			set whichbrokens to (whichbrokens & (localized string "gziperror"))
		end if
		if bzipok is false then
			set whichbrokens to (whichbrokens & (localized string "bziperror"))
		end if
		if idok is false then
			set whichbrokens to (whichbrokens & (localized string "iderror"))
		end if
		if perlok is false then
			set whichbrokens to (whichbrokens & (localized string "perlerror"))
		end if
		display alert (localized string "fatalsystemerror") message ((localized string "falalsystemerrortext") & whichbrokens & (localized string "willnowquit")) as warning default button (localized string "quit")
		quit
		error number -128
		return false
	end if
end systemhealth
