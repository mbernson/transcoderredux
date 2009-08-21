-- dvd.applescript
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
global threadscmd
global theFile2
global destpath
global destpath2
global theRow
global theList
global fullstarttime
global isrunning
global outputfile
global dvdaudiotrack
global dashr
global vn
global vcodec
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
global pipe
global forcepipe
global qtproc
global ismov
global ar
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
global xgridffmpegstring
global origAR
global origPAR
global thePath
global filenoext
global thequotedfile
global fileext
global vol
global serverfile
global serverinput
global dvdbox
global thewidth
global theheight
global qmin
global moreend
global newext
global dvdtype
global fps2
global fulldur
global thetarget
global stitchstack
global twopass
global colorspace
global pass1ffmpegstring
global dvdwide
global theaspect
global proctype
global ffmpegloc
global preview
global backslash
global dvdforce

on mainstart()
	
	
	set dvdbox to tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero"
	
	set fileext to ".vob"
	
	previewsetup() of snippets
	
	set vcodec to " -vcodec mpeg2video "
	
	proccrop() of snippets
	
	set cons to ""
	
	set format to "dvdntsc"
	set dvdtype to "ntsc"
	if content of cell "pal" of matrix "format" of dvdbox is true then
		set format to "dvdpal"
		set dvdtype to "pal"
	end if
	
	
	
	if contents of text field "audbitrate" of advanced is not "" then
		set audstring to " -ab " & (contents of text field "audbitrate" of advanced) & "k -ar 48000 "
	else
		set audstring to " -ar 48000 -ab 192k"
	end if
	
	fit() of snippets
	
	
	if contents of default entry "dvd4.38" of user defaults as string is "true" then
		set dvdsize to 1.118
	else
		set dvdsize to 1
	end if
	
	if content of button "dvdforce" of box "dvdadvbox" of advanced is true and (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced) is 3 then
		--		set dvdsize to 1.8
		set dvdsize to 2
		--	else
		--		set dvdsize to 1
	end if
	
	if contents of button "author" of dvdbox is true then
		set optim to " "
		set formatforcer to " -f dvd "
		if fulldur < (4000 * dvdsize) then
			set cons to " -b 7500k -maxrate 8000k " ---minrate 7000 "
			set content of slider "quality" of dvdbox to 3
		end if
		if fulldur > (3999 * dvdsize) and fulldur < (12000 * dvdsize) then
			set cons to " -b " & (round (((32000000 * dvdsize) / fulldur) - 192)) & "k -maxrate 8000k " ---minrate " & ((32000000 / fulldur) - 1000) & " "
			set audstring to " -ab 192k -ar 48000 "
			set content of slider "quality" of dvdbox to 3
		end if
		if fulldur > (11999 * dvdsize) and fulldur < (25000 * dvdsize) then
			set cons to " -b " & (round (((32000000 * dvdsize) / fulldur) - 160)) & "k " ---minrate " & ((32000000 / fulldur) - 700) & " "
			set format to (format & "small")
			set audstring to " -ab 160k -ar 48000 "
			set content of slider "quality" of dvdbox to 2
		end if
		if fulldur > (24999 * dvdsize) then
			set cons to " -b " & (round (((32000000 * dvdsize) / fulldur) - 96)) & "k " ---minrate " & ((32000000 / fulldur) - 300) & " "
			set format to "vcd"
			set audstring to " -ab 96k -ar 48000 "
			set content of slider "quality" of dvdbox to 1
		end if
	else
		set formatforcer to " -f vob "
	end if
	
	if content of button "dvdforce" of box "dvdadvbox" of advanced is true then
		if (contents of popup button "dvdaspect" of box "dvdadvbox" of advanced) is 2 then
			set content of slider "quality" of dvdbox to 3
		end if
	end if
	
	update window "ReduxZero"
	delay 0.1
	
	procoptim()
	
	
	
	--**Set the encoding variables**--
	--Basically, for earch category, check if there" & backslash  & ""s an advanced setting set, and use that instead of the default Easy Settings.		
	
	
	--Framerate. If the user knows better, great. If not, use ffmpeg and/or quicktime's guess, and compensate if necessary.
	if contents of text field "framerate" of advanced is "" then
		set fps to dvdtype
	else
		set fps to (contents of text field "framerate" of advanced)
	end if
	
	--	audiogo() of snippets
	
	
	dvdslider()
	
	
	set thetarget to " -target " & dvdtype & "-dvd "
	set qmin to ""
	set vcodec to ""
	
	
	deinterlacer() of snippets
	
	if threadscmd is " -threads 16 " then
		set threadscmd to " -threads 8 "
	end if
	
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & thetarget & " " & " -s " & optim & dashr & fps & "  " & vcodec & " -g 15 -sc_threshold 1000000000 -flags cgop -flags2 sgop " & qmin & " -bf 2 -b_qfactor 1.5 " & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
	else
		set passstring to " "
	end if
	set bframes to " "
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
		end if
	else
		set bframes to " -bf 2 " ---b_qfactor 1.5 "
	end if
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & thetarget & cons & " -s " & optim & passstring & dashr & fps & "  " & vcodec & " -g 15 -sc_threshold 1000000000 -flags cgop -flags2 sgop " & qmin & bframes & ffvideos & vol & " -async 50 " & extaudio & " " & audstring & " -ac 2 " & ffaudios & formatforcer & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & thetarget & cons & " -s " & optim & dashr & fps & "  " & vcodec & " -g 15 -sc_threshold 1000000000 -flags cgop -flags2 sgop " & qmin & " -bf 2 -b_qfactor 1.5 " & ffvideos & vol & " -async 50 " & extaudio & " " & audstring & " -ac 2 " & ffaudios & formatforcer & " " & backslash & "$dir/" & thequotedfile & ".temp.vob ")
end mainstart

