-- snippets.applescript
-- ReduxZero

global decimal
global howmany
global whichone
global errors
global thequotedapppath
global theFilepath
global thefixedfilepath
global thenewquotedfilepath
global thequotedorigpath
global theFile
global destpath
global qtresult
global theRow
global sysver
global backslash
global theList
global isrunning
global workflow
global outputfile
global qtpipe
global fullstarttime
global dvdaudiotrack
global threadscmd
global audrand
global dashr
global vn
global vcodec
global normalnuller
global mpegaspect
global origheight
global origmovwidth
global origmorzeight
global origwidth
global extaudio
global extaudiofile
global movfps2
global movfps
global movwidth
global morzeight
global dvdvideotrack
global pipe
global forcepipe
global qtproc
global ismov
global thefolder
global ar
global ipodbox
global advanced
global croptop
global cropbottom
global ratio
global cropleft
global cropright
global topcrop
global bottomcrop
global leftcrop
global rightcrop
global optim
global isdone
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
global xgrid
global origAR
global origPAR
global thePath
global thequotedorigpath
global filenoext
global parts
global thequotedfile
global ext
global theorigpath
global fileext
global vol
global serverfile
global serverinput
global mp4box
global avibox
global wmvbox
global flashbox
global moreend
global newext
global destpath2
global pspbox
global mpegbox
global dvdbox
global twopass
global pass1ffmpegstring
global colorspace
global quotedorigfile
global preview
global theaspect
global stitchstack
global stitch
global qmin
global ffmpegloc
global dvdwide
global ver
global dvdtitlenumber
global highestdur
global isvideots
global filesize
global imagesize
global fullstarttime
global rawdvdaudiotrack
global bitnum

global isvlc092

