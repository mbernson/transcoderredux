-- xgrid.applescript
-- ReduxZero

global decimal
global howmany
global whichone
global errors
global thePath
global theFilepath
global thefixedfilepath
global thenewquotedfilepath
global thequotedorigpath
global theFile
global backslash
global theFile2
global destpath
global theRow
global theList
global isrunning
global outputfile
global dashr
global vn
global vcodec
global fullstarttime
global normalnuller
global mpegaspect
global origheight
global origwidth
global extaudio
global extaudiofile
global movfps2
global movfps
global movwidth
global morzeight
global threadscmd
global pipe
global forcepipe
global qtproc
global ismov
global ar
global ipodbox
global advanced
global croptop
global cropbottom
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
global xpipe
global ffvideos
global ffaudios
global homedir
global xgridffmpegstring
global thePath
global filenoext
global thequotedfile
global theorigpath
global mp4box
global avibox
global wmvbox
global flashbox
global proctype
global newext
global moreend
global destpath2
global fileext
global stitchstack
global stitch
global pspbox
global mpegbox
global thetarget
global dvdbox
global twopass
global colorspace
global audrand
global dvdwide
global qmin
global thumbfile
global isvideots
global quotedorigfile

on xgridgo()
	if whichone is 10 or whichone is 15 or whichone is 20 or whichone is 25 or whichone is 30 or whichone is 40 then
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "takeabreak")
		update window "ReduxZero"
		do shell script "/bin/sleep 10"
	end if
	if audrand is " null " then
		set audrand to "null"
	end if
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "submitting") & whichone & (localized string "togrid")
	update window "ReduxZero"
	set bonjourname to (IPv4 address of (system info))
	if bonjourname is "10.37.129.1" or bonjourname is "10.37.129.2" or "missing" is in (bonjourname as string) then
		--	set bonjourname to ((do shell script "defaults read /Library/Preferences/SystemConfiguration/preferences System | grep LocalHostName | awk -F ';' '{print $1}' | rev | awk '{print $1}' | rev | sed -e 's/\"//g'") & ".local")
		set bonjourname to (do shell script "/sbin/ifconfig | /usr/bin/grep 'inet ' | /usr/bin/grep -v 127.0.0.1 | /usr/bin/grep -v 10.37.129.2 | /usr/bin/grep -v ' 169.' | /usr/bin/awk '{print $2}'  | /usr/bin/head -1")
	end if
	if contents of default entry "xgridcontroller" of user defaults as string is "" then
		set controllername to "localhost"
	else
		set controllername to contents of default entry "xgridcontroller" of user defaults as string
	end if
	set usershare to (do shell script "/usr/bin/whoami")
	--	if (do shell script "ps -auxww | grep AppleFileServer | grep -v grep | wc -l") as number is 1 then
	--		do shell script "/bin/cp " & (quoted form of POSIX path of theorigpath) & " " & homedir & "/Public/rzshare/" & thequotedfile
	--		do shell script "/bin/cp " & extaudiofile & " " & homedir & "/Public/rzshare/" & thequotedfile & ".wav ; exit 0"
	--		set afpstring1 to "dir=rzshare/rzshare ; loc=rzshare/rzshare ; /sbin/mount_afp -o nobrowse afp://" & bonjourname & "/" & usershare & " rzshare ; if [ " & backslash  & "" & backslash  & "" & backslash  & "" & backslash  & "$? -gt 0 ] ; then"
	--		set afpstring2 to "fi ; "
	--	else
	try
		do shell script "/bin/ln -s " & quotedorigfile & " /tmp/rztemp/reduxzero_web/" & thequotedfile
	end try
	try
		if extaudiofile is not "" then
			do shell script "/bin/ln -s " & extaudiofile & " /tmp/rztemp/reduxzero_web/" & audrand & ".wav ; exit 0"
		end if
	end try
	--	end if
	do shell script "/bin/chmod 777 /tmp/rztemp/reduxzero_web"
	set starttime to do shell script "date +%s | cut -c 5-"
	do shell script "echo notdone > /tmp/rztemp/reduxzero_working"
	set visible of button "cancel" of window "ReduxZero" to true
	--	delay 0.1
	
	--     do shell script "/usr/bin/xgrid -h " & bonjourname & " -job run /bin/sh -c " & backslash  & ""if [ " & backslash  & "" & backslash  & "`hostname" & backslash  & "" & backslash  & "` = " & bonjourname & " ] ; then dir=" & homedir & "/Public/rzshare ; else dir=rzshare/rzshare ; mkdir rzshare ; /sbin/mount_afp -o nobrowse afp://" & bonjourname & "/" & usershare & " rzshare 2> /dev/null > /dev/null ; if [ " & backslash  & "" & backslash  & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8264 rzshare ; dir=rzshare ; fi ; fi ; cp " & backslash  & "" & backslash  & "$dir/ffmpeg . ; cp " & backslash  & "" & backslash  & "$dir/movtoy4m . ; " & xgridffmpegstring & " ; echo " & backslash  & "" & backslash  & "$? ; /sbin/umount rzshare 2> /dev/null > /dev/null" & backslash  & "" &> /tmp/rztemp/" & theFile2 & ".status  &"
	
	--	do shell script "/usr/bin/xgrid -h " & bonjourname & " -job run /bin/sh -c " & backslash  & ""if [ " & backslash  & "" & backslash  & "`hostname" & backslash  & "" & backslash  & "` = " & bonjourname & " ] ; then dir=" & homedir & "/Public/rzshare ; loc=" & homedir & "/Public/rzshare ; else mkdir rzshare ; /sbin/mount_webdav -S http://" & bonjourname & ":8264 rzshare ; dir=rzshare ;  loc='./' ; cp " & backslash  & "" & backslash  & "$dir/ffmpeg . ; cp " & backslash  & "" & backslash  & "$dir/movtoy4m . ; cp " & backslash  & "" & backslash  & "$dir" & thequotedfile & " . ; cp " & backslash  & "" & backslash  & "$dir" & thequotedfile & ".wav . ; fi ; " & xgridffmpegstring & " ; echo rzdone$? ; rm ./ffmpeg ./movtoy4m ./" & thequotedfile & " ./" & thequotedfile & ".wav ; /sbin/umount rzshare " & backslash  & "" &> /tmp/rztemp/" & thequotedfile & ".status  &"
	
	--do shell script "/usr/bin/xgrid -h " & bonjourname & " -job run /bin/sh -c " & backslash  & ""mkdir rzshare ; " & afpstring1 & " /sbin/mount_webdav -S http://" & bonjourname & ":8264 rzshare ; dir=rzshare ;  loc='./' ; cp " & backslash  & "" & backslash  & "$dir/ffmpeg . ; cp " & backslash  & "" & backslash  & "$dir/movtoy4m . ; cp " & backslash  & "" & backslash  & "$dir" & thequotedfile & " . ; cp " & backslash  & "" & backslash  & "$dir" & thequotedfile & ".wav . ; " & afpstring2 & " " & xgridffmpegstring & " ; echo rzdone$? ; rm ./ffmpeg ./movtoy4m ./" & thequotedfile & " ./" & thequotedfile & ".wav ; /sbin/umount rzshare " & backslash  & "" &> /tmp/rztemp/" & thequotedfile & ".status  &"
	
	do shell script "/bin/echo " & controllername & " -job run /bin/sh -c \"/bin/mkdir rzshare ; /sbin/mount_webdav -S http://" & bonjourname & ":8264 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8265 rzshare ;  if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8266 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8267 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8268 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8269 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8270 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8271 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /bin/echo rzdone7 ; exit 1 ; fi ; fi ; fi ; fi ;fi ; fi ; fi ; fi ; dir=rzshare ;  loc='./' ; /bin/cp " & backslash & "$dir/ffmpeg . ; /bin/cp " & backslash & "$dir/movtoy4m . ; /bin/cp " & backslash & "$dir/play_title . ; /bin/cp " & backslash & "$dir/" & thequotedfile & " . ; /bin/cp " & backslash & "$dir/" & audrand & ".wav . ; " & xgridffmpegstring & " ; /bin/echo rzdone$? ; /bin/rm ./ffmpeg ./movtoy4m ./play_title ./" & thequotedfile & " ./" & audrand & ".wav ; /sbin/umount rzshare \" >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	do shell script "/usr/bin/xgrid -h " & controllername & " -job run /bin/sh -c \"/bin/mkdir rzshare ; /sbin/mount_webdav -S http://" & bonjourname & ":8264 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8265 rzshare ;  if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8266 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8267 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8268 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8269 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8270 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /sbin/mount_webdav -S http://" & bonjourname & ":8271 rzshare ; if [ " & backslash & "$? -gt 0 ] ; then /bin/echo rzdone7 ; exit 1 ; fi ; fi ; fi ; fi ; fi ; fi ; fi ; fi ; dir=rzshare ;  loc='./' ; /bin/cp " & backslash & "$dir/ffmpeg . ; /bin/cp " & backslash & "$dir/movtoy4m . ; /bin/cp " & backslash & "$dir/play_title . ; /bin/cp " & backslash & "$dir/" & thequotedfile & " . ; /bin/cp " & backslash & "$dir/" & audrand & ".wav . ; " & xgridffmpegstring & " ; /bin/echo rzdone$? ; /bin/rm ./ffmpeg ./movtoy4m ./play_title ./" & thequotedfile & " ./" & audrand & ".wav ; /sbin/umount rzshare \" &> /dev/stdout | /usr/bin/grep -v NSCF > /tmp/rztemp/" & thequotedfile & ".status  2> /dev/null &"
	
	--do shell script "/bin/sleep 3"