on mainend()
	if contents of button "author" of dvdbox is true then
		
		
		set stitchstack to (stitchstack & outputfile)
		set newext to " "
		set moreend to ""
	else
		easyend() of snippets
	end if
end mainend

on dvdslider()
	if contents of text field "bitrate" of advanced is "" then
		fit() of snippets
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
	end if
end dvdslider

on procoptim()
	if dvdwide is true then
		set tiny to "16by9"
	else
		set tiny to "4by3"
	end if
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	--	if contents of button "author" of dvdbox is false then
	if contents of text field "width" of advanced is "" then
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		if (content of slider "quality" of dvdbox as number) is 1 then
			set optim to ((do shell script "/usr/bin/ulimit -u 256 ; " & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & dvdtype & "vcd nottiny " & mpegaspect) & " -aspect 4:3 ")
			--			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			--			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		end if
		if (content of slider "quality" of dvdbox as number) is 2 then
			set optim to ((do shell script "/usr/bin/ulimit -u 256 ; " & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & dvdtype & "dvdsmall nottiny " & mpegaspect) & " -aspect 4:3 ")
			--			set thewidth to do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | rev | awk -F x '{print $2}' | awk '{print $1}' | rev | head -1"
			--			set theheight to do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | rev | awk -F x '{print $1}' | rev | awk -F , '{print $1}' | head -1"
		end if
		if (content of slider "quality" of dvdbox as number) is 3 then
			set optim to do shell script "/usr/bin/ulimit -u 256 ; " & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & dvdtype & "dvd " & tiny & " " & mpegaspect
			--			set thewidth to do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | rev | awk -F x '{print $2}' | awk '{print $1}' | rev | head -1"
			--			set theheight to do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep fps | rev | awk -F x '{print $1}' | rev | awk -F , '{print $1}' | head -1"
		end if
		
	else
		-- ...or use the user's settings.
		set thewidth to contents of text field "width" of advanced
		set theheight to contents of text field "height" of advanced
		set optim to ((thewidth & "x" & theheight) as string)
	end if
	--end if
end procoptim

