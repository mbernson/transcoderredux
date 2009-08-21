-- mpeg.applescript
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
global backslash
global destpath
global theRow
global theList
global isrunning
global origmovwidth
global origmorzeight
global outputfile
global stitch
global dashr
global fullstarttime
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
global mpegbox
global thewidth
global theheight
global qmin
global moreend
global newext
global mpegbox
global mpegtype
global fps2
global twopass
global colorspace
global pass1ffmpegstring
global ffmpegloc
global preview
global mpegprofilewhat
global ext
global maxrate
global istivo
global forceaud
global topcrop
global bottomcrop
global leftcrop
global rightcrop

global bitnum

on mainstart()
	
	set mpegbox to tab view item "mpegbox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".mpg"
	set istivo to false
	set maxrate to " "
	set forceaud to " "
	
	previewsetup() of snippets
	
	set vcodec to " -vcodec mpeg1video "
	set acodec to " -acodec mp2 "
	set vobber to " "
	if threadscmd is " -threads 16 " then
		set threadscmd to " -threads 8 "
	end if
	if content of button "mpeg2" of mpegbox is true then
		set vcodec to threadscmd & "-vcodec mpeg2video "
		set vobber to " -f vob "
	end if
	proccrop() of snippets
	
	
	set format to "mpegntsc"
	set mpegtype to "ntsc"
	if content of cell "pal" of matrix "format" of mpegbox is true then
		set format to "mpegpal"
		set mpegtype to "pal"
	end if
	set proftype to "norm"
	
	
	
	--**Set the encoding variables**--
	--Basically, for earch category, check if there" & backslash  & ""s an advanced setting set, and use that instead of the default Easy Settings.	
	set fps to mpegtype
	
	set bframes to " "
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set bframes to " "
		end if
	else
		set bframes to " -bf 2 "
	end if
	
	--	set cons to " -aspect 1:1 "
	set cons to ""
	
	if contents of button "mpegprofileonoff" of mpegbox is true then
		set mpegprofilewhat to (get contents of popup button "mpegprofile" of mpegbox)
		if mpegprofilewhat is 0 then
			set cons to " -target " & mpegtype & "-vcd -aspect 4:3 "
			set qmin to " -qmin 2 "
			set vcodec to ""
			set audstring to " "
			set proftype to "vcd"
			set type to "vcd"
			set format to (mpegtype & "vcd")
			set forceaud to " -ar 44100 "
		end if
		if mpegprofilewhat is 1 then
			set cons to " -target " & mpegtype & "-svcd -aspect 4:3 "
			set qmin to ""
			set vcodec to ""
			set audstring to " "
			set type to "svcd"
			set proftype to "svcd"
			set vobber to " -f vob "
			set format to (mpegtype & "svcd")
			set forceaud to " -ar 48000 "
		end if
		if mpegprofilewhat is 2 then
			set proftype to "cvd"
			set format to (mpegtype & "dvdsmall")
			set vobber to " -f vob "
			set forceaud to " -ar 48000 "
			set cons to ""
		end if
		if mpegprofilewhat is 3 then
			set proftype to "tivo"
			set vobber to " -f vob "
			set istivo to true
			if content of slider "quality" of mpegbox as number is 5 then
				set format to "ntscdvd"
			end if
			if content of slider "quality" of mpegbox as number is 4 then
				set format to "tivohigh"
			end if
			if content of slider "quality" of mpegbox as number is 3 then
				set format to "tivohigh"
			end if
			if content of slider "quality" of mpegbox as number is 2 then
				set format to "ntscsvcd"
			end if
			if content of slider "quality" of mpegbox as number is 1 then
				set format to "ntscdvdsmall"
			end if
			set forceaud to " -ar 48000 "
		end if
		--		if mpegprofilewhat is 4 then
		--			set proftype to "wmc"
		--			set format to (mpegtype & "dvd")
		--			set fileext to ".dvr-ms"
		--			set vobber to " -f asf "
		--		end if
		if mpegprofilewhat is 4 then
			set proftype to "ts"
			set acodec to " -acodec ac3 "
			--set format to (mpegtype & "dvdsmall")
			set fileext to ".ts"
			set vobber to " -f mpegts "
			set forceaud to " -ar 48000 "
		end if
		if mpegprofilewhat is 5 then
			set cons to ""
			set proftype to "720p"
			set acodec to " -acodec ac3 "
			set format to "720p"
			set vobber to " -f mpegts "
			set qmin to " "
			set fileext to ".m2t"
			set maxrate to " -b 18000k -minrate 18000k -maxrate 18000k -bufsize 2048k -level 4 -profile 4 " --bt 1
			if mpegtype is "pal" then
				set fps to 50
			else
				set fps to "59.94"
			end if
			set bframes to " "
			set forceaud to " -ar 48000 -ab 192k -ac 2 "
		end if
		if mpegprofilewhat is 6 then
			set cons to ""
			set proftype to "1080"
			set acodec to " -acodec ac3 "
			set format to "1080"
			set qmin to " "
			set vobber to " -f mpegts "
			set fileext to ".m2t"
			set maxrate to " -b 18000k -minrate 18000k -maxrate 18000k -bufsize 2048k -ilme -ildct -level 4 -profile 4 " --bt 1
			--set fps to 30
			set bframes to " "
			set forceaud to " -ar 48000 -ab 192k -ac 2  "
		end if
		
	else
		--Framerate. If the user knows better, great. If not, use ffmpeg and/or quicktime's guess, and compensate if necessary.
		if contents of text field "framerate" of advanced is not "" then
			set fps to (contents of text field "framerate" of advanced)
		end if
		set mpegprofilewhat to -1
	end if
	
	procoptim()
	if optim is "0x0" then
		set optim to " "
		set thewidth to 512
		set theheight to 384
	else
		set optim to (" -s " & optim)
	end if
	
	audiogo() of snippets
	
	
	mpegslider()
	
	deinterlacer() of snippets
	
	if mpegprofilewhat > 4 then
		set qmin to " "
	end if
	if vcodec is " -vcodec mpeg1video " then
		set qmin to " -qmin 2 "
		try
			if mpegprofilewhat is -1 then
				set cons to (cons & " -aspect " & thewidth & ":" & theheight & " -maxrate " & (bitnum * 2) & "k -bufsize " & ((bitnum / 3) as integer) & "k ")
			end if
		end try
	end if
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & cons & optim & maxrate & dashr & fps & "  " & vcodec & " -g 15 " & bframes & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
	if twopass is true and preview is false then
		set passstring to " -pass 2 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog "
		set qmin to " "
	else
		set passstring to " "
	end if
	if preview is true then
		set cons to " "
		set qmin to " "
	end if
	
	
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & cons & optim & maxrate & passstring & dashr & fps & "  " & vcodec & " -g 15 " & qmin & bframes & ffvideos & vol & " -async 50 " & extaudio & acodec & audstring & forceaud & ffaudios & vobber & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & cons & optim & maxrate & dashr & fps & "  " & vcodec & " -g 15 " & qmin & bframes & ffvideos & vol & " -async 50 " & extaudio & acodec & audstring & forceaud & ffaudios & vobber & " " & backslash & "$dir/" & thequotedfile & ".temp.mpg ")
end mainstart

