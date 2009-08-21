-- preview.applescript
-- ReduxZero
global decimal
global howmany
global whichone
global errors
global thePath
global theFilepath
global theorigpath
global thefixedfilepath
global thenewquotedfilepath
global thequotedorigpath
global theFile
global theFile2
global stitch
global destpath
global backslash
global theRow
global theList
global isrunning
global outputfile
global dashr
global vn
global vcodec
global normalnuller
global mpegaspect
global origheight
global origwidth
global extaudio
global threadscmd
global extaudiofile
global movfps2
global movfps
global movwidth
global morzeight
global pipe
global forcepipe
global qtproc
global ismov
global ar
global ipodbox
global advanced
global croptop
global cropbottom
global ext
global cropleft
global cropright
global optim
global isdone
global extaudiofile
global estimyet
global percent1
global percent
global remaining
global s
global lessthan
global howlonglessthan
global starttime
global pid
global snippets
global deinterlace
global fps
global cons
global ac
global ab
global type
global audstring
global deinterlace
global ffmpegstring
global previewstring
global format
global widescreen
global previewpic
global normalend
global ffvideos
global ffaudios
global origAR
global origPAR
global filenoext
global xgrid
global mp4box
global avibox
global wmvbox
global flashbox
global pspbox
global mpegbox
global thetarget
global dvdbox
global twopass
global colorspace
global thequotedfile
global preview
global dvdwide
global theaspect
global proctype
global qmin
global ffmpegloc
global fulldur
global URLWithString
global thequotedapppath
global isvideots
global isdvd
global isvideots
global sysver
global fullstarttime
global rawdvdaudiotrack
global isappletv2

--  Created by Tyler Loch on 4/4/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.

on clicked theObject
	set advanced to window "advanced"
	if theObject is button "showpreview" of advanced then
		if visible of window "Preview" is false then
			show window "Preview"
			set state of menu item "showpreview" of menu "window" of main menu to true
			set thePath to path of the main bundle as string
			set thequotedapppath to quoted form of thePath
			set visible of progress indicator "previewspinner" of window "Preview" to false
			--			try
			--				set URLWithString to call method "URLWithString:" of class "NSURL" with parameter "file://" & thePath & "/Contents/Resources/loading.html"
			--				set requestWithURL to call method "requestWithURL:" of class "NSURLRequest" with parameter URLWithString
			--				set mainFrame to call method "mainFrame" of object (view "webkitpreview" of window "preview")
			--				call method "loadRequest:" of mainFrame with parameter requestWithURL
			--			end try
			delay 0.1
		end if
	end if
	dopreview()
end clicked