on pathings(theRow)
	--Get the file's path, as well as important tidbits, like the filename itself.
	set theFilepath to contents of data cell 1 of theRow as Unicode text
	
	--	if (do shell script "" & thefilepath & " | rev | cut -c 1-5" is
	set theorigpath to contents of data cell 1 of theRow as POSIX file
	--set quotedorigfile to quoted form of POSIX path of theorigpath
	set quotedorigfile to quoted form of theFilepath
	--	display dialog "1"
	--	try
	set text item delimiters to "/" as Unicode text
	set theFile to last text item of theFilepath as Unicode text
	set text item delimiters to theFile
	--	set theFilepath to (first text item of theFilepath) as Unicode text
	set theFilepath to ((call method "stringByDeletingLastPathComponent" of theFilepath) & "/") as Unicode text
	
	--		tell application "Finder" to set theFilepath to get (container of file theorigpath) as Unicode text
	--		display dialog theFilepath
	--		tell application "Finder" to set theFile to get (name of file theorigpath) as Unicode text
	--		display dialog theFile
	--	on error
	--		tell application "Finder" to set theFilepath to get (container of folder theorigpath) as Unicode text
	--		tell application "Finder" to set theFile to get (name of folder theorigpath) as Unicode text
	--	end try
	(*	try
		tell application "Finder" to set theFilepath to get (container of file theorigpath) as Unicode text
		--		display dialog theFilepath
		tell application "Finder" to set theFile to get (name of file theorigpath) as Unicode text
		--		display dialog theFile
	on error
		tell application "Finder" to set theFilepath to get (container of folder theorigpath) as Unicode text
		tell application "Finder" to set theFile to get (name of folder theorigpath) as Unicode text
	end try *)
	--	display dialog "2"
	set thequotedpath to (quoted form of theFilepath)
	--	display dialog thequotedpath
	set thequotedfile to (quoted form of theFile)
	--	display dialog thequotedfile
	
	set writeable to true
	
	if xgrid is false then
		try
			do shell script "touch " & quotedorigfile & "rztest"
			do shell script "rm " & quotedorigfile & "rztest"
		on error
			set writeable to false
		end try
	end if
	
	if theFilepath is "/Volumes/" then
		--		set thequotedfile to (quoted form of (do shell script "echo " & thequotedfile & " | sed -e 's/" & backslash & "/Volumes//g'"))
		if contents of text field "path" of window "ReduxZero" is "" then
			set contents of text field "path" of window "ReduxZero" to (do shell script "cd ~/Desktop ; pwd")
			update window "ReduxZero"
		end if
	end if
	if writeable is false then
		if contents of text field "path" of window "ReduxZero" is "" then
			set contents of text field "path" of window "ReduxZero" to (do shell script "cd ~/Desktop ; pwd")
			update window "ReduxZero"
		end if
	end if
	
	set outputspot to contents of text field "path" of window "ReduxZero"
	if outputspot is not "" then
		try
			do shell script "touch " & quoted form of outputspot & "/.rztest"
			do shell script "rm " & quoted form of outputspot & "/.rztest"
		on error
			set contents of text field "path" of window "ReduxZero" to (do shell script "cd ~/Desktop ; pwd")
		end try
	end if
	--	display dialog "heregrrrr3"
	
	--	display dialog thequotedfile
	
	set thequotedorigpath to thequotedpath & thequotedfile
	--	display dialog thequotedorigpath
	set text item delimiters to "."
	set ext to last text item of theFile
	if ext is (first text item of theFile) then
		set ext to ""
		set extsize to -1
	else
		set extsize to (-(number of characters of ext) - 2)
	end if
	
	(*	try
		tell application "Finder" to set ext to get name extension of file theorigpath
	on error
		try
			tell application "Finder" to set ext to get name extension of folder theorigpath
		on error
			set ext to ""
		end try
	end try
	*)
	
	if ext is "eyetv" then
		set thequotedorigpath to (quoted form of (theFilepath & theFile)) & "/*.mpg"
		set ext to "mpg"
	end if
	if ext is "iMovieProject" then
		set thequotedorigpath to (quoted form of (theFilepath & theFile)) & "/'Shared Movies/iDVD'/*.mov"
	end if
	
	set ver to 135
	set text item delimiters to ""
	set filenoext to text 1 thru extsize of (theFile)
	--	display dialog "heregrrrr"
	--If no default save location is specified, just put it in the original file" & backslash  & ""s location.
	if contents of text field "path" of window "ReduxZero" is "" then
		set destpath to ((quoted form of theFilepath) & "/")
		set destpath2 to destpath
	else
		set destpath to ((quoted form of (contents of text field "path" of window "ReduxZero" as Unicode text)) & "/")
		set destpath2 to destpath
	end if
	--	display dialog destpath
	--	display dialog "thenwhat"
	--Assemble some nice looking text strings.
	
	
	
	--	set thefixedfilepath to replace_chars(theFilepath, "'", "")
	--	display dialog theFilepath
	--	set thenewquotedfilepath to (POSIX file theFilepath)
	--	set thequotedorigpath to (quoted form of POSIX path of thenewquotedfilepath)
	--	set theFile to do shell script "/bin/echo " & thequotedorigpath & " | /usr/bin/rev | /usr/bin/awk -F / '{print $1}' | /usr/bin/rev"
	
	--	set theFile to replace_chars(theFile, "'", "")
	--	set theFile to theFile
	--	--If no default save location is specified, just put it in the original file" & backslash  & ""s location.
	--	if contents of text field "path" of window "ReduxZero" = "" then
	--		set destpath to ""
	--		set theFile to thefixedfilepath
	--	else
	--		set destpath to (contents of text field "path" of window "ReduxZero" as text)
	--	end if
end pathings

on proccrop()
	if (contents of text field "croptop" of advanced) is "Auto" then
		autocrop()
	else
		--Set crops. Default is 0 for all.
		set topcrop to (contents of text field "croptop" of advanced)
		if topcrop as string is "0" then
			set croptop to " "
		else
			set croptop to " -croptop " & topcrop
		end if
		set bottomcrop to (contents of text field "cropbottom" of advanced)
		if bottomcrop as string is "0" then
			set cropbottom to " "
		else
			set cropbottom to " -cropbottom " & bottomcrop
		end if
		set leftcrop to (contents of text field "cropleft" of advanced)
		if leftcrop as string is "0" then
			set cropleft to " "
		else
			set cropleft to " -cropleft " & leftcrop
		end if
		set rightcrop to (contents of text field "cropright" of advanced)
		if rightcrop as string is "0" then
			set cropright to " "
		else
			set cropright to " -cropright " & rightcrop
		end if
	end if
	do shell script "echo '" & topcrop & "
" & bottomcrop & "
" & leftcrop & "
" & rightcrop & "' > /tmp/rztemp/" & fullstarttime & "/reduxzero_cropmarks"
end proccrop

on deinterlacer()
	--Deinterlace. Off by default, on only through Advanced drawer.
	set deinterlace to ""
	if content of button "deinterlace" of advanced is true then
		set deinterlace to " -deinterlace "
	end if
end deinterlacer

on getmult(orignum, mult)
	return ((round (orignum / mult)) * mult)
end getmult

on getupmult(orignum, mult)
	return ((round (orignum / mult) rounding up) * mult)
end getupmult

on audiogo()
	if (contents of popup button "audiokhz" of advanced) is 0 then
		set arwork to ""
		if stitch is true and whichone is 1 then
			set contents of popup button "audiokhz" of advanced to 1
			set arwork to (title of current menu item of popup button "audiokhz" of advanced as string)
		end if
	else
		set arwork to (title of current menu item of popup button "audiokhz" of advanced as string)
	end if
	
	if contents of text field "audbitrate" of advanced is "" then
		set abwork to ""
		if stitch is true and whichone is 1 then
			set contents of text field "audbitrate" of advanced to 128
			set abwork to "128"
		end if
	else
		set abwork to (contents of text field "audbitrate" of advanced)
	end if
	
	set acwhat to (get contents of popup button "audiochannels" of advanced)
	if acwhat is 0 then
		set acwork to ""
		if stitch is true and whichone is 1 then
			set contents of popup button "audiochannels" of advanced to 1
			set acwork to "2"
		end if
	else
		if acwhat is 1 then
			set acwork to "2"
		end if
		if acwhat is 2 then
			set acwork to "1"
		end if
	end if
	if arwork is "" then
		set origaudAR to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ,Audio, | head -1 | awk -F , '{print $8}'")
		if origaudAR is "" or origaudAR is "mpeg4aac)" then
			set origaudAR to 44100
		end if
		set audhz to origaudAR & " process"
	else
		set audhz to arwork & " force"
	end if
	if acwork is "" then
		set origaudac to first text item of (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ,Audio, | head -1 | awk -F , '{print $9}'")
		if origaudac is "" then
			set origaudac to 2
		end if
		set audchan to origaudac & " process"
	else
		set audchan to acwork & " force"
	end if
	if abwork is "" then
		set audbit to "calc" & " process"
	else
		set audbit to abwork & " force"
	end if
	if preview is true then
		set audstring to " "
	else
		set audstring to ((do shell script "" & thequotedapppath & "/Contents/Resources/audbasher " & type & " " & audhz & " " & audchan & " " & audbit) & "k")
	end if
end audiogo

on advanceds()
	if preview is false then
		set ffaudios to ((contents of combo box "audioffmpeg" of advanced as string) & dvdaudiotrack)
		set ffvideos to ((contents of combo box "videoffmpeg" of advanced as string) & dvdvideotrack)
	else
		set ffvideos to dvdvideotrack
		set ffaudios to " "
	end if
	set vol to ""
	if content of slider "volume" of advanced is not 256 then
		set vol to " -vol " & (round (content of slider "volume" of advanced as number))
	end if
	if content of slider "volume" of advanced is 0 then
		set vol to " -an "
	end if
	set twopass to contents of button "twopass" of advanced
	if contents of text field "qmin" of advanced is not "" then
		set qmin to (" -qmin " & contents of text field "qmin" of advanced)
	end if
end advanceds

on theorigs()
	if isvideots is false then
		set origwidth to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur |  grep ',Video,' | head -1 | awk -F , '{print $9}'")
		set origheight to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Video,' | head -1 | awk -F , '{print $10}'")
		--		set origwidth to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | /usr/bin/rev | /usr/bin/awk -F ,p '{print $1}' | /usr/bin/rev | /usr/bin/awk '{print $1}' | /usr/bin/sed -e 's/,//g' | /usr/bin/awk -F x '{print $1}'")
		--		set origheight to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | /usr/bin/rev | /usr/bin/awk -F ,p '{print $1}' | /usr/bin/rev | /usr/bin/awk '{print $1}' | /usr/bin/sed -e 's/,//g' | /usr/bin/awk -F x '{print $2}'")
		--	set origAR to "0"
		set mpegaspect to ""
		--	display dialog (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $7}'")
		if (ext is "vob" or ext is "mpg" or ext is "mpeg" or ext is "vro" or ext is "m2t" or ext is "ts" or ext is "mpa" or ext is "m2v") and ((do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $7}'") is not "h264") and origwidth is not "1920" then
			try
				do shell script "/bin/cp -n " & thequotedapppath & "/Contents/Resources/dvb-mpegtools /tmp/rztemp/dvb-mpegtools ; exit 0"
				if decimal is not "comma" then
					set mpegaspect to (do shell script "/tmp/rztemp/dvb-mpegtools streamtype " & thequotedorigpath & " 2>/dev/stdout | grep ASPECT | awk '{print $2}' | sed -e 's/:/ " & backslash & "/ /g' | bc -l | cut -c 1-7 ") as number
					--	on error
				else
					set mpegaspect to (do shell script "/tmp/rztemp/dvb-mpegtools streamtype " & thequotedorigpath & " 2>/dev/stdout | grep ASPECT | awk '{print $2}' | sed -e 's/:/ " & backslash & "/ /g' | bc -l | cut -c 1-7 | sed -e 's/" & backslash & "./,/g'") as number
				end if
			end try
			if (origwidth & "x" & origheight) is "480x480" then
				set mpegaspect to 1.33333
			end if
			if (origwidth & "x" & origheight) is "544x480" then
				set mpegaspect to 1.33333
			end if
			if (origwidth & "x" & origheight) is "352x480" then
				set mpegaspect to 1.33333
			end if
			if (origwidth & "x" & origheight) is "352x240" then
				set mpegaspect to 1.33333
			end if
			if (origwidth & "x" & origheight) is "480x576" then
				set mpegaspect to 1.33333
			end if
			if (origwidth & "x" & origheight) is "1920x1080" then
				set mpegaspect to 1
			end if
			if (origwidth & "x" & origheight) is "1280x720" then
				set mpegaspect to 1
			end if
			if mpegaspect is 1 or mpegaspect is 0 or mpegaspect is "" then
				try
					set origPAR to (origwidth / origheight)
				on error
					set origPAR to 1.33333
				end try
			else
				set origPAR to mpegaspect
			end if
		else
			set origPAR to 1.33333
			try
				set origPAR to (origwidth / origheight)
			end try
			if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is true then
				if (origwidth & "x" & origheight) is "1440x1080" then
					set origPAR to 1.77777
				end if
				if (origwidth & "x" & origheight) is "1280x1080" then
					set origPAR to 1.77777
				end if
				if (origwidth & "x" & origheight) is "960x720" then
					set origPAR to 1.77777
				end if
			end if
		end if
	end if
	if type is "dvdbox" then
		if origPAR > 1.5 then
			set theaspect to (theaspect + 1)
			if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is false then
				set dvdwide to true
			end if
		else
			set theaspect to (theaspect - 1)
			if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is false then
				set dvdwide to false
			end if
		end if
	end if
	
end theorigs

on autocrop()
	set prevsec to (contents of text field "prevsec" of window "Preview")
	try
		do shell script "" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & " -an -ss " & prevsec & " -vframes 1 -vcodec ppm -f rawvideo - 2> /dev/null | " & thequotedapppath & "/Contents/Resources/ppmtoy4m 2> /dev/null | " & thequotedapppath & "/Contents/Resources/yuvcorrect -Y LUMINANCE_1.0_32_255_0_255 -R R_1.0_32_255_0_255 -R G_1.0_32_255_0_255 -R B_1.0_32_255_0_255 2> /dev/null | " & thequotedapppath & "/Contents/Resources/y4mtoppm 2> /dev/null | " & thequotedapppath & "/Contents/Resources/pnmcrop -sides -v > /dev/null 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_crop; exit 0"
	end try
	--tell application "Terminal" to do script "" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & " -an -ss " & prevsec & " -vframes 1 -vcodec ppm -f rawvideo - 2> /dev/null | " & thequotedapppath & "/Contents/Resources/ppmtoy4m 2> /dev/null | " & thequotedapppath & "/Contents/Resources/yuvcorrect -Y LUMINANCE_1.0_32_255_0_255 -R R_1.0_32_255_0_255 -R G_1.0_32_255_0_255 -R B_1.0_32_255_0_255 2> /dev/null | " & thequotedapppath & "/Contents/Resources/y4mtoppm 2> /dev/null | " & thequotedapppath & "/Contents/Resources/pnmcrop -sides -v > /dev/null 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_crop"
	try
		set leftcropbefore to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_crop | tail -4 | head -1 | awk '{print $3}'")
		set rightcropbefore to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_crop | tail -3 | head -1 | awk '{print $3}'")
		set topcropbefore to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_crop | tail -2 | head -1 | awk '{print $3}'")
		set bottomcropbefore to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_crop | tail -1 | awk '{print $3}'")
	end try
	try
		set leftcrop to (getupmult((leftcropbefore as number), 2) + 2)
	on error
		set leftcrop to "0"
	end try
	try
		set rightcrop to (getupmult((rightcropbefore as number), 2) + 2)
	on error
		set rightcrop to "0"
	end try
	try
		set topcrop to (getupmult((topcropbefore as number), 2) + 2)
	on error
		set topcrop to "0"
	end try
	try
		set bottomcrop to (getupmult((bottomcropbefore as number), 2) + 2)
	on error
		set bottomcrop to "0"
	end try
	if (contents of text field "croptop" of advanced) is "Auto" then
		set croptop to " -croptop " & topcrop
		set cropbottom to " -cropbottom " & bottomcrop
		set cropleft to " -cropleft " & leftcrop
		set cropright to " -cropright " & rightcrop
	else
		set contents of text field "croptop" of advanced to topcrop
		set contents of text field "cropbottom" of advanced to bottomcrop
		set contents of text field "cropleft" of advanced to leftcrop
		set contents of text field "cropright" of advanced to rightcrop
	end if
end autocrop

on dvdtitlefinder()
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "maintitle")
	
	(*	set numtitles to (do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " 2> /dev/stdout | grep 'DVD title' | awk -F / '{print $2}' | awk -F : '{print $1}'")
	--	display dialog numtitles
	set current to 1
	set highestdur to 1
	repeat (numtitles) times
		set titlecombat to (do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " -T " & current & " 2> /dev/stdout | grep playback | rev | awk '{print $2}' | rev")
		--		display dialog titlecombat
		if (titlecombat as number) > highestdur then
			set dvdtitlenumber to current
			set highestdur to titlecombat
			--			display dialog "highest is " & current
		end if
		set current to (current + 1)
	end repeat
	set current to (current - 1) *)
	set dvdtitlenumber to (do shell script thequotedapppath & "/Contents/Resources/lsdvd " & thequotedorigpath & " 2> /dev/null | grep Longest | cut -c 16-") as number
	--	do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " -T " & dvdtitlenumber & " 2> /dev/stdout | grep mpeg2 | awk '{print $4}' | sed -e 's/:/ " & backslash & "/ /g' | bc -l  | cut -c 1-7"
	do shell script thequotedapppath & "/Contents/Resources/lsdvd -x -t " & dvdtitlenumber & " " & thequotedorigpath & " 2> /dev/null > /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo ; exit 0"
	if "16/9" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio") then
		set mpegaspect to 1.77777
	else
		set mpegaspect to 1.33333
	end if
	--	try
	--		set thenum to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio | awk -F 'ratio: ' '{print $2}' | awk -F , '{print $1}' | bc -l | cut -c 1-7") as number
	--	on error
	--		set thenum to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio | awk -F 'ratio: ' '{print $2}' | awk -F , '{print $1}' | bc -l | cut -c 1-7 | sed -e 's/" & backslash & "./,/g'") as number
	--	end try
	--	--	display dialog thenum
	--	set mpegaspect to numtostr(thenum)
	--	set mpegaspect to (do shell script "echo " & numtostr((do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " -T " & current & " 2> /dev/stdout | grep mpeg2 | awk '{print $4}' | sed -e 's/:/ " & backslash  & "" & backslash  & "/ /g' | bc -l")) & " | cut -c 1-7")
	set origPAR to mpegaspect
	set origwidth to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio | awk -F 'Width: ' '{print $2}' | awk -F , '{print $1}'")
	set origheight to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio | awk -F 'Height: ' '{print $2}' | awk -F , '{print $1}'")
	if (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep ratio | awk -F 'FPS: ' '{print $2}' | awk -F , '{print $1}'") is "29.97" then
		set origheight to "480"
		if origPAR is 1.77777 then
			set dvdfps to 23.98
		else
			set dvdfps to 29.97
		end if
	else
		set dvdfps to 25
	end if
	--	set dvdfps to (do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " -T " & dvdtitlenumber & " 2> /dev/stdout | grep fps | rev | awk '{print $2}' | rev")
	set movfps to dvdfps
	do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dvdinfo | grep Subpictures | awk -F 'Length: ' '{print $2}' | awk '{print $1}' > /tmp/rztemp/" & fullstarttime & "/reduxzero_duration"
	--	do shell script "echo " & highestdur & " > /tmp/rztemp/" & fullstarttime & "/reduxzero_duration"
	--	display dialog dvdtitlenumber
	--	try
	--		do shell script "rm /tmp/rztemp/" & fullstarttime & "/reduxzero_dur"
	--	end try
	--	do shell script "touch /tmp/rztemp/" & fullstarttime & "/reduxzero_dur"
	
	do shell script "touch /tmp/rztemp/" & fullstarttime & "/reduxzero_dur"
	do shell script "" & thequotedapppath & "/Contents/Resources/play_title " & thequotedorigpath & " " & dvdtitlenumber & " 1 1 2> /dev/null | " & ffmpegloc & "ffmpeg -y -i - 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_dur > /dev/null &"
	repeat until (size of (info for POSIX file ("/tm" & "p/rztemp/" & fullstarttime & "/reduxzero_dur")) > 250)
		waiter(1)
	end repeat
	try
		do shell script "kill `ps -xww | grep play_title | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
	end try
	--	do shell script "" & thequotedapppath & "/Contents/Resources/play_title " & thequotedorigpath & " " & dvdtitlenumber & " 1 1 2> /dev/null | " & ffmpegloc & "ffmpeg -i - 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_dur ; exit 0"
	--	repeat until (do shell script "ls -ln /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | awk '{print $5}'") > 700
	--		delay 0.5
	--	end repeat
	--	try
	--		do shell script "killall play_title"
	--	end try
	--	delay 0.5
	set howmanyaudtracks to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep -c Audio ; exit 0")
	if howmanyaudtracks is not "1" and howmanyaudtracks is not "0" then
		if preview is false then
			set text item delimiters to return
			set dvdaudiotracknames to (do shell script "" & thequotedapppath & "/Contents/Resources/lsdvd -t " & dvdtitlenumber & " -a " & thequotedorigpath & " 2> /dev/stdout | grep Language | sort -n -t x -k 1 | awk '{print $6, $7, $8, $13, $14}' | rev | cut -c 2- | rev ; exit 0")
			set gotone to false
			if contents of default entry "dvdlanguage" of user defaults as string is not "" or workflow is "auto" then
				set langcounter to 1
				set wantedlang to contents of default entry "dvdlanguage" of user defaults as string
				repeat with thislang in (every text item of dvdaudiotracknames)
					--		display dialog wantedlang
					--		display dialog thislang
					if wantedlang is in thislang and gotone is false then
						set dvdaudnum to langcounter
						set gotone to true
					end if
					set langcounter to (langcounter + 1)
				end repeat
			end if
			
			set AppleScript's text item delimiters to return
			if gotone is false then
				load nib "dvdaudio"
				--		show window "dvdaudio"
				display panel window "dvdaudio" attached to window "ReduxZero"
				delete every menu item of menu of popup button "dvdaudio" of window "dvdaudio"
				repeat with bob in (every text item of dvdaudiotracknames)
					make new menu item at end of menu items of menu of popup button "dvdaudio" of window "dvdaudio" with properties {title:bob}
				end repeat
				do shell script "touch /tmp/reduxzero_dvdaudio"
				repeat until (do shell script "ls -ln /tmp/reduxzero_dvdaudio | awk '{print $5}'") > 0
					delay 0.5
				end repeat
				--	display dialog "0"
				set dvdaudnum to (do shell script "/bin/cat /tmp/reduxzero_dvdaudio")
				try
					do shell script "rm /tmp/reduxzero_dvdaudio"
				end try
			end if
			do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ,Audio, | awk -F , '{print $3}' | cut -c 4- | sort"
			set dvdhexnum to (text item dvdaudnum of the result)
			set text item delimiters to ""
			--	do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Audio | awk '{print $2}' | cut -c 2- | awk -F '[' '{print $1}'"
			set rawdvdaudiotrack to ((do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep dvd" & dvdhexnum & " | awk -F , '{print $1}'"))
			set dvdaudiotrack to " -map " & rawdvdaudiotrack & " "
		end if
		set dvdvideotrack to " -map " & ((do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep 'Video,mpeg' | head -1 | awk -F , '{print $1}'") & " ")
	end if
	--	display dialog dvdaudiotrack
	set ext to "vob"
	--	do shell script "echo " & mpegaspect & " " & origwidth & " " & origheight & " " & dvdfps
	--return {dvdtitlenumber, highestdur, origPAR, origwidth, origheight, dvdfps}
	return true
end dvdtitlefinder

on thedur()
	do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_dur ; cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time ; exit 0"
	
	if ((do shell script "tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Unknown | wc -l") as number) is 1 or ((do shell script "tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep corrupted | wc -l") as number) is 1 then --or ((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep mpeg2video | grep damaged | wc -l") as number) > 0
		return false
	else
		try
			if "AVSEQ" is in theFile then
				set forcepipe to " -f mpeg "
				do shell script "" & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & " 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_dur ; cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time ; exit 0"
			end if
		end try
		try
			if ext is "swf" and ",Video," is not in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur") then
				return false
			end if
		end try
		try
			if ext is "mpg" or ext is "mpeg" then
				if "mov,mp4,m4a" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur") then
					set forcepipe to " -f mpeg "
					do shell script "" & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & " 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_dur ; cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time ; exit 0"
				end if
			end if
		end try
		set mpeg to ""
		
		try
			if ext is "vob" and ((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep bitrate- | cut -c 9-") as number) > 9000 then
				if xgrid is false and preview is false then
					set mpeg to "mpeg"
					set (content of text field "timeremaining" of window "ReduxZero") to "File " & whichone & " " & (localized string "mpegcheck")
					update window "ReduxZero"
					do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " -vn -acodec copy -f mpeg2video - > /dev/null 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_mpegdur"
				end if
			end if
		end try
		
		try
			if (ext is "mpg" or ext is "mpeg" or ext is "dat" or ext is "ts" or ext is "m2t" or ext is "mpa") and (((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep bitrate- | cut -c 9-") as number) > 9000) and (("1080" is not in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur")) and ("720" is not in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur"))) then
				if xgrid is false and preview is false then
					set mpeg to "mpeg"
					set (content of text field "timeremaining" of window "ReduxZero") to "File " & whichone & " " & (localized string "mpegcheck")
					update window "ReduxZero"
					do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " -vn -acodec copy -f mpeg2video - > /dev/null 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_mpegdur"
				end if
			end if
		end try
		
		try
			--if (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep start | cut -c 7") is "0" then
			if (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Duration | cut -c 10-") is "NA" then
				if xgrid is false and preview is false then
					set mpeg to "mpeg"
					set (content of text field "timeremaining" of window "ReduxZero") to "File " & whichone & " " & (localized string "mpegcheck")
					update window "ReduxZero"
					do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " -vn -acodec copy -f avi - > /dev/null 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_mpegdur"
				end if
			end if
		end try
		
		try
			if "mov,mp4,m4a" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur") then
				do shell script thequotedapppath & "/Contents/Resources/movinfo " & thequotedorigpath & " > /tmp/rztemp/" & fullstarttime & "/reduxzero_movdur"
				set mpeg to "mov"
			end if
		end try
		try
			do shell script "" & thequotedapppath & "/Contents/Resources/durfinder " & fullstarttime & " " & mpeg
		end try
		return true
	end if
end thedur


on mainnormalgo()
	set nice to ""
	try
		if (contents of default entry "nice" of user defaults as string) is "true" then
			set nice to "/usr/bin/nice "
		end if
	end try
	if twopass is true then
		set indeterminate of progress indicator "bar" of window "ReduxZero" to true
		tell progress indicator "bar" of window "ReduxZero" to start
		set content of text field "timeremaining" of window "ReduxZero" to (localized string "pass1")
		update window "ReduxZero"
		do shell script "echo notdone > /tmp/rztemp/" & fullstarttime & "/reduxzero_working"
		do shell script "echo \"" & pass1ffmpegstring & "\" > /tmp/rztemp/" & fullstarttime & "/reduxzero_commandpass1.sh"
		do shell script "cd /tmp ; " & nice & "sh -c \"" & pass1ffmpegstring & "\" > /dev/null 2>&1 &"
		repeat until (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_working") is "done"
			set visible of button "cancel" of window "ReduxZero" to true
			update window "ReduxZero"
			canceller()
			waiter(3)
		end repeat
		set indeterminate of progress indicator "bar" of window "ReduxZero" to false
	end if
	--Get a truncated epoch dating for the filestart for progress barification.
	set starttime to do shell script "/bin/date +%s | /usr/bin/cut -c 5-"
	do shell script "echo notdone > /tmp/rztemp/" & fullstarttime & "/reduxzero_working"
	set visible of button "cancel" of window "ReduxZero" to true
	update window "ReduxZero"
	do shell script "echo \"" & ffmpegstring & "\" > /tmp/rztemp/" & fullstarttime & "/reduxzero_command.sh"
	do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_command.sh >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	--	do shell script "echo \"" & ffmpegstring & "\" >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	do shell script "cd /tmp ; " & nice & "sh -c \"" & ffmpegstring & "\" &> /dev/null &"
	set pid to (do shell script "/bin/sleep 1 && ps -xww | grep ffmpeg | grep -v grep | /usr/bin/tail -1 | /usr/bin/awk '{print $1}'" as string)
	set contents of text field "pid" of window "ReduxZero" to pid
	set enabled of menu item "pause" of menu "file" of main menu to true
	set enabled of menu item "resume" of menu "file" of main menu to false
	barloop()
end mainnormalgo

on theend()
	--put UI back to normal. If there were or weren't errors, say so.
	set indeterminate of progress indicator "bar" of window "ReduxZero" to false
	set the content of progress indicator "bar" of window "ReduxZero" to "0"
	set visible of button "cancel" of window "ReduxZero" to false
	
	try
		set theseconds to ((do shell script "/bin/date +%s") - fullstarttime)
		set theminutes to (round (theseconds / 60) rounding down)
		set theseconds to ((((theminutes) * 60) - theseconds) * -1) as integer
		set text item delimiters to ""
		if (count of text items of (theseconds as string)) is 1 then
			set theseconds to ("0" & (theseconds))
		end if
		set timeittook to (theminutes & ":" & theseconds as string)
		set elapsedtime to ("
" & (localized string "elapsedtime") & timeittook)
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo 'Time Elapsed: " & timeittook & "' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo '' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	on error
		set elapsedtime to ""
	end try
	set triallimit to ""
	try
		do shell script "/bin/cat " & quotedorigfile & " | head -2 | gzip | uuencode -m - >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	end try
	try
		do shell script "mkdir -p ~/Library/Logs/reduxzeroweb"
	end try
	try
		do shell script "cp /tmp/rztemp/" & fullstarttime & "/reduxzero_time ~/Library/Logs/reduxzeroweb/rz`date +%y%m%d-%H%M`-" & thequotedfile & ".txt"
	end try
	if errors < howmany then
		if errors = 0 then
			set playsound to "true"
			try
				set playsound to (contents of default entry "playsound" of user defaults as string)
			end try
			if playsound is not "false" then
				play (load sound "Glass")
			end if
			if content of button "whendone" of window "ReduxZero" is true then
				set content of text field "timeremaining" of window "ReduxZero" to ""
				if (get contents of popup button "whendonemenu" of window "ReduxZero") is 0 then
					quit saving no
				end if
				if (get contents of popup button "whendonemenu" of window "ReduxZero") is 1 then
					(do shell script "sh -c \"osascript -l AppleScript -e 'delay 3' -e 'tell application " & backslash & "\"System Events" & backslash & "\" to shut down'\"  > /dev/null 2>&1 &")
					quit saving no
				end if
				if (get contents of popup button "whendonemenu" of window "ReduxZero") is 2 then
					tell application "System Events" to sleep
				end if
				if (get contents of popup button "whendonemenu" of window "ReduxZero") is 3 then
					do shell script "open " & destpath
				end if
			else
				if workflow is not "auto" then
					set completeresult to button returned of (display alert ((localized string "complete") & elapsedtime & triallimit) as informational default button "OK" other button (localized string "ShowLog"))
					--	set completeresult to button returned of (display dialog (localized string "complete") buttons {(localized string "ShowLog"), "OK"} default button "OK")
					if completeresult is (localized string "ShowLog") then
						do shell script "open -e /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
						waiter(2)
					end if
				end if
			end if
		else
			if workflow is not "auto" then
				if button returned of (display alert (localized string "someerrors") as critical default button "OK" other button (localized string "ShowLog")) is (localized string "ShowLog") then
					do shell script "open -e /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
					waiter(2)
				end if
			end if
		end if
	end if
	if workflow is not "auto" then
		if errors = howmany then
			if button returned of (display alert (localized string "allerrors") as critical default button "OK" other button (localized string "ShowLog")) is (localized string "ShowLog") then
				do shell script "open -e /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
				waiter(2)
			end if
		end if
	end if
	--	if button returned is (localized string "showlog") then
	--		do shell script "open -t /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
	if xgrid is true then
		try
			do shell script "rm -rf /tmp/rztemp/reduxzero_web"
		end try
	end if
	try
		do shell script "rm -r /tmp/rztemp/" & fullstarttime
	end try
	
	
	--	end if
	set the content of text field "howmany" of window "ReduxZero" to ""
	set the content of text field "timeremaining" of window "ReduxZero" to ""
end theend

on barloop()
	set ok to do shell script "" & thequotedapppath & "/Contents/Resources/starterror " & fullstarttime
	
	if ok is equal to "broken" then
		--It's ovah, Roc!
		set indeterminate of progress indicator "bar" of window "ReduxZero" to false
		tell progress indicator "bar" of window "ReduxZero" to stop
		--tell progress indicator "spinner" of window "ReduxZero" to stop
		--set visible of progress indicator "spinner" of window "ReduxZero" to false
		update window "ReduxZero"
		set isrunning to "0"
		--Chalk one up for human/machine fallability.
		set errors to (errors + 1)
		
		--Delete temp files
		try
			if qtproc is true then
				do shell script "rm " & extaudiofile
			end if
		end try
		--Give a dialog in such a way that it does not stop the conversion process for others in the loop. A sheet works nicely.
		try
			if (do shell script "echo error`cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Stream | /usr/bin/grep RV | wc -l | cut -c 8`") = "error1" then
				display alert (localized string "noreal") attached to window "ReduxZero" default button (localized string "inadequacyok")
			else
				--	if (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | /usr/bin/grep Unsupported | /usr/bin/grep flv | wc -l | cut -c 8") > 0 then
				--		display alert (localized string "noflash8") attached to window "ReduxZero" default button (localized string "inadequacyok")
				--	else
				if ((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_time | /usr/bin/grep 2pass | wc -l") as number) is 1 then
					display alert (localized string "2passerror") attached to window "ReduxZero"
				else
					if "Resampling with input channels" is in (do shell script "tail -2 /tmp/rztemp/" & fullstarttime & "/reduxzero_time") then
						display alert (localized string "errorprevented") & theFile & (localized string "conversionfromstarting") & "

" & (localized string "5.1 AAC audio is not supported.") attached to window "ReduxZero" default button (localized string "inadequacyok")
					else
						display alert (localized string "errorprevented") & theFile & (localized string "conversionfromstarting") & "   
" & (do shell script "/usr/bin/tail -1 /tmp/rztemp/" & fullstarttime & "/reduxzero_time") attached to window "ReduxZero" default button (localized string "Acceptance") other button (localized string "Denial")
					end if
				end if
			end if
		on error
			display alert (localized string "ffmpegcrash") attached to window "ReduxZero" default button (localized string "concernok")
		end try
	end if
	--set pid to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_pid")
	
	--Everything seems to be working...That's amazing!
	--hidin' spinnaz
	set indeterminate of progress indicator "bar" of window "ReduxZero" to false
	--	tell progress indicator "spinner" of window "ReduxZero" to stop
	--	set visible of progress indicator "spinner" of window "ReduxZero" to false
	
	--This is where unholy demonry is conjured to make an AppleScript Studio progress bar and Time Remaining indicator out of a single-threaded process.	
	set howlonglessthan to "0"
	set estimyet to false
	set isdone to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_working")
	
	--first time gathering
	set percent to 0.01
	set oldpercent to percent
	repeat until isdone is "done"
		--Cancel in the progress loop. Best place for it, I guess.
		canceller()
		tell button "cancel" of window "ReduxZero" to set visible to true
		if estimyet is false then
			try
				if decimal is "comma" then
					set percent to (do shell script "/bin/echo `/usr/bin/tail -100 /tmp/rztemp/" & fullstarttime & "/reduxzero_time | grep 'time=' | strings | /usr/bin/tail -1 | /usr/bin/awk -F time= '{print $2}' | /usr/bin/awk -F . '{print $1}'` / `cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration` | bc -l | cut -c 1-7 | /usr/bin/sed -e 's/" & backslash & "./,/g'") as number
				else
					set percent to (do shell script "/bin/echo `/usr/bin/tail -100 /tmp/rztemp/" & fullstarttime & "/reduxzero_time | grep 'time=' | strings | /usr/bin/tail -1 | /usr/bin/awk -F time= '{print $2}' | /usr/bin/awk -F . '{print $1}'` / `cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration` | bc -l | cut -c 1-7") as number
				end if
			end try
			--try		
			--set percent to ("0" & percent1) as number
			--set percent to (percent1 as number)
			--If ffmpeg lied, leave the user in suspense at 99%. 100% just gives them hope.
			try
				if percent > 0.99999 then
					set percent to 0.99
				end if
				--				if percent is 0 then
				--					set percent to 0.01
				--				end if
			end try
			
			--			set the content of text field "timeremaining" of window "ReduxZero" to ""
			if percent > 0 then
				set the content of progress indicator "bar" of window "ReduxZero" to (percent + whichone)
				waiter(1)
			end if
			set the content of text field "howmany" of window "ReduxZero" to (localized string "file") & whichone & (localized string "of") & howmany
			waiter(4)
		end if
		
		update window "ReduxZero"
		canceller()
		--'cause of weird problems people had with AppleScript number errors, run the progress loop as a "try".
		try
			if decimal is "comma" then
				set percent to (do shell script "/bin/echo `/usr/bin/tail -100 /tmp/rztemp/" & fullstarttime & "/reduxzero_time | grep 'time=' | strings | /usr/bin/tail -1 | /usr/bin/awk -F time= '{print $2}' | /usr/bin/awk -F . '{print $1}'` / `cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration` | bc -l | cut -c 1-7 | /usr/bin/sed -e 's/" & backslash & "./,/g'") as number
			else
				set percent to (do shell script "/bin/echo `/usr/bin/tail -100 /tmp/rztemp/" & fullstarttime & "/reduxzero_time | grep 'time=' | strings | /usr/bin/tail -1 | /usr/bin/awk -F time= '{print $2}' | /usr/bin/awk -F . '{print $1}'` / `cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration` | bc -l | cut -c 1-7") as number
			end if
		end try
		--try		
		--		set percent to ("0" & percent1) as number
		--set percent to (percent1 as number)
		--If ffmpeg lied, leave the user in suspense at 99%. 100% just gives them hope.
		try
			if percent > 0.99999 then
				set percent to 0.99
			end if
			--	if percent is 0 then
			--		set percent to 0.01
			--	end if
		end try
		try
			if percent > 0 then
				set the content of progress indicator "bar" of window "ReduxZero" to (percent + whichone)
				try
					set remaining to (do shell script thequotedapppath & "/Contents/Resources/remainer " & (percent as feet as string) & " " & starttime & " " & decimal) as number
				end try
				--tell application "Terminal" to do script thequotedapppath & "/Contents/Resources/remainer " & (percent as feet as string) & " " & starttime & " " & decimal
				set s to (localized string "plural")
				set lessthan to (localized string "about")
				--	if remaining is "1" then
				if remaining < 2 then
					set lessthan to (localized string "lessthan")
					set s to ""
					set howlonglessthan to (howlonglessthan + 1)
				end if
				--		if remaining is "" then
				--			set lessthan to (localized string "alittleover")
				--			set remaining to "1"
				--			set s to ""
				--		end if
				--		if remaining is "0" then
				--			set lessthan to (localized string "lessthan")
				--			set remaining to "1"
				--			set s to ""
				--			set howlonglessthan to (howlonglessthan + 1)
				--		end if
				--If the time guess is very wrong, let people know that you know it's wrong. That way, they complain less.
				if howlonglessthan > 16 then
					set the content of text field "timeremaining" of window "ReduxZero" to (localized string "badestimate1") & whichone & (localized string "badestimate2")
				else
					--	if estimyet is less than 1 then
					--	set the content of text field "timeremaining" of window "ReduxZero" to ""
					--else
					if remaining < 0 then
						--	set the content of text field "timeremaining" of window "ReduxZero" to ""
						update window "ReduxZero"
					else
						set the content of text field "timeremaining" of window "ReduxZero" to lessthan & " " & (round remaining rounding down) & (localized string "minute") & s & (localized string "remainingforfile") & whichone & "..."
					end if
				end if
				--		end try
				--on error
				--if user "can't make 0.0926 into type number", laugh at them and give limited, harmless feedback.
				--	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "convertingfile") & whichone
				--	set the content of progress indicator "bar" of window "ReduxZero" to whichone
				--end try
				update window "ReduxZero"
			end if
			--		set remaining to do shell script "" & thequotedapppath & "/Contents/Resources/remainer " & percent & " " & starttime & " " & decimal
			--		try
			
			--This delay setup is the best compromise for <10.4.3 users. The UI stays pretty responsive, but doesn't take all your CPU.
			waiter(4)
			--isrunning is either "1" or "0". It's 0 when the pid for ffmpeg is gone.
			--	set isrunning to (do shell script "ps -p " & pid & " | grep " & pid & " | wc -l | awk '{print $1}'" as string)
			set isdone to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_working")
			set estimyet to true
		end try
	end repeat
end barloop

on quicktimedetects()
	if contents of button "forceonoff" of advanced is true then
		if (get contents of popup button "forcetype" of advanced) is 0 then
			qtprocproc()
		end if
		if (get contents of popup button "forcetype" of advanced) is 1 then
			update window "ReduxZero"
		end if
		if (get contents of popup button "forcetype" of advanced) is 2 then
			vlcproc()
		end if
	else
		--If the file is a QuickTime .mov file, use QuickTime frameworks to decode for better compatibility
		if ext is not "mp4" then
			if "mov,mp4,m4a" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur") then
				qtprocproc()
			end if
		end if
		(*
		if ext is "mov" then
			qtprocproc()
		end if
		
		if ext is "3gp" then
			qtprocproc()
		end if
		
		if ext is "mp4" then
			qtprocproc()
		end if
		
		if ext is "m4v" then
			qtprocproc()
		end if
		
		if ext is "dv" then
			qtprocproc()
		end if
		*)
		if ext is "qtz" then
			qtprocproc()
		end if
		
		--		if ext is "iMovieProject" then
		--			qtprocproc()
		--		end if
	end if
	
end quicktimedetects

on vlcproc()
	if xgrid is true then
		error (localized string "novlcxgrid")
	end if
	if (contents of default entry "vlcloc" of user defaults as string) is "" then
		--		set contents of default entry "vlcloc" of user defaults to (POSIX path of (path to application "VLC"))
		try
			set contents of default entry "vlcloc" of user defaults to (do shell script "osascript -l AppleScript -e 'POSIX path of (path to application \"VLC\")'")
		on error
			error "VLC was not found. It can be downloaded at http://videolan.org"
		end try
	end if
	set fps to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Video | head -1 | awk -F , '{print $11}' | awk -F . '{print $1}'")
	if fps > 60 then
		set vlcfps to 60
	end if
	if fps < 51 then
		set vlcfps to 50
	end if
	if fps < 31 then
		set vlcfps to 30
	end if
	if fps < 26 then
		set vlcfps to 25
	end if
	if fps < 25 then
		set vlcfps to 24
	end if
	if fps < 23 then
		set vlcfps to 30
	end if
	if fps is 15 then
		set vlcfps to 30
	end if
	try
		vlcfps as number
	on error
		set vlcfps to 30
	end try
	
	if (do shell script "/bin/test -f " & (quoted form of (contents of default entry "vlcloc" of user defaults as string)) & "/Contents/MacOS/clivlc  ; echo $?") is "1" then
		-- is 0.9.2
		set thishz to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ,Audio, | head -1 | awk -F , '{print $8}' ; exit 0")
		if thishz is "48000" then
			set vlcacodec to "a52"
		else
			set vlcacodec to "mpga"
		end if
		set fifopath to "/tmp/rztemp/" & fullstarttime & "/vlc.mpg"
		do shell script "/usr/bin/mkfifo " & fifopath
		--		set pipe to ((quoted form of (contents of default entry "vlcloc" of user defaults as string)) & "/Contents/MacOS/VLC -I dummy " & thequotedorigpath & " --sout-transcode-fps=" & vlcfps & " --gamma=1.18 --sout-ffmpeg-qscale=1 --sout='#transcode{vcodec=mp2v,scale=1,acodec=" & vlcacodec & ",channels=2,ab=320,audio-sync}:std{mux=ps,dst=/tmp/rztemp/" & fullstarttime & "/vlc.mpg}' vlc://quit 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time | ")
		set pipe to ""
		set isvlc092 to true
		do shell script ((quoted form of (contents of default entry "vlcloc" of user defaults as string)) & "/Contents/MacOS/VLC --reset-plugins-cache -I dummy " & thequotedorigpath & " --sout-transcode-fps=" & vlcfps & " --gamma=1.18 --sout-ffmpeg-qscale=1 --sout='#transcode{vcodec=mp2v,scale=1,acodec=" & vlcacodec & ",channels=2,ab=320,audio-sync}:std{mux=ps,dst=/tmp/rztemp/" & fullstarttime & "/vlc.mpg}' vlc://quit > /dev/null 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time &")
		set thequotedorigpath to fifopath
	else
		set pipe to ((quoted form of (contents of default entry "vlcloc" of user defaults as string)) & "/Contents/MacOS/clivlc -I dummy " & thequotedorigpath & " --sout-transcode-fps=" & vlcfps & " --gamma=1.18 --sout-ffmpeg-qscale=1 --sout='#transcode{vcodec=mp2v,scale=1,acodec=mpga,channels=2,samplerate=48000,ab=320,audio-sync}:std{mux=ps,dst=-}' vlc:quit 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time | ")
		set thequotedorigpath to "-"
	end if
	set forcepipe to " "
	set ismov to "mov"
end vlcproc

on videotsproc()
	if xgrid is true then
		set dvdfolder to " " & backslash & "$dir/" & thequotedfile
		set serverfile to " | "
	else
		set dvdfolder to thequotedorigpath
	end if
	
	if contents of default entry "dvdpipe" of user defaults is "play_title" then
		set pipe to ("" & thequotedapppath & "/Contents/Resources/play_title " & dvdfolder & " " & dvdtitlenumber & " 1 1 2> /dev/null | ")
	else
		set pipe to ("" & thequotedapppath & "/Contents/Resources/tccat -i " & dvdfolder & " -T " & dvdtitlenumber & ",-1,1 2> /dev/null | ")
	end if
	set xpipe to ("./play_title " & dvdfolder & " " & dvdtitlenumber & " 1 1 2> /dev/null ")
	set forcepipe to " "
	set thequotedorigpath to "-"
	set ismov to "mov"
end videotsproc

on qtprocproc()
	--	try
	--Generate the pipe command strings based off the width, height and fps settings above.
	try
		set movinfos to (do shell script "" & thequotedapppath & "/Contents/Resources/movinfo " & thequotedorigpath)
		set qtresult to true
	on error
		set qtresult to false
	end try
	if the qtresult is true then
		
		--The audio needs to be extracted seperately. No real need to put this in the background, so give feedback about the UI stall.
		
		--Decode audio to WAV and place it in the /tmp folder out of the way.
		set audrand to (do shell script "/bin/echo $RANDOM")
		if xgrid is true then
			set extaudio to " -i " & backslash & "$dir/" & audrand & ".wav "
		else
			set extaudio to " -i /tmp/rztemp/" & fullstarttime & "/" & audrand & ".wav "
		end if
		set extaudiofile to "/tmp/rztemp/" & fullstarttime & "/" & audrand & ".wav"
		try
			do shell script "rm " & extaudiofile
		end try
		if preview is false then
			set indeterminate of progress indicator "bar" of window "ReduxZero" to true
			set the content of text field "timeremaining" of window "ReduxZero" to (localized string "prepaud") & whichone & "..."
			update window "ReduxZero"
			try
				if ext is "swf" or ext is "mpg" or ext is "vob" or ext is "mpeg" or ext is "ts" or ("mp3" is in (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ,Audio, | head -1") and contents of button "forceonoff" of window "advanced" is false) then
					do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " " & extaudiofile
				else
					do shell script "" & thequotedapppath & "/Contents/Resources/movtowav -o " & extaudiofile & " " & thequotedorigpath
				end if
				set indeterminate of progress indicator "bar" of window "ReduxZero" to false
				update window "ReduxZero"
			on error
				try
					do shell script "rm " & extaudiofile
				end try
				set extaudio to "  "
				set extaudiofile to ""
			end try
		else
			set extaudio to "  "
			set extaudiofile to ""
		end if
		if decimal is not "comma" then
			try
				set movfps2 to (do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $4}'") as number
			on error
				set movfps2 to 29.97
			end try
			set movfps to (round movfps2)
			set colon to ":1"
		else
			try
				set movfps2 to (do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $4}' | sed -e 's/" & backslash & "./,/g'") as number
			on error
				set movfps2 to 29.97
			end try
			set movfps to (round movfps2)
			set colon to ":1"
		end if
		if movfps2 is 23.98 then
			set movfps to 24
			set colon to "000:1001"
		end if
		if movfps2 is 29.97 then
			set movfps to 30
			set colon to "000:1001"
		end if
		if movfps < 3 then
			set movfps to 30
		end if
		set movwidth to getmult((do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $2}'"), 4)
		set morzeight to getmult((do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $3}' | sed -e 's/ //g'"), 4)
		set origmovwidth to (do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $2}'")
		set origmorzeight to (do shell script "/bin/echo " & movinfos & " | /usr/bin/awk -F , '{print $3}'")
		set h264correct to ""
		try
			if type is "mp4box" or type is "ipodbox" then
				if contents of button "h264" of tab view item type of tab view "tabbox" of window "ReduxZero" is true then
					set h264correct to thequotedapppath & "/Contents/Resources/yuvcorrect -v 0 -Y LUMINANCE_1.20_0_255_0_255 -Y CHROMINANCE_0_1.04_128_1.04_128_0_255 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time | "
				end if
			end if
		end try
		set pipe to ("" & thequotedapppath & "/Contents/Resources/movtoy4m -w " & movwidth & " -h " & morzeight & " -F " & movfps & colon & " -a " & movwidth & ":" & morzeight & " " & thequotedorigpath & " 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time | " & h264correct)
		set xpipe to ("./movtoy4m -w " & movwidth & " -h " & morzeight & " -F " & movfps & colon & " -a " & movwidth & ":" & morzeight & " ")
		set forcepipe to " -f yuv4mpegpipe "
		set thequotedorigpath to "-"
		set qtproc to true
		set ismov to "mov"
		--	end try
	end if
end qtprocproc

on easyend()
	--Finished.
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
	update window "ReduxZero"
	
	if stitch is true then
		set stitchstack to (stitchstack & outputfile)
		set newext to " "
		set moreend to ""
	else
		set newext to (destpath & quoted form of filenoext) & fileext
		if (do shell script "/bin/test -f " & newext & " ; echo $?") is "0" then
			set moreend to fileext
			try
				do shell script "mv -n " & outputfile & " " & newext & fileext
			end try
		else
			try
				do shell script "mv -n " & outputfile & " " & newext
			end try
			set moreend to ""
		end if
	end if
end easyend

on fit()
	if contents of button "fitonoff" of advanced is true then
		set filedur to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration") as number
		set filekbits to (contents of text field "fit" of advanced as number)
		set bitratework1 to ((filekbits * 8000) / filedur)
		set text item delimiters to " "
		set ab to (last text item of audstring)
		set text item delimiters to "k"
		try
			set bitrate to (round (bitratework1 - (first text item of ab)) rounding down)
		on error
			set bitrate to (round bitratework1 rounding down)
		end try
		set bitnum to bitrate
		set cons to " -b " & bitrate & "k "
		set qmin to ""
		try
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
			end if
		end try
	end if
end fit

on previewsetup()
	if previewstring is " " then
		set outputfile to (destpath & thequotedfile & ".temp" & fileext)
		set normalend to " 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time " & " ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working"
	else
		set outputfile to " "
		set normalend to ""
	end if
end previewsetup

on xpiper()
	if xpipe is "" then
		set serverinput to ("" & backslash & "$loc/" & thequotedfile)
		set serverfile to ""
	else
		set serverinput to "- "
		if isvideots is true then
			set serverfile to " | "
		else
			set serverfile to ("" & backslash & "$loc/" & thequotedfile & " | ")
		end if
	end if
	if qtproc is true then
		if extaudio is not "" then
			set extaudio to " -i " & backslash & "$loc/" & thequotedfile & ".wav "
		end if
	end if
end xpiper

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

--  Created by Tyler Loch on 3/26/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.


on choose menu item theObject
	tmpgetter()
	set advanced to window "advanced"
	set croptype to (contents of popup button "autocrop" of advanced)
	set xgrid to false
	set preview to true
	set ext to ""
	set whichone to 1
	set threadscmd to " -threads 2 "
	try
		set threadscmd to " -threads " & (((do shell script "/usr/sbin/sysctl hw.logicalcpu | /usr/bin/cut -c 16-") as number) * 2) & " "
	end try
	set type to (name of current tab view item of tab view "tabbox" of window "ReduxZero" as string)
	set mainscript to load script file (POSIX file ((path of the main bundle as string) & "/Contents/Resources/Scripts/main.scpt"))
	procdecimal() of mainscript
	set sysver to (do shell script "uname -r | cut -c 1")
	if croptype is 2 then
		load nib "advloading"
		set contents of text field "croptop" of advanced to 0
		set contents of text field "cropbottom" of advanced to 0
		set contents of text field "cropleft" of advanced to 0
		set contents of text field "cropright" of advanced to 0
		try
			set uses threaded animation of progress indicator "loader" of window "loading" to true
		end try
		tell progress indicator "loader" of window "loading" to start
		set contents of text field "loading" of window "loading" to (localized string "cropping")
		display panel window "loading" attached to advanced
		set rzver to "135"
		set thePath to path of the main bundle as string
		set thequotedapppath to quoted form of thePath
		set ffmpegloc to (thequotedapppath & "/Contents/Resources/")
		set howmany to (number of data rows of data column "Files" of (data source of table view "files" of scroll view "files" of window "ReduxZero"))
		if howmany is 0 then
			display alert (localized string "nofiles")
			tell progress indicator "bar" of window "ReduxZero" to stop
			close panel window "loading"
			--	tell progress indicator "spinner" of window "ReduxZero" to stop
			error number -128
		end if
		set itsselected to true
		try
			(selected data row of table view "files" of scroll view "files" of window "ReduxZero") as POSIX file
		on error
			set itsselected to false
		end try
		if itsselected is true then
			try
				pathings(selected data row of table view "files" of scroll view "files" of window "ReduxZero")
			on error
				set thequotedorigpath to (quoted form of (contents of data cell 1 of selected data row of table view "files" of scroll view "files" of window "ReduxZero" as string))
				set thequotedfile to "rzpreviewfile"
			end try
		else
			try
				pathings(data row 1 of data column "Files" of the data source of table view "files" of scroll view "files" of window "ReduxZero")
			on error
				set thequotedorigpath to (quoted form of (contents of data cell 1 of data row 1 of data column "Files" of the data source of table view "files" of scroll view "files" of window "ReduxZero" as string))
				set thequotedfile to "rzpreviewfile"
			end try
		end if
		bunchavars() of mainscript
		set preview to true
		try
			do shell script thequotedapppath & "/Contents/Resources/lsdvd " & thequotedorigpath
			set isvideots to true
		end try
		--		set isdvd to (do shell script "" & thequotedapppath & "/Contents/Resources/tcprobe -i " & thequotedorigpath & " 2> /dev/stdout | grep -c 'DVD image' ; exit 0")
		
		--		if isdvd is "1" then
		--			set isvideots to true
		--		end if
		if isvideots is true then
			dvdtitlefinder()
		else
			thedur()
		end if
		if isvideots is true then
			videotsproc()
		end if
		quicktimedetects()
		autocrop()
		set enabled of text field "croptop" of advanced to true
		set enabled of text field "cropbottom" of advanced to true
		set enabled of text field "cropleft" of advanced to true
		set enabled of text field "cropright" of advanced to true
		tell progress indicator "loader" of window "loading" to stop
		close panel window "loading"
	else
		set contents of text field "croptop" of advanced to "Auto"
		set contents of text field "cropbottom" of advanced to "Auto"
		set contents of text field "cropleft" of advanced to "Auto"
		set contents of text field "cropright" of advanced to "Auto"
		set enabled of text field "croptop" of advanced to false
		set enabled of text field "cropbottom" of advanced to false
		set enabled of text field "cropleft" of advanced to false
		set enabled of text field "cropright" of advanced to false
	end if
	set the content of text field "timeremaining" of window "ReduxZero" to ""
end choose menu item

on clicked theObject
	(*Add your script here.*)
end clicked


on canceller()
	if (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_cancel") is "cancel" then
		try
			do shell script "kill " & pid
		on error
			try
				do shell script "kill `ps -xww | grep rz" & ver & "ffmpeg | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
			end try
		end try
		try
			do shell script "kill `ps -xww | grep play_title | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
		end try
		try
			do shell script "kill `ps -xww | grep clivlc | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
		end try
		try
			if isvlc092 then
				do shell script "kill -9 `ps -xww | grep 'VLC -I' | grep -v sh | grep -v grep | tail -1 | awk '{print $1}'`"
			end if
		end try
		try
			if xgrid is true then do shell script "killall xgrid ; killall httpd"
		end try
		set visible of button "cancel" of window "ReduxZero" to false
		set the content of text field "howmany" of window "ReduxZero" to ""
		set the content of progress indicator "bar" of window "ReduxZero" to "0"
		set the content of text field "timeremaining" of window "ReduxZero" to ""
		--Delete temp files
		try
			--if vcodec = " -vcodec h264 " then
			--			do shell script "rm " & tempvid
			--do shell script "rm " & tempaac
			do shell script "cp /tmp/rztemp/" & fullstarttime & "/reduxzero_time ~/Library/Logs/reduxzeroweb/rz`date +%y%m%d-%H%M`-" & thequotedfile & ".txt"
			do shell script "rm -r /tmp/rztemp/" & fullstarttime
			--	end if
			if qtproc is true then
				do shell script "rm " & extaudiofile
			end if
		end try
		display alert (localized string "cancelsheet") attached to window "ReduxZero" default button (localized string "cancelok")
		tell progress indicator "bar" of window "ReduxZero" to stop
		set indeterminate of progress indicator "bar" of window "ReduxZero" to false
		--		tell progress indicator "spinner" of window "ReduxZero" to stop
		error number -128
	end if
end canceller

on findnum(this_text, this_case)
	if this_case is 0 then
		set the comparison_string to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		set the source_string to "abcdefghijklmnopqrstuvwxyz"
	else
		set the comparison_string to "abcdefghijklmnopqrstuvwxyz"
		set the source_string to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	end if
	set the new_text to ""
	repeat with this_char in this_text
		set x to the offset of this_char in the comparison_string
		if x is not 0 then
			set the new_text to (the new_text & character x of the source_string) as string
		else
			set the new_text to (the new_text & this_char) as string
		end if
	end repeat
	return the new_text
end findnum



on waiter(waittime)
	if sysver > 7 then
		delay waittime
	else
		repeat waittime times
			do shell script "/bin/sleep 1"
			update window "ReduxZero"
		end repeat
	end if
end waiter

on tmpgetter()
	set fullstarttime to do shell script "/bin/date +%s"
	set contents of text field "fullstarttime" of window "ReduxZero" to fullstarttime
	if (contents of default entry "tmpdir" of user defaults as string) is "" then
		try
			do shell script "mkdir /tmp/rztemp"
		end try
		try
			do shell script "chmod -R 777 /tmp/rztemp"
		end try
		try
			do shell script "mkdir /tmp/rztemp/" & fullstarttime
		end try
		try
			do shell script "chmod 777 /tmp/rztemp" & fullstarttime
		end try
	else
		try
			--display dialog (quoted form of (contents of default entry "tmpdir" of user defaults as string))
			do shell script "ln -s " & (quoted form of (contents of default entry "tmpdir" of user defaults as string)) & " /tmp/rztemp"
		end try
		try
			do shell script "mkdir /tmp/rztemp/" & fullstarttime
		end try
		try
			do shell script "chmod -R 777 /tmp/rztemp"
		end try
	end if
end tmpgetter