on mainend()
	set type to "mpegbox"
	easyend() of snippets
end mainend

on mpegslider()
	if contents of text field "bitrate" of advanced is "" then
		set qmin to " -qmin 5 "
		if content of slider "quality" of mpegbox as number is 5 then
			set qmin to ""
			set thequalset to "30"
		end if
		if content of slider "quality" of mpegbox as number is 4 then
			set qmin to " -qmin 3 "
			set thequalset to "70"
		end if
		if content of slider "quality" of mpegbox as number is 3 then
			set qmin to " -qmin 5 "
			set thequalset to "100"
		end if
		if content of slider "quality" of mpegbox as number is 2 then
			set qmin to " -qmin 7 "
			set thequalset to "150"
		end if
		if content of slider "quality" of mpegbox as number is 1 then
			set thequalset to "250"
			if contents of button "mpegprofileonoff" of mpegbox is false then
				set qmin to " -qmin 8 "
				set cons to " -b 384k -g " & fps & " "
				set audstring to " -ar 22050 -ac 1 -ab 32k "
			end if
		end if
		--	if contents of button "mpegprofileonoff" of mpegbox is true then
		if mpegprofilewhat is not 0 then
			set bitnum to (round ((thewidth * theheight) / thequalset))
			if bitnum > 18500 and mpegprofilewhat > 4 then
				set bitnum to 18500 as feet as string
			end if
			set cons to " -b " & (bitnum as feet as string) & "k "
		end if
		--	end if
		
		
		fit() of snippets
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
		if contents of text field "qmin" of advanced is not "" then
			set qmin to (" -qmin " & contents of text field "qmin" of advanced)
		else
			set qmin to " "
		end if
	end if
end mpegslider

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	if contents of text field "width" of advanced is "" then
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		if contents of button "mpegprofileonoff" of mpegbox is true then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & format & " nottiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}' | awk '{print $1}'")
		end if
		if (content of slider "quality" of mpegbox as number) is 1 then
			set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder  " & fullstarttime & " " & format & "  tiny " & mpegaspect
			set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
			set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}' | awk '{print $1}'")
		end if
		if (content of slider "quality" of mpegbox as number) > 1 and contents of button "mpegprofileonoff" of mpegbox is false then
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
			set optim to ((getmult(thewidth, 2) of snippets & "x" & getmult(theheight, 2) of snippets) as string)
		end if
		if contents of button "mpegprofileonoff" of mpegbox is false and mpegprofilewhat is not 1 then
			set optim to ((getmult(thewidth, 2) of snippets & "x" & getmult(theheight, 2) of snippets) as string)
		end if
	else
		-- ...or use the user's settings.
		set thewidth to contents of text field "width" of advanced
		set theheight to contents of text field "height" of advanced
		set optim to ((thewidth & "x" & theheight) as string)
	end if
	if stitch is true and whichone is 1 and istivo is false then
		set contents of text field "width" of advanced to ((getmult(thewidth, 2))) of snippets
		set contents of text field "height" of advanced to ((getmult(theheight, 2))) of snippets
	end if
end procoptim

--  Created by Tyler Loch on 4/28/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.