on dopreview()
	set thePath to path of the main bundle as string
	set snippets to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/snippets.scpt"))
	set mainscript to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/main.scpt"))
	tmpgetter() of snippets
	procdecimal() of mainscript
	bunchavars() of mainscript
	show window "Preview"
	set visible of progress indicator "previewspinner" of window "Preview" to true
	tell progress indicator "previewspinner" of window "Preview" to start
	try
		if (do shell script " echo " & (ASCII character 128) & "a") is "a" then
			set backslash to (ASCII character 128)
		else
			set backslash to "\\"
		end if
	on error
		set backslash to "\\"
	end try
	set xgrid to false
	set stitch to false
	set preview to true
	set theaspect to 0
	set dvdwide to false
	set sysver to (do shell script "uname -r | cut -c 1- | sed -e 's/" & backslash & ".//g'")
	set theList to (data source of table view "files" of scroll view "files" of window "ReduxZero")
	set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
	set colorspace to " "
	set threadscmd to " -threads 2 "
	try
		set threadscmd to " -threads " & (((do shell script "/usr/sbin/sysctl hw.logicalcpu | /usr/bin/cut -c 16-") as number) * 2) & " "
	end try
	--set ext to ""
	set fulldur to 0
	set previewpic to "/tmp/rzpreviewpic.jpg"
	set previewmov to "/tmp/rzpreviewmov"
	try
		do shell script "rm " & previewpic
	end try
	set ffmpegloc to (thequotedapppath & "/Contents/Resources/")
	set tilde to ""
	set rzver to "135"
	
	
	if type is "dvdbox" then
		if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is true then
			set theaspect to 0
			dvdcounter() of mainscript
			set stitchstack to {}
			set stitch to true
			if theaspect > 0 then
				set dvdwide to true
			else
				set dvdwide to false
			end if
		end if
	end if
	set howmany to (number of data rows of data column "Files" of (data source of table view "files" of scroll view "files" of window "ReduxZero"))
	if howmany is 0 then
		display alert (localized string "nofiles")
		tell progress indicator "spinner" of window "ReduxZero" to stop
		set visible of window "preview" to false
		error number -128
	end if
	set itsselected to true
	try
		(contents of data cell 1 of selected data row of table view "files" of scroll view "files" of window "ReduxZero" as string) as POSIX file
	on error
		set itsselected to false
	end try
	if itsselected is true then
		try
			pathings(selected data row of table view "files" of scroll view "files" of window "ReduxZero") of snippets
		on error
			set thequotedorigpath to (quoted form of (contents of data cell 1 of selected data row of table view "files" of scroll view "files" of window "ReduxZero" as string))
			set thequotedfile to "rzpreviewfile"
		end try
	else
		try
			pathings(data row 1 of data column "Files" of the data source of table view "files" of scroll view "files" of window "ReduxZero") of snippets
		on error
			set thequotedorigpath to (quoted form of (contents of data cell 1 of data row 1 of data column "Files" of the data source of table view "files" of scroll view "files" of window "ReduxZero" as string))
			set thequotedfile to "rzpreviewfile"
		end try
	end if
	set whichone to 1
	set preview to true
	set previewpic to "/tmp/rzpreviewpic.jpg"
	set previewmov to "/tmp/rzpreviewmov"
	try
		do shell script thequotedapppath & "/Contents/Resources/lsdvd " & thequotedorigpath
		set isvideots to true
	end try
	if isvideots is true then
		dvdtitlefinder() of snippets
	else
		thedur() of snippets
	end if
	if isvideots is false then
		theorigs() of snippets
	end if
	if type is "dvdbox" then
		if content of button "dvdforce" of box "dvdadvbox" of advanced is true then
			set dvdforce to (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced)
			if dvdforce is 0 then
				set dvdwide to true
				do shell script "echo 16by9 > /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdwide"
			end if
		end if
	end if
	advanceds() of snippets
	if isvideots is true then
		videotsproc() of snippets
	end if
	quicktimedetects() of snippets
	if type is "ipodbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/ipod.scpt"))
		set fileext to ".mp4"
	end if
	if type is "dvbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/dv.scpt"))
		set fileext to ".dv"
	end if
	if type is "mp4box" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/mp4.scpt"))
		set fileext to ".mp4"
	end if
	if type is "avibox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/avi.scpt"))
		set fileext to ".avi"
	end if
	if type is "wmvbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/wmv.scpt"))
		set fileext to ".wmv"
	end if
	if type is "flashbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/flash.scpt"))
		set fileext to ".flv"
	end if
	if type is "pspbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/psp.scpt"))
		set fileext to ".mp4"
	end if
	if type is "mpegbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/mpeg.scpt"))
		set fileext to ".mpg"
	end if
	if type is "dvdbox" then
		set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/dvd.scpt"))
		set fileext to ".vob"
	end if
	set prevsec to (contents of text field "prevsec" of window "Preview")
	
	
	if content of button "prevcomp" of window "preview" is true then
		set previewstring to (" -ss " & (prevsec - 1) & " -vframes 31 -an " & previewmov & fileext)
		mainstart() of proctype
		do shell script "echo \"" & ffmpegstring & "\" > /tmp/reduxzero_command"
		do shell script ffmpegstring
		--do shell script ("'" & ffmpegloc & "ffmpeg' -y -i " & previewmov & fileext & " -ss 1 -an -vframes 1 -vcodec ppm -f rawvideo - | '" & thePath & "/Contents/Resources/cjpeg' -quality 100 -outfile " & previewpic)
		--tell application "Terminal" to do script (ffmpegloc & "ffmpeg -y " & " -i " & previewmov & fileext & " -ss 00:00:00.9 -an -vframes 1 -threads 1 -vcodec mjpeg -f image2 " & previewpic)
		do shell script (ffmpegloc & "ffmpeg -y " & " -i " & previewmov & fileext & " -ss 00:00:00.95 -an -vframes 1 -threads 1 -vcodec mjpeg -f image2 " & previewpic)
	else
		set previewstring to (" -ss " & prevsec & " -an -vframes 1 -threads 1 -vcodec mjpeg -qmin 1 -f image2 " & previewpic)
		-- -vcodec ppm -f rawvideo - | '" & thePath & "/Contents/Resources/cjpeg' -quality 100 -outfile " & previewpic)
		mainstart() of proctype
		do shell script ffmpegstring
	end if
	
	tell application "Image Events"
		activate
		set this_image to open (file (previewpic))
		set {thewidth, theheight} to (the dimensions of this_image)
		quit
	end tell
	if thewidth < 320 then
		set thewidth to 320
	end if
	set size of window "preview" to {(thewidth + 40), ((theheight + 82) + 4)}
	
	try
		set URLWithString to call method "URLWithString:" of class "NSURL" with parameter "file://" & previewpic
		set requestWithURL to call method "requestWithURL:" of class "NSURLRequest" with parameter URLWithString
		set mainFrame to call method "mainFrame" of object (view "webkitpreview" of window "preview")
		call method "loadRequest:" of mainFrame with parameter requestWithURL
	end try
	--call method "stringByEvaluatingJavaScriptFromString:" of  view "webkitpreview" of panel "preview" with parameter "location.href='file:///Users/tylerl/Desktop/yeah2.jpg'"
	set visible of progress indicator "previewspinner" of window "Preview" to false
	
	delay 1
	try
		do shell script "rm /tmp/rzpreview*"
	end try
	set the content of text field "timeremaining" of window "ReduxZero" to ""
end dopreview

on should close theObject
	set visible of theObject to false
end should close
