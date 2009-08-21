-- doitmulti.applescript
-- ReduxZero


global decimal
global howmany
global whichone
global errors
global fileext
global thequotedapppath
global theFilepath
global thefixedfilepath
global thenewquotedfilepath
global theorigpath
global thequotedorigpath
global theFile
global theFile2
global destpath
global theRow
global theList
global qtresult
global isrunning
global threadscmd
global audrand
global outputfile
global dvdaudiotrack
global qtpipe
global dvdvideotrack
global workflow
global sysver
global starttime
global dashr
global vn
global vcodec
global normalnuller
global mpegaspect
global stitchedfile
global origheight
global origwidth
global extaudio
global extaudiofile
global movfps2
global thefolder
global movfps
global movwidth
global morzeight
global pipe
global forcepipe
global qtproc
global ismov
global ar
global ipodbox
global croptop
global cropbottom
global cropleft
global cropright
global optim
global advanced
global ratio
global snippets
global deinterlace
global fps
global type
global previewstring
global ffmpegstring
global xpipe
global ffvideos
global ffaudios
global homedir
global xgridffmpegstring
global xgrid
global xgridscript
global origAR
global origPAR
global thePath
global filenoext
global thequotedfile
global ext
global proctype
global moreend
global stitchstack
global stitch
global streamer
global destpath2
global mpegbox
global fulldur
global parts
global dvdbox
global twopass
global colorspace
global theaspect
global dvdwide
global qmin
global preview
global ffmpegloc
global ver
global isvideots
global istivo
global filesize
global imagesize
global backslash
global isdvd
global dvdforce
global ishack
global fullstarttime
global isappletv2
global rawdvdaudiotrack
global isvlc092

on clicked theObject
	doitmulti("normal")
end clicked

on bounds changed theObject
	doitmulti("auto")
	set contents of text field "supper" of window "ReduxZero" to ""
	update window "ReduxZero"
end bounds changed

on doitmulti(whichworkflow)
	set workflow to whichworkflow
	procdecimal()
	dasstarten()
	--	display dialog workflow
	set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
	if type is "dvdbox" then
		set isalright to true
		set spaceleft to 13
		try
			set spaceleft to (do shell script "/bin/df -g / | /usr/bin/tail -1 | /usr/bin/awk '{print $4}'") as number
			--		tell application "System Events" to set spaceleft to (get free space of startup disk) as number
		end try
		if workflow is "normal" then
			if contents of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is true then
				if spaceleft < 12 then
					display alert (localized string "dvdspacealert1") message (localized string "dvdspacealert2") as warning default button (localized string "doitanyway") other button (localized string "Cancel")
					if button returned of the result is (localized string "Cancel") then
						set indeterminate of progress indicator "bar" of window "ReduxZero" to false
						tell progress indicator "bar" of window "ReduxZero" to stop
						set isalright to false
					end if
				end if
			end if
			if isalright is false then
				error number -128
			end if
		end if
		set theaspect to 0
		if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is true then
			dvdcounter()
			set stitchstack to {}
			set stitch to true
			if theaspect > 0 then
				set dvdwide to true
			else
				set dvdwide to false
			end if
			if content of button "dvdforce" of box "dvdadvbox" of advanced is true then
				set dvdforce to (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced)
				if dvdforce is 0 then
					set dvdwide to true
					do shell script "echo 16by9 > /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdwide"
				end if
			end if
		end if
	end if
	--This is where everything happens. Sometimes multiple times.
	repeat with theRow in every data row of data column "Files" of theList
		
		--Start the loop and give some initial feedback.
		set isrunning to "1"
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "startingfile") & whichone & "..."
		set ver to 0
		try
			pathings(theRow) of snippets
		on error
			set thequotedorigpath to (quoted form of (contents of data cell 1 of theRow as string))
		end try
		bunchavars()
		try
			do shell script thequotedapppath & "/Contents/Resources/lsdvd " & thequotedorigpath
			set isvideots to true
		end try
		if isvideots is true then
			dvdtitlefinder() of snippets
		else
			thedur() of snippets
		end if
		if the result is false then
			if (do shell script "file " & thequotedorigpath & " | rev | awk '{print $1}' | rev") is "directory" then
				if ((do shell script "tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep VIDEO_TS | wc -l") as number) is 1 then
					display alert (localized string "videotserror") attached to window "ReduxZero" default button (localized string "inadequacyok")
				else
					display alert (localized string "nofolders") attached to window "ReduxZero" default button (localized string "inadequacyok")
				end if
			else
				if ((do shell script "tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep 'Unknown format' | wc -l") as number) is 1 then
					display alert theFile & (localized string "unknownformat") attached to window "ReduxZero" default button (localized string "inadequacyok")
				end if
				if ((do shell script "tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep corrupted | wc -l") as number) is 1 then
					display alert theFile & (localized string "fileerror") attached to window "ReduxZero" default button (localized string "inadequacyok")
				end if
				if ext is "swf" and (",Video," is not in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur") or "Compressed" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur")) then
					display alert (localized string "errorprevented") & theFile & (localized string "conversionfromstarting") & "

