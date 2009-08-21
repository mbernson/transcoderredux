-- mp4.applescript
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
global theFile2
global destpath
global ishack
global theRow
global theList
global isrunning
global outputfile
global dashr
global vn
global vcodec
global normalnuller
global theorigpath
global fullstarttime
global stitch
global mpegaspect
global backslash
global origheight
global origwidth
global origmovwidth
global origmorzeight
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
global ishack
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
global forceaspect
global serverfile
global serverinput
global streamer
global mp4box
global thewidth
global theheight
global qmin
global moreend
global newext
global twopass
global colorspace
global pass1ffmpegstring
global ffmpegloc
global preview
global ext
global topcrop
global bottomcrop
global leftcrop
global rightcrop
global isvideots

on mainstart()
	
	
	set mp4box to tab view item "mp4box" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".mp4"
	
	previewsetup() of snippets
	set vcodec to " -vcodec mpeg4 "
	set x264stuff to ""
	set ishack to false
	set bframes to " "
	if content of button "h264" of mp4box is true then
		set vcodec to " -vcodec h264 "
		if preview is false then
			set x264stuff to " -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 3  -qmax 51 "
			set ishack to true
			if content of button "hint" of mp4box is false then
				if isvideots is true and twopass is true then
					set bframes to " -level 41 "
				else
					set bframes to " -bf 1 -level 41 "
				end if
			end if
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
	set forceaspect to " "
	if ishack is true then
		set forceaspect to " -aspect " & getmult(thewidth, 2) of snippets & ":" & getmult(theheight, 2) of snippets & " "
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
	mp4slider()
	
	deinterlacer() of snippets
	
	
	try
		if fps is 16 or fps is 8 or fps is 4 or fps is 2 then
			set fps to ((fps as string) & ("01" as string))
		end if
		if fps is "2.00" then
			set fps to "ntsc-film"
		end if
	end try
	
	if "-refs 2" is in ffvideos then
		set bframes to " "
	end if
	
	if vcodec = " -vcodec h264 " then
		set pass1qmin to " -qmin 8 "
	else
		set pass1qmin to " "
		if threadscmd is " -threads 16 " then
			set threadscmd to " -threads 8 "
		end if
	end if
	
	if content of button "hint" of mp4box is true then
		set gop to " -g 50 "
	else
		set gop to " -g 200 "
	end if
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & "  " & vcodec & gop & pass1qmin & bframes & x264stuff & " " & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
		if vcodec = " -vcodec h264 " then
			set qmin to " -qmin 8 "
		else
			set qmin to " "
		end if
	else
		set passstring to " "
	end if
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
			set x264stuff to " "
		end if
	end if
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & forceaspect & passstring & dashr & fps & "  " & vcodec & gop & qmin & cons & bframes & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & " " & ffaudios & " " & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & forceaspect & dashr & fps & "  " & vcodec & gop & qmin & cons & bframes & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & " " & ffaudios & " " & " " & backslash & "$dir/" & thequotedfile & ".temp.mp4 ")
end mainstart

on mainend()
	set howbig to 0
	try
		set howbig to (do shell script "ls -ln " & outputfile & " | /usr/bin/awk '{print $5}'") as number
	end try
	if howbig < 3.9E+9 then
		mostipodend() of (load script file (POSIX file (thePath & "/Contents/Resources/Scripts/ipod.scpt")))
	else
		easyend() of snippets
	end if
end mainend

on mp4slider()
	if contents of text field "bitrate" of advanced is "" then
		if vcodec = " -vcodec h264 " then
			set qmin to " -qmin 8 "
		else
			set qmin to " -qmin 5 "
		end if
		if content of slider "quality" of mp4box as number is 5 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
				set thequalset to "100"
			else
				set qmin to ""
				set thequalset to "50"
			end if
		end if
		if content of slider "quality" of mp4box as number is 4 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 23 "
				set thequalset to "150"
			else
				set qmin to " -qmin 3 "
				set thequalset to "100"
			end if
		end if
		if content of slider "quality" of mp4box as number is 3 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 30 "
				set thequalset to "200"
			else
				set qmin to " -qmin 5 "
				set thequalset to "150"
			end if
		end if
		if content of slider "quality" of mp4box as number is 2 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 35 "
				set thequalset to "250"
			else
				set qmin to " -qmin 7 "
				set thequalset to "200"
			end if
		end if
		if content of slider "quality" of mp4box as number is 1 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 38 "
				set cons to " -b 32k -maxrate 40k -bufsize 5k -g 30 "
				set audstring to " -ar 11025 -ac 1 -ab 12k "
				try
					set fps to (fps / 3)
				on error
					if fps is "ntsc-film" then
						set fps to 8
					end if
					if fps is "film" then
						set fps to 8
					end if
					if fps is "ntsc" then
						set fps to 10
					end if
				end try
				set bframes to " "
			else
				set qmin to " -qmin 8 "
				set cons to " -b 32k -maxrate 40k -bufsize 5k -g " & fps & " "
				set audstring to " -ar 11025 -ac 1 -ab 12k "
				try
					set fps to (fps / 3)
				on error
					if fps is "ntsc-film" then
						set fps to 8
					end if
					if fps is "ntsc" then
						set fps to 10
					end if
				end try
			end if
		else
			set cons to " -b " & (((round (thewidth * theheight) / thequalset)) as feet as string) & "k "
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
			end if
		end if
		
		
		
		fit() of snippets
		
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
		if contents of text field "qmin" of advanced is not "" then
			set qmin to " -qmin " & (contents of text field "qmin" of advanced)
		else
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
			end if
		end if
	end if
end mp4slider

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	if contents of text field "width" of advanced is "" then
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		if contents of button "320" of mp4box is true then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " ipod nottiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		end if
		if (content of slider "quality" of mp4box as number) is 1 then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " ipod tiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		end if
		if (content of slider "quality" of mp4box as number) > 1 and contents of button "320" of mp4box is false then
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