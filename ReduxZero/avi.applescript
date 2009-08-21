-- avi.applescript
-- ReduxZero

-- avi.applescript
-- ReduxZero

global decimal
global howmany
global whichone
global errors
global threadscmd
global thequotedapppath
global theFilepath
global thefixedfilepath
global thenewquotedfilepath
global thequotedorigpath
global backslash
global theFile
global theFile2
global destpath
global theRow
global stitchstack
global stitch
global newext
global theList
global origmovwidth
global origmorzeight
global fullstarttime
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
global streamer
global avibox
global thewidth
global theheight
global qmin
global divxprof
global twopass
global pass1ffmpegstring
global colorspace
global pass1ffmpegstring
global ffmpegloc
global threadder
global preview
global ext
global topcrop
global bottomcrop
global leftcrop
global rightcrop


on mainstart()
	
	
	set avibox to tab view item "avibox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".avi"
	
	previewsetup() of snippets
	
	set vcodec to " -vcodec mpeg4 -vtag DX50 "
	set acodec to " -acodec mp3 "
	set threadder to ""
	set divxprof to "divxnone"
	set bframes to " "
	if content of button "divxprofileonoff" of avibox is true then
		if contents of popup button "divxprofile" of avibox is 0 then
			set divxprof to "divxhome"
			set threadder to " -threads 1 "
			set bframes to " -bf 1 "
		end if
		if contents of popup button "divxprofile" of avibox is 1 then
			set divxprof to "divxport"
			set threadder to " -threads 1 "
			set bframes to " -bf 1 "
		end if
		--		if contents of popup button "divxprofile" of avibox is 2 then
		--			set divxprof to "ipod"
		--			set threadder to " -threads 1 "
		--			set vcodec to " -vcodec mpeg4 "
		--			set type to "tcpmp"
		--		end if
		if contents of popup button "divxprofile" of avibox is 2 then
			set divxprof to "divxport"
			set threadder to " -threads 1 "
		end if
		if contents of popup button "divxprofile" of avibox is 3 then
			set divxprof to "divxport"
			set threadder to " -threads 1 "
			set vcodec to " -vcodec msmpeg4v2 "
			--set acodec to " -acodec mp2 "
		end if
		if contents of popup button "divxprofile" of avibox is 4 then
			set divxprof to "divxport"
			set threadder to " -threads 1 "
			set vcodec to " -vcodec mjpeg "
			set acodec to " -acodec pcm_u8 "
		end if
	end if
	proccrop() of snippets
	procoptim()
	if optim is "0x0" then
		set optim to " "
		set thewidth to 512
		set theheight to 384
	else
		set optim to (" -s " & optim)
	end if
	
	
	--**Set the encoding variables**--
	--Basically, for earch category, check if there" & backslash  & ""s an advanced setting set, and use that instead of the default Easy Settings.		
	
	
	--Framerate. If the user knows better, great. If not, use ffmpeg and/or quicktime's guess, and compensate if necessary.
	if contents of text field "framerate" of advanced is "" then
		set fps to (do shell script "" & thequotedapppath & "/Contents/Resources/fpsfinder " & fullstarttime & " " & movfps & " " & ismov)
		if stitch is true and whichone is 1 then
			set contents of text field "framerate" of advanced to fps
		end if
	else
		set fps to (contents of text field "framerate" of advanced)
	end if
	set cons to ""
	
	audiogo() of snippets
	
	
	avislider()
	
	deinterlacer() of snippets
	
	if preview is true then
		set bframes to " "
	end if
	
	if threadscmd is " -threads 16 " then
		set threadscmd to " -threads 8 "
	end if
	
	set forceaspect to " "
	try
		set forceaspect to " -aspect " & getmult(thewidth, 2) of snippets & ":" & getmult(theheight, 2) of snippets & " "
	end try
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg" & threadscmd & forcepipe & " -i " & thequotedorigpath & threadder & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & forceaspect & vcodec & bframes & " -g 200 " & " " & " " & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
		set qmin to " -qmin 2 "
	else
		set passstring to " "
	end if
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
		end if
	end if
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & threadder & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & passstring & dashr & fps & forceaspect & vcodec & bframes & " -g 200 " & qmin & cons & " " & ffvideos & vol & " -async 50 " & extaudio & acodec & audstring & " " & ffaudios & " " & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & threadder & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & forceaspect & vcodec & bframes & " -g 200 " & qmin & cons & " " & ffvideos & vol & " -async 50 " & extaudio & acodec & audstring & " " & ffaudios & " " & " " & backslash & "$dir/" & thequotedfile & ".temp.avi ")
end mainstart