on dvdstitcher()
	if content of button "author" of tab view item "dvdbox" of tab view "tabbox" of window "ReduxZero" is true then
		if content of button "burn" of dvdbox is true then
			set dvdsteps to 4
		else
			set dvdsteps to 3
		end if
		set chapterevery to " "
		if (get contents of popup button "dvdchapters" of box "dvdadvbox" of advanced) is 1 then
			set chapterevery to " -c 0,0:05:00,0:10:00,0:15:00,0:20:00,0:25:00,0:30:00,0:35:00,0:40:00,0:45:00,0:50:00,0:55:00,1:00:00,1:05:00,1:10:00,1:15:00,1:20:00,1:25:00,1:30:00,1:35:00,1:40:00,1:45:00,1:50:00,1:55:00,2:00:00,2:05:00,2:10:00,2:15:00,2:20:00,2:25:00,2:30:00,2:35:00,2:40:00,2:45:00,2:50:00,2:55:00,3:00:00,3:05:00,3:10:00,3:15:00,3:20:00,3:25:00,3:30:00,3:35:00,3:40:00,3:45:00,3:50:00,3:55:00,4:00:00,4:05:00,4:10:00,4:15:00,4:20:00,4:25:00,4:30:00,4:35:00,4:40:00,4:45:00,4:50:00,4:55:00,5:00:00,5:05:00,5:10:00,5:15:00,5:20:00,5:25:00,5:30:00,5:35:00,5:40:00,5:45:00,5:50:00,5:55:00,6:00:00,6:05:00,6:10:00,6:15:00,6:20:00,6:25:00,6:30:00,6:35:00,6:40:00,6:45:00,6:50:00,6:55:00,7:00:00,7:05:00,7:10:00,7:15:00,7:20:00,7:25:00,7:30:00,7:35:00,7:40:00,7:45:00,7:50:00,7:55:00,8:00:00,8:05:00,8:10:00,8:15:00,8:20:00,8:25:00,8:30:00,8:35:00,8:40:00,8:45:00,8:50:00,8:55:00,9:00:00,9:05:00,9:10:00,9:15:00,9:20:00,9:25:00,9:30:00,9:35:00,9:40:00,9:45:00,9:50:00,9:55:00,10:00:00,10:05:00,10:10:00,10:15:00,10:20:00,10:25:00,10:30:00,10:35:00,10:40:00,10:45:00,10:50:00,10:55:00,11:00:00,11:05:00,11:10:00,11:15:00,11:20:00,11:25:00,11:30:00,11:35:00,11:40:00,11:45:00,11:50:00,11:55:00,12:00:00,12:05:00,12:10:00,12:15:00,12:20:00,12:25:00,12:30:00,12:35:00,12:40:00,12:45:00,12:50:00,12:55:00,13:00:00,13:05:00,13:10:00,13:15:00,13:20:00,13:25:00,13:30:00,13:35:00,13:40:00,13:45:00,13:50:00,13:55:00,14:00:00,14:05:00,14:10:00,14:15:00,14:20:00,14:25:00,14:30:00,14:35:00,14:40:00,14:45:00,14:50:00,14:55:00,15:00:00,15:05:00,15:10:00,15:15:00,15:20:00,15:25:00,15:30:00,15:35:00,15:40:00,15:45:00,15:50:00,15:55:00,16:00:00,16:05:00,16:10:00,16:15:00,16:20:00,16:25:00,16:30:00,16:35:00,16:40:00,16:45:00,16:50:00,16:55:00,17:00:00,17:05:00,17:10:00,17:15:00,17:20:00,17:25:00,17:30:00,17:35:00,17:40:00,17:45:00,17:50:00,17:55:00,18:00:00 "
		end if
		if (get contents of popup button "dvdchapters" of box "dvdadvbox" of advanced) is 2 then
			set chapterevery to " -c 0,0:10:00,0:20:00,0:30:00,0:40:00,0:50:00,1:00:00,1:10:00,1:20:00,1:30:00,1:40:00,1:50:00,2:00:00,2:10:00,2:20:00,2:30:00,2:40:00,2:50:00,3:00:00,3:10:00,3:20:00,3:30:00,3:40:00,3:50:00,4:00:00,4:10:00,4:20:00,4:30:00,4:40:00,4:50:00,5:00:00,5:10:00,5:20:00,5:30:00,5:40:00,5:50:00,6:00:00,6:10:00,6:20:00,6:30:00,6:40:00,6:50:00,7:00:00,7:10:00,7:20:00,7:30:00,7:40:00,7:50:00,8:00:00,8:10:00,8:20:00,8:30:00,8:40:00,8:50:00,9:00:00,9:10:00,9:20:00,9:30:00,9:40:00,9:50:00,10:00:00,10:10:00,10:20:00,10:30:00,10:40:00,10:50:00,11:00:00,11:10:00,11:20:00,11:30:00,11:40:00,11:50:00,12:00:00,12:10:00,12:20:00,12:30:00,12:40:00,12:50:00,13:00:00,13:10:00,13:20:00,13:30:00,13:40:00,13:50:00,14:00:00,14:10:00,14:20:00,14:30:00,14:40:00,14:50:00,15:00:00,15:10:00,15:20:00,15:30:00,15:40:00,15:50:00,16:00:00,16:10:00,16:20:00,16:30:00,16:40:00,16:50:00,17:00:00,17:10:00,17:20:00,17:30:00,17:40:00,17:50:00,18:00 "
		end if
		if (get contents of popup button "dvdchapters" of box "dvdadvbox" of advanced) is 3 then
			set chapterevery to " -c 0,0:15:00,0:30:00,0:45:00,1:00:00,1:15:00,1:30:00,1:45:00,2:00:00,2:15:00,2:30:00,2:45:00,3:00:00,3:15:00,3:30:00,3:45:00,4:00:00,4:15:00,4:30:00,4:45:00,5:00:00,5:15:00,5:30:00,5:45:00,6:00:00,6:15:00,6:30:00,6:45:00,7:00:00,7:15:00,7:30:00,7:45:00,8:00:00,8:15:00,8:30:00,8:45:00,9:00:00,9:15:00,9:30:00,9:45:00,10:00:00,10:15:00,10:30:00,10:45:00,11:00:00,11:15:00,11:30:00,11:45:00,12:00:00,12:15:00,12:30:00,12:45:00,13:00:00,13:15:00,13:30:00,13:45:00,14:00:00,14:15:00,14:30:00,14:45:00,15:00:00,15:15:00,15:30:00,15:45:00,16:00:00,16:15:00,16:30:00,16:45:00,17:00:00,17:15:00,17:30:00,17:45:00,18:00 "
		end if
		set bigstitch to ""
		set bigdvdstitch to ""
		repeat with donefile in every item of stitchstack
			set bigdvdstitch to (bigdvdstitch & chapterevery & donefile)
		end repeat
		repeat with donefile in every item of stitchstack
			set bigstitch to (bigstitch & " " & donefile)
		end repeat
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "authordvd")
		set the content of text field "howmany" of window "ReduxZero" to (localized string "step") & 2 & (localized string "of") & dvdsteps
		update window "ReduxZero"
		do shell script "touch /tmp/rztemp/" & fullstarttime & "/reduxzero_authordone"
		if (dvdwide is true and content of slider "quality" of dvdbox is 3) or "16:9" is in ffvideos then
			set authoraspect to "16:9+nopanscan"
		else
			set authoraspect to "4:3"
		end if
		do shell script "sh -c \"" & thequotedapppath & "/Contents/Resources/dvdauthor -t " & bigdvdstitch & " -o /tmp/rztemp/" & fullstarttime & "/redz_DVD -v " & authoraspect & " > /tmp/rztemp/" & fullstarttime & "/reduxzero_authorstatus 2>&1 ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_authordone\"  > /dev/null 2>&1 &"
		do shell script "echo \"" & thequotedapppath & "/Contents/Resources/dvdauthor -t " & bigdvdstitch & " -o /tmp/rztemp/" & fullstarttime & "/redz_DVD -v " & authoraspect & " > /tmp/rztemp/" & fullstarttime & "/reduxzero_authorstatus 2>&1 ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_authordone\"  >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		waiter(1) of snippets
		repeat until (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_authordone") is "done"
			try
				set content of progress indicator "bar" of window "ReduxZero" to ((do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_authorstatus | grep Processing | wc -l") as number)
			end try
			if (get content of progress indicator "bar" of window "ReduxZero") is howmany then
				set the content of text field "timeremaining" of window "ReduxZero" to (localized string "authordvd2")
			end if
			waiter(2) of snippets
		end repeat
		do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_authorstatus >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "echo \"" & thequotedapppath & "/Contents/Resources/dvdauthor -T -o /tmp/rztemp/" & fullstarttime & "/redz_DVD > /dev/null 2>&1 \"  >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		do shell script "" & thequotedapppath & "/Contents/Resources/dvdauthor -T -o /tmp/rztemp/" & fullstarttime & "/redz_DVD >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time 2>&1 ; exit 0"
		if (do shell script "/bin/test -f /tmp/rztemp/" & fullstarttime & "/redz_DVD/VIDEO_TS/VIDEO_TS.IFO ; echo $?") is "1" then
			do shell script "echo '--PROBLEM CREATING VIDEO_TS.IFO. SUBSTITUTING PRE-MADE--' >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
			try
				do shell script "cp " & thequotedapppath & "/Contents/Resources/VIDEO_TS.IFO /tmp/rztemp/" & fullstarttime & "/redz_DVD/VIDEO_TS/VIDEO_TS.IFO"
			end try
			try
				do shell script "cp " & thequotedapppath & "/Contents/Resources/VIDEO_TS.IFO /tmp/rztemp/" & fullstarttime & "/redz_DVD/VIDEO_TS/VIDEO_TS.BUP"
			end try
		end if
		set the content of text field "timeremaining" of window "ReduxZero" to (localized string "imagedvd")
		set the content of text field "howmany" of window "ReduxZero" to (localized string "step") & 3 & (localized string "of") & dvdsteps
		set minimum value of progress indicator "bar" of window "ReduxZero" to 0
		set maximum value of progress indicator "bar" of window "ReduxZero" to 100
		update window "ReduxZero"
		--			do shell script "/bin/rm -r /tmp/rztemp/" & fullstarttime & "/redz_DVD/AUDIO_TS"
		do shell script "touch /tmp/rztemp/" & fullstarttime & "/reduxzero_isodone"
		set volname to (contents of text field "dvdvolname" of box "dvdadvbox" of advanced)
		if volname is "" then
			set dvdvolname to "VISUALHUB_DVD"
		else
			set dvdvolname to quoted form of (do shell script "/bin/echo " & volname & " | /usr/bin/cut -c 1-32")
		end if
		try
			if (do shell script "/bin/test -f " & destpath2 & dvdvolname & ".iso" & " ; echo $?") is "0" then
				set dvdvolname to "rz_DVD_" & fullstarttime
			end if
		end try
		do shell script "sh -c \"" & thequotedapppath & "/Contents/Resources/mkisofs -dvd-video -o " & destpath2 & dvdvolname & ".iso -V " & dvdvolname & " /tmp/rztemp/" & fullstarttime & "/redz_DVD 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_isostatus ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_isodone\"  > /dev/null 2>&1 &"
		do shell script "echo \"" & thequotedapppath & "/Contents/Resources/mkisofs -dvd-video -o " & destpath2 & dvdvolname & ".iso -V " & dvdvolname & " /tmp/rztemp/" & fullstarttime & "/redz_DVD 2> /tmp/rztemp/" & fullstarttime & "/reduxzero_isostatus ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_isodone\"  >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		waiter(1) of snippets
		repeat until (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_isodone") is "done"
			try
				set content of progress indicator "bar" of window "ReduxZero" to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_isostatus | grep done | tail -1 | awk -F % '{print $1}'")
			on error
				set content of progress indicator "bar" of window "ReduxZero" to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_isostatus | grep done | tail -1 | sed -e 's/" & backslash & "./,/g'")
			end try
			waiter(2) of snippets
		end repeat
		do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_isostatus >> /tmp/rztemp/" & fullstarttime & "/reduxzero_time"
		try
			do shell script "/bin/rm " & bigstitch
		end try
		try
			do shell script "/bin/rm -rf /tmp/rztemp/" & fullstarttime & "/redz_DVD"
		end try
		if content of button "burn" of dvdbox is true then
			set the content of text field "timeremaining" of window "ReduxZero" to (localized string "burndvd")
			set the content of text field "howmany" of window "ReduxZero" to (localized string "step") & 4 & (localized string "of") & dvdsteps
			update window "ReduxZero"
			if (do shell script "uname -r | sed -e 's/" & backslash & ".//g'") > 800 then
				set puppetstrings to " -puppetstrings "
			else
				set puppetstrings to " "
			end if
			do shell script "touch /tmp/rztemp/" & fullstarttime & "/reduxzero_burndone"
			do shell script "sh -c \"/usr/bin/hdiutil burn -anydevice -noverifyburn " & puppetstrings & destpath2 & dvdvolname & ".iso | tee -a /tmp/rztemp/" & fullstarttime & "/reduxzero_time /tmp/rztemp/" & fullstarttime & "/reduxzero_burnstatus ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_burndone\"  > /dev/null 2>&1 &"
			waiter(1) of snippets
			repeat until (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_burndone") is "done"
				try
					set content of progress indicator "bar" of window "ReduxZero" to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_burnstatus | grep PERCENT | grep -v 1.0000 | awk -F : '{print $2}' | tail -1") as number
				on error
					try
						set content of progress indicator "bar" of window "ReduxZero" to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_burnstatus | grep PERCENT | grep -v 1.0000 | awk -F : '{print $2}' | tail -1 | sed -e 's/" & backslash & "./,/g'") as number
					end try
				end try
				waiter(2) of snippets
			end repeat
		end if
	end if
end dvdstitcher

--  Created by Tyler Loch on 4/28/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.