" & (localized string "Only Flash video files can be converted. Flash animation files are unsupported.") attached to window "ReduxZero" default button (localized string "inadequacyok")
				end if
				--				if ((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep mpeg2video | grep damaged | wc -l") as number) > 0 then
				--					display alert (localized string "encryptedvob") attached to window "ReduxZero" default button (localized string "inadequacyok")
				--				end if
			end if
			set errors to (errors + 1)
		else
			theorigs() of snippets
			if type is "dvdbox" then
				if content of button "dvdforce" of box "dvdadvbox" of advanced is true then
					set dvdforce to (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced)
					if dvdforce is 0 then
						set dvdwide to true
						do shell script "echo 16by9 > /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdwide"
					end if
				end if
			end if
			
			if isvideots is true then
				videotsproc() of snippets
				set qtresult to true
			else
				quicktimedetects() of snippets
			end if
			if qtresult is false then
				if ext is "m4v" then
					display alert (localized string "itunesdrm") attached to window "ReduxZero" default button (localized string "madatapple")
				else
					display alert theFile & (localized string "fileerror") attached to window "ReduxZero" default button (localized string "inadequacyok")
				end if
				set errors to (errors + 1)
			else
				advanceds() of snippets
				
				----****THE ROUTINE TYPES****----
				set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
				if type is "ipodbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/ipod.scpt"))
				end if
				if type is "dvbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/dv.scpt"))
				end if
				if type is "mp4box" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/mp4.scpt"))
				end if
				if type is "avibox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/avi.scpt"))
				end if
				if type is "wmvbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/wmv.scpt"))
				end if
				if type is "flashbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/flash.scpt"))
				end if
				if type is "pspbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/psp.scpt"))
					set destpath0 to contents of text field "path" of window "ReduxZero"
					if destpath0 is not "" then
						if (do shell script "/bin/test -e " & quoted form of destpath0 & "/PSP ; echo $?") is "0" then
							try
								do shell script "mkdir " & quoted form of destpath0 & "/MP_ROOT"
							end try
							try
								do shell script "mkdir " & quoted form of destpath0 & "/MP_ROOT/100MNV01"
							end try
							try
								do shell script "mkdir " & quoted form of destpath0 & "/MP_ROOT/100ANV01"
							end try
							try
								do shell script "mkdir " & quoted form of destpath0 & "/VIDEO"
							end try
							if content of button "h264" of tab view item "pspbox" of tab view "tabbox" of window "ReduxZero" is true then
								if content of cell "optim2" of matrix "optim" of tab view item "pspbox" of tab view "tabbox" of window "ReduxZero" is false then
									set contents of text field "path" of window "ReduxZero" to destpath0 & "/MP_ROOT/100ANV01/"
								else
									set contents of text field "path" of window "ReduxZero" to destpath0 & "/VIDEO/"
								end if
							else
								if content of cell "optim2" of matrix "optim" of tab view item "pspbox" of tab view "tabbox" of window "ReduxZero" is false then
									set contents of text field "path" of window "ReduxZero" to destpath0 & "/MP_ROOT/100MNV01/"
								else
									set contents of text field "path" of window "ReduxZero" to destpath0 & "/VIDEO/"
								end if
							end if
							update window "ReduxZero"
							set destpath to (quoted form of (contents of text field "path" of window "ReduxZero" as string))
							set destpath2 to destpath
						end if
					end if
				end if
				if type is "mpegbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/mpeg.scpt"))
				end if
				if type is "dvdbox" then
					set proctype to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/dvd.scpt"))
				end if
				
				mainstart() of proctype
				do shell script "echo working > /tmp/rztemp/" & fullstarttime & "/reduxzero_cancel"
				if xgrid is true then
					xgridgo() of xgridscript
				else
					mainnormalgo() of snippets
				end if
				
				if xgrid is false then
					mainend() of proctype
					try
						if isvlc092 then
							do shell script "kill -9 `ps -xww | grep 'VLC -I' | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
						end if
					end try
				end if
				
			end if
		end if
		wrapup()
		
	end repeat
	
	
	
	if xgrid is true then
		xgridbarloop() of xgridscript
		xgridend() of xgridscript
	end if
	
	if stitch is true and xgrid is false then
		stitcher()
	end if
	
	try
		if istivo is true then
			set tivopath to quoted form of ((do shell script "defaults read com.tivo.desktop FileVideo | grep SharedItems | awk -F '\"' '{print $2}'") & "/")
			if destpath is tivopath then
				do shell script "'/Library/Application Support/TiVo/StopTiVoDesktop' ; '/Library/Application Support/TiVo/TiVoDesktop'  > /dev/null 2>&1 &"
			end if
		end if
	end try
	
	theend() of snippets
	
	set enabled of menu item "resume" of menu "file" of main menu to false
	set enabled of menu item "pause" of menu "file" of main menu to false