on mainend()
	--Finished.
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
	update window "ReduxZero"
	
	if stitch is true then
		set stitchstack to (stitchstack & outputfile)
		set newext to " "
		set moreend to ""
	else
		if vcodec is " -vcodec mjpeg " then
			easyend() of snippets
		else
			try
				set newext to (destpath & quoted form of filenoext) & fileext
				if (do shell script "/bin/test -f " & newext & " ; echo $?") is "0" then
					set moreend to fileext
					--		try
					--			if size of (info for POSIX file (do shell script "echo " & outputfile)) > 1.0E+9 then
					do shell script thequotedapppath & "/Contents/Resources/avimerge -i " & outputfile & " -o " & newext & fileext
					--			else
					do shell script "mv -n " & outputfile & " " & newext & fileext
					--			end if
					--		end try
				else
					--		try
					--			if size of (info for POSIX file (do shell script "echo " & outputfile)) > 1.0E+9 then
					do shell script thequotedapppath & "/Contents/Resources/avimerge -i " & outputfile & " -o " & newext
					--			else
					do shell script "mv -n " & outputfile & " " & newext
					--			end if
					--		end try
					set moreend to ""
				end if
				--	try
				do shell script "rm " & outputfile
				--	end try
			end try
		end if
	end if
end mainend

on avislider()
	if contents of text field "bitrate" of advanced is "" then
		set qmin to " -qmin 2 "
		if content of slider "quality" of avibox as number is 5 then
			--		if vcodec is " -vcodec msmpeg4v2 " then
			--			set qmin to " -qmin 2 "
			--		else
			--			set qmin to ""
			--		end if
			set thequalset to "50"
		end if
		if content of slider "quality" of avibox as number is 4 then
			set qmin to " -qmin 3 "
			set thequalset to "100"
		end if
		if content of slider "quality" of avibox as number is 3 then
			set qmin to " -qmin 5 "
			set thequalset to "150"
		end if
		if content of slider "quality" of avibox as number is 2 then
			set qmin to " -qmin 7 "
			set thequalset to "250"
		end if
		if content of slider "quality" of avibox as number is 1 then
			set qmin to " -qmin 9 "
			set thequalset to "350"
		end if
		if contents of popup button "divxprofile" of avibox is 4 then
			set wiimult to 2
		else
			set wiimult to 1
		end if
		set cons to " -b " & ((((round (thewidth * theheight) / thequalset) * wiimult)) as feet as string) & "k "
		if (((thewidth * theheight) / thequalset) * wiimult) > (3800 * wiimult) then
			set cons to " -b " & (3800 * wiimult) & "k "
		end if
		
		
		fit() of snippets
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
	end if
end avislider

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	if contents of text field "width" of advanced is "" then
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		if contents of button "320" of avibox is true then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " ipod nottiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		else
			if contents of button "divxprofileonoff" of avibox is true then
				set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & divxprof & " nottiny " & mpegaspect
				set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
				set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
			else
				if qtproc is true then
					set theorigwidth to origmovwidth
					set theorigheight to origmorzeight
				else
					set theorigheight to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $10}'")
					set theorigwidth to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur |  grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $9}'")
				end if
				set theheight to getmult((theorigheight - topcrop - bottomcrop), 2) of snippets
				set thewidth to getmult((theorigwidth - leftcrop - rightcrop), 2) of snippets
				if (ext is "vob" or ext is "mpg" or ext is "ts" or ext is "mpeg") and origPAR > 1.1 then
					set stretchwidth to getmult((theorigheight * origPAR), 16) of snippets
					set stretchratio to (stretchwidth / theorigwidth)
					set thewidth to getmult((thewidth * stretchratio), 2) of snippets
				end if
			end if
		end if
		set optim to ((getmult(thewidth, 2) of snippets & "x" & getmult(theheight, 2) of snippets) as string)
	else
		-- ...or use the user's settings.
		set thewidth to contents of text field "width" of advanced
		set theheight to contents of text field "height" of advanced
		set optim to ((thewidth & "x" & theheight) as string)
	end if
	if stitch is true and whichone is 1 then
		set contents of text field "width" of advanced to ((getmult(thewidth, 2))) of snippets
		set contents of text field "height" of advanced to ((getmult(theheight, 2))) of snippets
	end if
end procoptim

--  Created by Tyler Loch on 4/28/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.


--  Created by Tyler Loch on 5/1/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
