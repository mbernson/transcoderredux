-- wmv.applescript
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
global theRow
global theList
global backslash
global isrunning
global outputfile
global dashr
global vn
global vcodec
global normalnuller
global fullstarttime
global preview
global origmovwidth
global pass1ffmpegstring
global origmorzeight
global mpegaspect
global threadscmd
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
global wmvbox
global thewidth
global theheight
global qmin
global twopass
global colorspace
global ffmpegloc
global ext
global topcrop
global bottomcrop
global leftcrop
global rightcrop

on mainstart()
	
	
	set wmvbox to tab view item "wmvbox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".wmv"
	
	previewsetup() of snippets
	
	set vcodec to " -vcodec wmv2 -threads 1 -pix_fmt yuv420p "
	
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
	else
		set fps to (contents of text field "framerate" of advanced)
	end if
	set cons to ""
	
	audiogo() of snippets
	
	wmvslider()
	
	deinterlacer() of snippets
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & "  " & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & "  " & vcodec & " -g 15  " & " " & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
		set qmin to " -qmin 3 "
	else
		set passstring to " "
	end if
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
		end if
	end if
	
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & "  " & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & passstring & dashr & fps & "  " & vcodec & " -g 15  " & qmin & cons & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec wmav2 " & audstring & " " & ffaudios & " " & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & " " & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & "  " & vcodec & " -g 15  " & qmin & cons & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec wmav2 " & audstring & " " & ffaudios & " " & " " & backslash & "$dir/" & thequotedfile & ".temp.wmv ")
end mainstart

on mainend()
	easyend() of snippets
end mainend

on wmvslider()
	if contents of text field "bitrate" of advanced is "" then
		set qmin to " -qmin 3 "
		if content of slider "quality" of wmvbox as number is 5 then
			set qmin to " -qmin 3 "
			set thequalset to "60"
		end if
		if content of slider "quality" of wmvbox as number is 4 then
			set qmin to " -qmin 6 "
			set thequalset to "120"
		end if
		if content of slider "quality" of wmvbox as number is 3 then
			set qmin to " -qmin 7 "
			set thequalset to "175"
		end if
		if content of slider "quality" of wmvbox as number is 2 then
			set qmin to " -qmin 8 "
			set thequalset to "240"
		end if
		if content of slider "quality" of wmvbox as number is 1 then
			set qmin to " -qmin 9 "
			set cons to " -b 20k -maxrate 24k -bufsize 5k -g 30 "
			set audstring to " -ar 11025 -ac 1 -ab 24k "
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
		else
			set cons to " -b " & (((round (thewidth * theheight) / thequalset)) as feet as string) & "k "
		end if
		
		
		
		fit() of snippets
		if contents of button "fitonoff" of advanced is true then
			set qmin to " -qmin 3 "
		end if
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
		set qmin to " -qmin 3 "
	end if
end wmvslider

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	if contents of text field "width" of advanced is "" then
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		if contents of button "320" of wmvbox is true then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " ipod nottiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		end if
		if (content of slider "quality" of wmvbox as number) is 1 then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " ipod tiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		end if
		if (content of slider "quality" of wmvbox as number) > 1 and contents of button "320" of wmvbox is false then
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
end procoptim


--  Created by Tyler Loch on 5/1/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.