end doitmulti

on dvdcounter()
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "calculatingtime")
	repeat with theRow in every data row of data column "Files" of theList
		pathings(theRow) of snippets
		bunchavars()
		try
			do shell script thequotedapppath & "/Contents/Resources/lsdvd " & thequotedorigpath
			set isvideots to true
		end try
		if isvideots is true then
			set preview to true
			dvdtitlefinder() of snippets
			--		display dialog (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration")
			set preview to false
		else
			thedur() of snippets
		end if
		theorigs() of snippets
		set plus to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration | awk -F . '{print $1}'")
		set fulldur to (fulldur + plus)
	end repeat
	if fulldur > 64999 then
		display dialog (localized string "bigdvd")
	end if
	do shell script "echo " & fulldur & " > /tmp/rztemp/" & fullstarttime & "/reduxzero_fulldur"
	set whichone to 1
end dvdcounter

on stitcher()
	--	if type is "ipodbox" or type is "mp4box" or type is "pspbox" or type is "pspwidebox" then
	--		set bigstitch to ""
	--		set theorder to 1
	--		repeat with donefile in every item of stitchstack
	--			do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 " & donefile & " " & destpath & "merge" & theorder & ".temp.mp4 > /dev/null 2>&1 ; exit 0"
	--			set bigstitch to (bigstitch & " " & destpath & "merge" & theorder & ".temp.mp4")
	--			set theorder to (theorder + 1)
	--		end repeat
	--		do shell script "" & thequotedapppath & "/Contents/Resources/catMovies hello /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & bigstitch
	--		do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & destpath2 & "/ReduxZeroCombinedFile.mp4 > /dev/null 2>&1 ; exit 0"
	--		try
	--			if content of button "hint" of mp4box is true then
	--				do shell script "" & thequotedapppath & "/Contents/Resources/mp4creator -hint=1 " & newext & moreend -- & " 2&1> /dev/null ;  exit 0"
	--				do shell script "" & thequotedapppath & "/Contents/Resources/mp4creator -hint=2 " & newext & moreend -- & " 2&1> /dev/null ;  exit 0"
	--			end if
	--		end try
	--		do shell script "/bin/rm /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov"
	--		do shell script "/bin/rm " & bigstitch
	--	end if
	
	set stitchwentwell to true
	
	
	if type is "dvdbox" then
		dvdstitcher() of proctype
	else
		set bigstitch to ""
		repeat with donefile in every item of stitchstack
			set bigstitch to (bigstitch & " " & donefile)
		end repeat
		if type is "mpegbox" then
			set ext to "mpg"
		end if
		if type is "dvbox" then
			if content of button "fcp" of tab view item "dvbox" of tab view "tabbox" of window "ReduxZero" is true then
				set ext to "mov"
			else
				set ext to "dv"
			end if
		end if
		if type is "avibox" then
			set ext to "avi"
		end if
		if type is "ipodbox" or type is "mp4box" or type is "pspbox" or type is "pspwidebox" then
			if isappletv2 is true then
				set ext to "mov"
			else
				set ext to "mp4"
			end if
		end if
		if ext is "mpg" then
			if fileext is ".m2t" or fileext is ".ts" then --or istivo is true then
				do shell script "/bin/cat " & bigstitch & " > " & destpath2 & stitchedfile & fileext
			else
				do shell script "" & thequotedapppath & "/Contents/Resources/mpgtx -j " & bigstitch & " --force -o " & destpath2 & stitchedfile & "." & ext
			end if
		end if
		if ext is "dv" then
			do shell script "/bin/cat " & bigstitch & " > " & destpath2 & stitchedfile & "." & ext
		end if
		if ext is "avi" then
			do shell script "" & thequotedapppath & "/Contents/Resources/avimerge -o " & destpath2 & stitchedfile & "." & ext & " -i " & bigstitch
		end if
		if ext is "mp4" or ext is "mov" then
			do shell script "" & thequotedapppath & "/Contents/Resources/catMovies hello /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & bigstitch
			if ext is "mp4" then
				--	try
				if content of button "hint" of (tab view item "mp4box" of tab view "tabbox" of window "ReduxZero") is true then
					do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4stream --exporter=mpg4 /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & destpath2 & stitchedfile & ".mp4 > /dev/null 2>&1 ; exit 0"
					--	do shell script "" & thequotedapppath & "/Contents/Resources/mp4creator -hint=1 " & newext & moreend -- & " 2&1> /dev/null ;  exit 0"
					--	do shell script "" & thequotedapppath & "/Contents/Resources/mp4creator -hint=2 " & newext & moreend -- & " 2&1> /dev/null ;  exit 0"
				else
					do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & destpath2 & stitchedfile & ".mp4 > /dev/null 2>&1 ; exit 0"
					--	do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & destpath2 & stitchedfile & ".mp4 > /dev/null 2>&1 ; exit 0"
					--	display dialog "uhh"
				end if
				--	end try
			else
				do shell script thequotedapppath & "/Contents/Resources/flattercmd /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov " & destpath2 & stitchedfile & ".mov> /dev/null 2>&1 ; exit 0"
			end if
			try
				do shell script "/bin/rm /tmp/rztemp/" & fullstarttime & "/reduxzero_combined.mov"
			end try
			if (do shell script "/bin/test -f " & destpath2 & stitchedfile & "." & ext & " ; echo $?") is "0" then
				set stitchwentwell to true
			else
				set stitchwentwell to false
				--display dialog "nooooo bad stitch"
			end if
		end if
		--	try
		if stitchwentwell is true then
			--	display dialog "yay good stitch"
			try
				do shell script "/bin/rm " & bigstitch
			end try
			try
				if content of button "autoadd" of (tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero") is true then
					
					set itunesfile to (do shell script "echo " & destpath2 & stitchedfile & fileext) as POSIX file
					do shell script "osascript -e 'tell application \"iTunes\" to add \"" & itunesfile & "\" '&> /dev/null &"
					--display dialog itunesfile 
					--tell application "iTunes" to add itunesfile
					--do shell script "/usr/bin/open -a /Applications/iTunes.app " & newext & moreend
				end if
			end try
			
		end if
		--	end try
	end if
end stitcher

on procdecimal()
	set decimal to ""
	if (0.73 as string) is "0,73" then
		set decimal to "comma"
	end if
	(*	try
		set decimaltry to "0.73" as number
	on error
		set decimal to "comma"
	end try *)
	try
		if (do shell script " echo " & (ASCII character 128) & "a") is "a" then
			set backslash to (ASCII character 128)
		else
			set backslash to "\\"
		end if
	on error
		set backslash to "\\"
	end try
end procdecimal

on dasstarten()
	set thePath to path of the main bundle as string
	set snippets to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/snippets.scpt"))
	tmpgetter() of snippets
	--This is where animation is neat.
	try
		set uses threaded animation of progress indicator "bar" of window "ReduxZero" to true
	end try
	set indeterminate of progress indicator "bar" of window "ReduxZero" to true
	tell progress indicator "bar" of window "ReduxZero" to start
	update window "ReduxZero"
	--		tell progress indicator "spinner" of window "ReduxZero" to start
	set theList to (data source of table view "files" of scroll view "files" of window "ReduxZero")
	set parts to "/usr/bin/gunzip"
	--This is where we figure out how many files and make the progress bar fit, and set some global variables
	set howmany to (number of data rows of data column "Files" of theList)
	if howmany is 0 then
		set indeterminate of progress indicator "bar" of window "ReduxZero" to false
		tell progress indicator "bar" of window "ReduxZero" to stop
		display alert (localized string "nofiles")
		error number -128
	end if
	set qtpipe to "-"
	set sysver to (do shell script "uname -r | cut -c 1")
	set minimum value of progress indicator "bar" of window "ReduxZero" to 1
	set maximum value of progress indicator "bar" of window "ReduxZero" to howmany + 1
	set the content of progress indicator "bar" of window "ReduxZero" to 1
	set threadscmd to " -threads 2 "
	try
		set threadscmd to " -threads " & (((do shell script "/usr/sbin/sysctl hw.logicalcpu | /usr/bin/cut -c 16-") as number) * 2) & " "
	end try
	if threadscmd is " -threads 0 " then
		set threadscmd to " -threads 2 "
	end if
	set whichone to 1
	set thequotedapppath to quoted form of thePath
	set ffmpegloc to (thequotedapppath & "/Contents/Resources/")
	set tilde to ""
	set rzver to "135"
	--set thequotedapppath to (quoted form of POSIX path of thePath)
	--set thequotedapppath to thequotedapppath2 as text
	--This is where we start off with absolutely no problems whatsoever.
	set errors to 0
	set xgrid to false
	set preview to false
	set theaspect to 0
	set stitch to false
	set fulldur to 0
	if content of button "stitch" of window "ReduxZero" is true then
		set stitchstack to {}
		set stitch to true
		if (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string) is not "dvdbox" then
			--	(localized string "singlefilexgrid1")
			if contents of text field "supper" of window "ReduxZero" is "" then
				set stitchedfile to ("/" & quoted form of (text returned of (display dialog (localized string "namestitched") with icon 1 default answer "ReduxZeroCombinedFile" giving up after 60)))
				try
					if button returned of the result is "Cancel" then
						set indeterminate of progress indicator "bar" of window "ReduxZero" to false
						tell progress indicator "bar" of window "ReduxZero" to stop
						error number -128
					end if
				end try
				if stitchedfile is "" then
					set stitchedfile to "ReduxZeroCombinedFile"
				end if
			else
				set stitchedfile to contents of text field "supper" of window "ReduxZero" as Unicode text
			end if
		end if
	end if
	if content of button "xgrid" of window "ReduxZero" is true then
		if howmany is 1 then
			display alert (localized string "singlefilexgrid1") message (localized string "singlefilexgrid2") as critical default button (localized string "doitanyway") other button (localized string "Cancel")
			if button returned of the result is (localized string "Cancel") then
				set indeterminate of progress indicator "bar" of window "ReduxZero" to false
				tell progress indicator "bar" of window "ReduxZero" to stop
				error number -128
			end if
		end if
		set xgrid to true
		set homedir to do shell script "cd ~ ; pwd"
		if (do shell script "/bin/test -d /tmp/rztemp/reduxzero_web ; echo $?") is "0" then
			try
				do shell script "/bin/rm -rf /tmp/rztemp/reduxzero_web"
			end try
		end if
		try
			do shell script "/bin/mkdir /tmp/rztemp/reduxzero_web"
		end try
		do shell script "/bin/cp " & ffmpegloc & "ffmpeg /tmp/rztemp/reduxzero_web/ffmpeg"
		do shell script "/bin/cp " & thequotedapppath & "/Contents/Resources/movtoy4m /tmp/rztemp/reduxzero_web/movtoy4m"
		do shell script "/bin/cp " & thequotedapppath & "/Contents/Resources/play_title /tmp/rztemp/reduxzero_web/play_title"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8264|g' > /tmp/rztemp/reduxzero_httpd1.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8265|g' > /tmp/rztemp/reduxzero_httpd2.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8266|g' > /tmp/rztemp/reduxzero_httpd3.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8267|g' > /tmp/rztemp/reduxzero_httpd4.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8268|g' > /tmp/rztemp/reduxzero_httpd5.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8269|g' > /tmp/rztemp/reduxzero_httpd6.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8270|g' > /tmp/rztemp/reduxzero_httpd7.conf"
		do shell script "/bin/cat " & thequotedapppath & "/Contents/Resources/rzweb.conf | /usr/bin/sed -e 's|xxxx|8271|g' > /tmp/rztemp/reduxzero_httpd8.conf"
		do shell script "/usr/bin/ulimit -u 256 ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd1.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd2.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd3.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd4.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd5.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd6.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd7.conf ; /usr/sbin/httpd -f /tmp/rztemp/reduxzero_httpd8.conf"
	end if
	
end dasstarten

on bunchavars()
	set qtresult to true
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	set dashr to " -r "
	set vn to ""
	set colorspace to " "
	set dvdaudiotrack to " "
	set dvdvideotrack to " "
	set qmin to ""
	set thefolder to "untitled" as text
	set preview to false
	set normalnuller to " 1> /dev/null "
	set advanced to window "advanced"
	--Leave these variables empty for non-QuickTimeable files.
	set forcepipe to ""
	set extaudiofile to ""
	set audrand to " null "
	set istivo to false
	set ishack to false
	set isvideots to false
	set extaudio to ""
	set pipe to ""
	set xgridscript to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/xgrid.scpt"))
	set xpipe to ""
	set movfps to ""
	set percent to 0
	set ismov to ""
	set qtpipe to "-"
	set qtproc to false
	set isvlc092 to false
	set ar to ""
	set previewstring to " "
	set previewpic to " "
	set isappletv2 to false
	set rawdvdaudiotrack to ""
end bunchavars

on wrapup()
	--Clean up!
	--if there isn't an external audio file, don't tell me.
	if qtproc is true and xgrid is false then
		try
			do shell script "rm " & extaudiofile
		end try
	end if
	set whichone to whichone + 1
	if whichone > howmany then
		set the content of text field "timeremaining" of window "ReduxZero" to ""
		set the content of text field "howmany" of window "ReduxZero" to ""
	else
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "starting") & whichone & "..."
	end if
	delay 0.1
end wrapup

--  Created by Tyler Loch on 11/8/05.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.





