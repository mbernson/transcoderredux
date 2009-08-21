-- psp.applescript
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
global isrunning
global outputfile
global dashr
global vn
global vcodec
global threadscmd
global fullstarttime
global backslash
global normalnuller
global origmovwidth
global origmorzeight
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
global pspbox
global thewidth
global theheight
global qmin
global moreend
global newext
global pspbox
global twopass
global colorspace
global pass1ffmpegstring
global ffmpegloc
global preview
global thumbfile

on mainstart()
	
	
	set pspbox to tab view item "pspbox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".MP4"
	set prefix to "M4V"
	previewsetup() of snippets
	
	set vcodec to " -vcodec mpeg4 "
	set x264stuff to ""
	if content of button "h264" of pspbox is true then
		set vcodec to " -vcodec h264 "
		if preview is true then
			set bframes to " "
		else
			set bframes to " -bf 1 "
		end if
		if preview is false then
			set x264stuff to " -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 1 -coder 1 -level 21 -qmax 51 " & bframes
		else
			set x264stuff to " "
		end if
		set prefix to "MAQ"
		set type to "pspavcbox"
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
		if content of cell "optim2" of matrix "optim" of pspbox is true then
			set fps to (do shell script "" & thequotedapppath & "/Contents/Resources/fpsfinder " & fullstarttime & " " & movfps & " " & ismov)
		else
			set fps to "ntsc"
		end if
	else
		set fps to (contents of text field "framerate" of advanced)
	end if
	set cons to ""
	
	audiogo() of snippets
	
	pspslider()
	
	deinterlacer() of snippets
	
	
	if fps is 16 or fps is 8 or fps is 4 or fps is 2 then
		set fps to ((fps as string) & ("01" as string))
	end if
	set psptitle to contents of text field "psptitle" of box "pspadvbox" of advanced
	if psptitle is not "" then
		if howmany > 1 then
			set pspnum to whichone
		else
			set pspnum to ""
		end if
		set thetitle to (quoted form of psptitle) & pspnum
	else
		set thetitle to (quoted form of filenoext)
	end if
	
	if vcodec is " -vcodec mpeg4 " then
		if threadscmd is " -threads 16 " then
			set threadscmd to " -threads 8 "
		end if
	end if
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & " -r " & fps & "  " & vcodec & " -g 300 " & " " & x264stuff & " " & ffvideos & " -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
		set qmin to " "
	else
		set passstring to " "
	end if
	set forcer to " "
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
		end if
	else
		set forcer to " -f psp "
	end if
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & " -title " & thetitle & optim & passstring & " -r " & fps & "  " & vcodec & " -g 300 " & qmin & cons & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & " " & ffaudios & forcer & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & " -title " & thetitle & optim & " -r " & fps & "  " & vcodec & " -g 300 " & qmin & cons & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & " " & ffaudios & " -f psp " & " " & backslash & "$dir/" & thequotedfile & ".temp.mp4 ")
end mainstart

on mainend()
	--Finished.
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
	update window "ReduxZero"
	
	if content of cell "optim2" of matrix "optim" of pspbox is true then
		easyend() of snippets
		try
			if content of button "thumb" of pspbox is true then
				set prevsec to (contents of text field "prevsec" of window "Preview")
				set thumbfile to ((destpath & quoted form of filenoext) & ".jpg")
				do shell script "" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & " -an -s 72x54 -ss " & prevsec & " -vframes 1 -f image2 " & thumbfile
			end if
		end try
	else
		set prefix to "M4V"
		if content of button "h264" of pspbox is true then
			set prefix to "MAQ"
		end if
		set randnum to (do shell script "echo $RANDOM$RANDOM$RANDOM$RANDOM$RANDOM | cut -c 1-5")
		
		set newext to (destpath & prefix & randnum & fileext)
		set moreend to ""
		try
			do shell script "mv " & outputfile & " " & newext
		end try
		try
			if content of button "thumb" of pspbox is true then
				set prevsec to (contents of text field "prevsec" of window "Preview")
				set thumbfile to (destpath & prefix & randnum & ".THM")
				do shell script "" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & " -an -s 72x54 -ss " & prevsec & " -vframes 1 -f image2 " & thumbfile
			end if
		end try
	end if
end mainend

on pspslider()
	if contents of text field "bitrate" of advanced is "" then
		if vcodec = " -vcodec h264 " then
			set cons to " -b 500k "
			set qmin to " -qmin 8 "
		else
			set cons to " -b 600k "
			set qmin to " -qmin 5 "
		end if
		if content of slider "quality" of pspbox as number is 5 then
			if vcodec = " -vcodec h264 " then
				if content of cell "optim2" of matrix "optim" of pspbox is true then
					set cons to " -b 1400k "
					set qmin to " -qmin 8 "
				else
					set cons to " -b 700k "
					set qmin to " -qmin 8 "
				end if
			else
				set cons to " -b 700k "
				set qmin to ""
			end if
		end if
		if content of slider "quality" of pspbox as number is 4 then
			if vcodec = " -vcodec h264 " then
				if content of cell "optim2" of matrix "optim" of pspbox is true then
					set cons to " -b 1200k "
				else
					set cons to " -b 600k "
				end if
				set qmin to " -qmin 23 "
			else
				set cons to " -b 600k "
				set qmin to " -qmin 3 "
			end if
		end if
		if content of slider "quality" of pspbox as number is 3 then
			if vcodec = " -vcodec h264 " then
				if content of cell "optim2" of matrix "optim" of pspbox is true then
					set cons to " -b 900k "
				else
					set cons to "-b 400k "
				end if
				set qmin to " -qmin 27 "
			else
				set cons to " -b 500k "
				set qmin to " -qmin 5 "
			end if
		end if
		if content of slider "quality" of pspbox as number is 2 then
			if vcodec = " -vcodec h264 " then
				if content of cell "optim2" of matrix "optim" of pspbox is true then
					set cons to " -b 600k "
				else
					set cons to " -b 275k "
				end if
				set qmin to " -qmin 31 "
			else
				set cons to " -b 400k "
				set qmin to " -qmin 8 "
			end if
		end if
		if content of slider "quality" of pspbox as number is 1 then
			if vcodec = " -vcodec h264 " then
				if content of cell "optim2" of matrix "optim" of pspbox is true then
					set cons to " -b 300k "
				else
					set cons to " -b 150k "
				end if
				set qmin to " -qmin 29 "
			else
				set cons to " -b 250k "
				set qmin to " -qmin 7 "
			end if
		end if
		fit() of snippets
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
		if contents of text field "qmin" of advanced is not "" then
			set qmin to contents of text field "qmin" of advanced
		else
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
			end if
		end if
	end if
	
end pspslider

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	if contents of text field "width" of advanced is "" then
		if content of cell "optim2" of matrix "optim" of pspbox is true then
			set origoptim to "psp330"
		else
			set origoptim to "psp"
		end if
		set wide to "notwide"
		if content of slider "quality" of pspbox as number is 1 then
			set tiny to "tiny"
		else
			set tiny to "nottiny"
		end if
		
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		
		set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & origoptim & " " & tiny & " " & mpegaspect
		set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
		set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		--		set optim to ((getmult(thewidth, 2) of snippets & "x" & getmult(theheight, 2) of snippets) as string)
		set optim to ((thewidth & "x" & theheight) as string)
	else
		-- ...or use the user's settings.
		set thewidth to contents of text field "width" of advanced
		set theheight to contents of text field "height" of advanced
		set optim to ((thewidth & "x" & theheight) as string)
	end if
end procoptim

--  Created by Tyler Loch on 4/28/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