end xgridgo

on xgridbarloop()
	set minimum value of progress indicator "bar" of window "ReduxZero" to 0
	set maximum value of progress indicator "bar" of window "ReduxZero" to howmany
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "xgridwaiting")
	set indeterminate of progress indicator "bar" of window "ReduxZero" to true
	waiter(3) of snippets
	set xgriddones to 0
	repeat until xgriddones is howmany
		set xgridwhichone to 0
		set xgriddones to 0
		repeat with theRow in every data row of data column "Files" of theList
			canceller() of snippets
			set xgridwhichone to (xgridwhichone + 1)
			pathings(theRow) of snippets
			set thestatusfile to quoted form of POSIX path of ("/tmp/rztemp/" & theFile & ".status")
			--display alert "/bin/echo status`/bin/cat " & thestatusfile & " | /usr/bin/grep rzdone`"
			set donetype to (do shell script ("/bin/echo status`/bin/cat " & thestatusfile & " | /usr/bin/grep rzdone`"))
			if donetype is "status" then
				delay 0.1
			end if
			if donetype is "statusrzdone0" then
				set xgriddones to (xgriddones + 1)
				--	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "file") & xgridwhichone & (localized string "xgridfilecomplete")
				try
					do shell script "rm " & extaudiofile
				end try
			end if
			if donetype is not "statusrzdone0" and donetype is not "status" then
				if donetype is "statusrzdone7" then
					set the content of text field "timeremaining" of window "ReduxZero" to (localized string "xgridresubmitnoconnection") & xgridwhichone & "..."
				else
					set the content of text field "timeremaining" of window "ReduxZero" to (localized string "xgridresubmit") & xgridwhichone & "..."
				end if
				set mainscript to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/main.scpt"))
				bunchavars() of mainscript
				thedur() of snippets
				theorigs() of snippets
				quicktimedetects() of snippets
				advanceds() of snippets
				mainstart() of proctype
				set xgridscript to load script file (POSIX file (thePath & "/Contents/Resources/Scripts/xgrid.scpt"))
				xgridgo() of xgridscript
			end if
			
			--if donetype is not "status" and donetype is not "statusrzdone0" then --"statusrzdone127"
			--end if
			do shell script "/bin/sleep 0.5"
		end repeat
		if xgriddones > 0 then
			set indeterminate of progress indicator "bar" of window "ReduxZero" to false
		end if
		set the content of progress indicator "bar" of window "ReduxZero" to (xgriddones)
		set the content of text field "howmany" of window "ReduxZero" to (localized string "file") & xgriddones & (localized string "out of") & howmany
		delay 0.1
	end repeat
	repeat with theRow in every data row of data column "Files" of theList
		pathings(theRow) of snippets
		set thestatusfile to quoted form of POSIX path of ("/tmp/rztemp/" & theFile & ".status")
		try
			do shell script "/bin/cat " & thestatusfile & " >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		end try
	end repeat
end xgridbarloop

on xgridend()
	set xgridwhichone to 1
	set whichone to 2
	set filestack to {}
	repeat with theRow in every data row of data column "Files" of theList
		set moreend to ""
		pathings(theRow) of snippets
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & (xgridwhichone) & "..."
		set destpath to ("/tmp/rztemp/reduxzero_web/")
		set outputfile to (destpath & thequotedfile & ".temp" & fileext)
		mainend() of proctype
		set xgridwhichone to (xgridwhichone + 1)
		if xgridwhichone > howmany then
			set xgridwhichone to howmany
		end if
		set filestack to (filestack & (newext & moreend))
	end repeat
	if stitch is true then
		stitcher() of (load script file (POSIX file (thePath & "/Contents/Resources/Scripts/main.scpt")))
	else
		repeat with donefile in every item of filestack
			try
				do shell script "/bin/mv " & donefile & " " & (destpath2 & "/")
			on error
				display alert (localized string "xgridfileerror1") message ((localized string "xgridfileerror2") & donefile) as critical default button (localized string "Continue")
			end try
			try
				do shell script "/bin/mv " & thumbfile & " " & (destpath2 & "/")
			end try
		end repeat
	end if
end xgridend

--  Created by Tyler Loch on 4/23/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
