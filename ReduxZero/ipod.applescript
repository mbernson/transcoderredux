-- ipod.applescript
-- ReduxZero

property presetall : 0
property presetipod5g : 1
property presetipodclassic : 2
property presetipodnano : 3
property presetipodtouch : 4
property presetiphone : 5
property presetappletv : 6
property presetappletv51 : 7
property presetappletv5120 : 8

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
global fullstarttime
global backslash
global theList
global isrunning
global outputfile
global dashr
global vn
global theorigpath
global vcodec
global normalnuller
global mpegaspect
global origmovwidth
global origmorzeight
global origheight
global threadscmd
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
global moreend
global newext
global stitchstack
global stitch
global twopass
global colorspace
global pass1ffmpegstring
global qmin
global mp4box
global ffmpegloc
global preview
global origoptim
global ishack
global thewidth
global theheight
global isvideots
global rawdvdaudiotrack

global isappletv2
global secondtrack
global secondtrackfile

on mainstart()
	
	set ishack to false
	set isappletv2 to false
	set moreaudios to " "
	set secondtrack to " "
	set secondtrackfile to " "
	set ipodbox to tab view item "ipodbox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".mp4"
	set vcodec to " -vcodec mpeg4 "
	--	if preview is false then
	if content of button "h264" of ipodbox is true then
		set vcodec to " -vcodec h264 "
	end if
	--	end if
	
	proccrop() of snippets
	procoptim()
	if optim is "0x0" then
		set optim to " "
		set thewidth to 512
		set theheight to 384
	else
		set optim to (" -s " & optim)
	end if
	
	if isappletv2 is true and preview is false then
		if rawdvdaudiotrack is "" then
			set searchfor to "head -1"
		else
			set searchfor to "grep -F " & quoted form of rawdvdaudiotrack
		end if
		--		display dialog "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Audio,' | grep -v parameters | " & searchfor & " | awk -F , '{print $9}'"
		set chans to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Audio,' | grep -v parameters | " & searchfor & " | awk -F , '{print $9}'")
		set acodec to (do shell script "cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep ',Audio,' | grep -v parameters | " & searchfor & " | awk -F , '{print $7}'")
		if acodec is "ac3" or (chans is "5.1" or "channels" is in chans) then
			--			if acodec is in {"mpeg4aac", "libdca", "ac3"} then
			if acodec is "ac3" or acodec is "mpeg4aac" then
				if isvideots is true then
					set moreaudios to " -ss 2 -acodec copy -atag ac-3 "
				else
					if acodec is "mpeg4aac" and qtproc is false then
						set moreaudios to " -acodec copy -atag mp4a "
					end if
					if acodec is "ac3" then
						set moreaudios to " -acodec copy -atag ac-3 "
					end if
				end if
				--	if acodec is "ac3" then
				--	set moreaudios to " -acodec copy -atag ac-3 "
				--		set newaudio to (destpath & thequotedfile & ".temp" & ".m4a")
				--	set secondtrack to " -vn -acodec libfaac -ac 2 -ab 128k -atag mp4a " & newaudio
				--	set secondtrack to " -atag mp4a -newaudio "
				
				if content of popup button "optim" of ipodbox is presetappletv5120 and acodec is "ac3" then
					--UNNECESSARY
					--	if rawdvdaudiotrack is "" then
					--		set track2map to " "
					--	else
					--		set track2map to " -map " & rawdvdaudiotrack & " "
					--	end if
					set secondtrack to " -acodec copy -f ac3 - " & ffaudios & " "
					set secondtrackfile to "/tmp/rztemp/" & fullstarttime & "/track2.m4a"
				end if
				--	else
				--		set moreaudios to " -async 0 -acodec ac3 -ac 6 -ab 384k -atag ac-3 "
				--	end if
				set fileext to ".mov"
			end if
		end if
	end if
	
	previewsetup() of snippets
	
	set x264stuff to " -maxrate 2400k -qmax 31 -bufsize 1221k "
	if preview is false then
		if content of button "h264" of ipodbox is true then
			if origoptim is "tv" or (origoptim is "iphone" and content of slider "quality" of ipodbox as number > 2) then
				set x264stuff to " -level 30 -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 2  -qmax 51 -maxrate 1450k -keyint_min 40 " ---bufsize 1221k "
				set ishack to true
			end if
			if origoptim is "appletv" or origoptim is "appletv30" then
				if isvideots is true and twopass is true then
					set x264stuff to " -level 31 -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 2  -qmax 51 -maxrate 4500k -keyint_min 40 " ---bufsize 4500k"
				else
					set x264stuff to " -level 31 -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 2  -qmax 51 -maxrate 4500k -bf 1 -keyint_min 40 " ---bufsize 4500k"
				end if
				set ishack to true
			end if
			if origoptim is "ipod" or (origoptim is "iphone" and content of slider "quality" of ipodbox as number < 3) then
				set x264stuff to " -level 13 -loop 1 -sc_threshold 40 -partp4x4 1 -rc_eq 'blurCplx^(1-qComp)' -refs 3  -qmax 51 -maxrate 700k -keyint_min 40 " --"
				set ishack to true
			end if
		end if
	end if
	
	set forceaspect to " "
	--	if ishack is true then
	try
		if "anantscdvd" is in ffvideos then
			set forceaspect to " -aspect 1.77 "
		else
			set forceaspect to " -aspect " & getmult(thewidth, 2) of snippets & ":" & getmult(theheight, 2) of snippets & " "
		end if
	end try
	--	end if
	
	--**Set the encoding variables**--
	--Basically, for earch category, check if there" & backslash  & ""s an advanced setting set, and use that instead of the default Easy Settings.		
	
	
	--Framerate. If the user knows better, great. If not, use ffmpeg and/or quicktime's guess, and compensate if necessary.
	if contents of text field "framerate" of advanced is "" then
		if stitch is true and whichone is 1 then
			set contents of text field "framerate" of advanced to "ntsc"
			set fps to "ntsc"
			if origoptim is "appletv" then
				set contents of text field "framerate" of advanced to "ntsc-film"
				set fps to "ntsc-film"
			end if
			if origoptim is "appletv30" then
				set contents of text field "framerate" of advanced to "ntsc"
				set fps to "ntsc"
			end if
			update advanced
		else
			set fps to (do shell script "" & thequotedapppath & "/Contents/Resources/fpsfinder " & fullstarttime & " " & movfps & " " & ismov)
			(*			try
				set fps to (fps as number)
			on error
				set fps to (do shell script "/bin/echo " & fps & " | /usr/bin/sed -e 's/" & backslash & "./,/g'") as number
			end try *)
			set lowalready to false
			try
				if fps < 16 then
					set lowalready to true
				end if
			end try
			try
				if (fps is 24 or fps is "24" or fps is "24.00" or fps is "24,00") and ("appletv" is not in origoptim) then
					set fps to "ntsc-film"
				end if
			end try
			if content of slider "quality" of ipodbox as number is 1 then
				if lowalready is false then
					try
						set fps to (fps / 2)
					on error
						if fps is "ntsc-film" then
							set fps to 12
						end if
						if fps is "ntsc" then
							set fps to 15
						end if
					end try
					try
						set movfps to (movfps / 2)
					end try
				end if
			end if
			if origoptim is "appletv" then
				try
					if fps as number is 25 then
						set fps to "pal"
					end if
					if fps as number > 25 then
						set fps to "ntsc-film"
					end if
				on error
					if fps is "ntsc" then
						set fps to "ntsc-film"
					end if
					if fps is "pal" then
						set fps to "pal"
					end if
				end try
			end if
			if origoptim is "appletv30" then
				try
					if fps as number > 30 then
						set fps to "ntsc"
					end if
				end try
			end if
		end if
	else
		set fps to (contents of text field "framerate" of advanced)
	end if
	set cons to ""
	
	
	--This will make the audio rate pulldown work. Channels should be here too.
	if content of slider "quality" of ipodbox as number is 1 then
		set type to "tiny"
	end if
	if (content of popup button "optim" of ipodbox is presetiphone and content of slider "quality" of ipodbox as number is 2) then
		set type to "tinyish"
	end if
	
	audiogo() of snippets
	
	if isappletv2 is true and content of popup button "optim" of ipodbox is presetappletv5120 and secondtrackfile is not " " then
		set normalend to " 2>> /tmp/rztemp/" & fullstarttime & "/reduxzero_time | " & ffmpegloc & "ffmpeg -y -f ac3 -i - -acodec libfaac " & audstring & " " & secondtrackfile & " ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working"
	end if
	
	--Bitrate settings. Again, go by the Easy Settings, then check for Advanced settings.
	if contents of text field "bitrate" of advanced is "" then
		if vcodec = " -vcodec h264 " then
			set cons to " -b 500k "
			set qmin to " -qmin 8 "
		else
			set cons to " -b 1000k "
			set qmin to " -qmin 5 "
		end if
		
		if content of slider "quality" of ipodbox as number is 5 then
			if vcodec = " -vcodec h264 " then
				if origoptim is "ipod" then
					set cons to " -b 700k "
				end if
				if origoptim is "tv" or origoptim is "iphone" then
					if content of popup button "optim" of ipodbox is in {presetipodclassic, presetipodnano, presetiphone, presetipodtouch} then
						set cons to " -b 2400k "
					else
						set cons to " -b 1400k "
					end if
				end if
				if origoptim is "appletv" or origoptim is "appletv30" then
					set cons to " -b 4500k "
					set bitcheck to 4500
				end if
				set qmin to " -qmin 8 "
			else
				set cons to " -b 2300k "
				set qmin to ""
			end if
		end if
		
		if content of slider "quality" of ipodbox as number is 4 then
			if vcodec = " -vcodec h264 " then
				if origoptim is "ipod" then
					set cons to " -b 620k "
				end if
				if origoptim is "tv" or origoptim is "iphone" then
					if content of popup button "optim" of ipodbox is in {presetipodclassic, presetipodnano, presetipodtouch} then
						set cons to " -b 1800k "
					else
						set cons to " -b 1200k "
					end if
				end if
				if origoptim is "appletv" or origoptim is "appletv30" then
					set cons to " -b 3750k "
					set bitcheck to 3750
				end if
				set qmin to " -qmin 20 "
			else
				set cons to " -b 2000k "
				set qmin to " -qmin 3 "
			end if
		end if
		
		if content of slider "quality" of ipodbox as number is 3 then
			if vcodec = " -vcodec h264 " then
				if origoptim is "ipod" then
					set cons to " -b 560k "
				end if
				if origoptim is "tv" or origoptim is "iphone" then
					set cons to " -b 1000k "
				end if
				if origoptim is "appletv" or origoptim is "appletv30" then
					set cons to " -b 2500k "
					set bitcheck to 2500
				end if
				set qmin to " -qmin 25 "
			else
				set cons to " -b 1200k "
				set qmin to " -qmin 5 "
			end if
		end if
		
		if content of slider "quality" of ipodbox as number is 2 then
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 32 "
				if origoptim is "ipod" then
					set cons to " -b 275k "
				end if
				if origoptim is "iphone" then
					if content of popup button "optim" of ipodbox is presetiphone then
						set cons to " -b 150k -g 100 "
						set qmin to " -qmin 24 "
					else
						set cons to " -b 600k "
						set qmin to " -qmin 26 "
					end if
				end if
				if origoptim is "tv" then
					set cons to " -b 600k "
				end if
				if origoptim is "appletv" or origoptim is "appletv30" then
					set cons to " -b 1500k "
					set bitcheck to 1500
				end if
			else
				set cons to " -b 700k "
				set qmin to " -qmin 8 "
				if origoptim is "iphone" and content of popup button "optim" of ipodbox is presetiphone then
					set cons to " -b 150k -g 100 "
					set qmin to " -qmin 4 "
				end if
			end if
		end if
		
		if content of slider "quality" of ipodbox as number is 1 then
			if vcodec = " -vcodec h264 " then
				if origoptim is "ipod" then
					set cons to " -b 150k "
				end if
				if origoptim is "tv" then
					set cons to " -b 300k "
				end if
				if origoptim is "iphone" then
					if content of popup button "optim" of ipodbox is presetiphone then
						set cons to " -b 60k -maxrate 64k -bufsize 64k -g 100 "
						set qmin to " -qmin 22 "
					else
						set cons to " -b 300k "
					end if
				end if
				if origoptim is "appletv" or origoptim is "appletv30" then
					set cons to " -b 500k "
					set bitcheck to 500
				end if
				set qmin to " -qmin 29 "
			else
				set cons to " -b 500k "
				set qmin to " -qmin 7 "
				if origoptim is "iphone" and content of popup button "optim" of ipodbox is presetiphone then
					set cons to " -b 64k -maxrate 70k -bufsize 70k -g 100 "
					set qmin to " -qmin 6 "
				end if
			end if
		end if
		fit() of snippets
		
	else
		set bitrate to contents of text field "bitrate" of advanced
		set cons to " -b " & bitrate & "k "
		if (contents of text field "qmin" of advanced) is not "" then
			set qmin to (" -qmin " & (contents of text field "qmin" of advanced))
		else
			if vcodec = " -vcodec h264 " then
				set qmin to " -qmin 8 "
			end if
		end if
	end if
	
	-- not required for Apple TV 2.0, but tagging still does
	try
		--SPECIAL FIT
		if (origoptim is "appletv" or origoptim is "appletv30") and isappletv2 is false then
			set filedur to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration") as number
			if (filedur * (bitcheck / 8000)) > 4000 then
				--SSSPPPPPEEEEECCCCCIIIIIAAAALL FFFFIIIIIT
				set filedur to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_duration") as number
				set filekbits to 4000
				set bitratework1 to ((filekbits * 8000) / filedur)
				set text item delimiters to " "
				set ab to (last text item of audstring)
				set text item delimiters to "k"
				set bitrate to (round (bitratework1 - (first text item of ab)) rounding down)
				set cons to " -b " & bitrate & "k "
				set qmin to " -qmin 8 "
			end if
		end if
	end try
	
	deinterlacer() of snippets
	
	
	if fps is 16 or fps is 8 or fps is 4 or fps is 2 then
		set fps to ((fps as string) & ("01" as string))
	end if
	
	if preview is true then
		if content of button "prevcomp" of window "preview" is false then
			set cons to " "
			set qmin to " "
			set x264stuff to " "
		end if
	end if
	
	if vcodec = " -vcodec h264 " then
		set pass1qmin to " -qmin 8 "
	else
		set pass1qmin to " "
		if threadscmd is " -threads 16 " then
			set threadscmd to " -threads 8 "
		end if
	end if
	
	set pass1ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & dashr & fps & "  " & vcodec & " -g 150 " & x264stuff & pass1qmin & ffvideos & " -async 50 -an -pass 1 -passlogfile /tmp/rztemp/" & fullstarttime & "/reduxzero_passlog -f rawvideo - > /dev/null 2> /dev/null  ; echo done > /tmp/rztemp/" & fullstarttime & "/reduxzero_working ")
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
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & forceaspect & passstring & dashr & fps & "  " & vcodec & " -g 150 " & qmin & cons & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & moreaudios & ffaudios & " " & previewstring & outputfile & secondtrack & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & colorspace & deinterlace & croptop & cropbottom & cropleft & cropright & optim & forceaspect & dashr & fps & "  " & vcodec & " -g 150 " & qmin & cons & x264stuff & " " & ffvideos & vol & " -async 50 " & extaudio & " -acodec libfaac " & audstring & moreaudios & ffaudios & " " & " " & backslash & "$dir/" & thequotedfile & ".temp.mp4 ")
end mainstart



on mainend()
	set type to "ipodbox"
	set howbig to 0
	try
		set howbig to (do shell script "ls -ln " & outputfile & " | /usr/bin/awk '{print $5}'") as number
	end try
	if ((howbig < 150000000) or contents of default entry "alwaysfaststart" of user defaults is "true") and isappletv2 is false then
		-- (contents of default entry "itunesfaststart" of user defaults as string is "true") and
		mostipodend()
	else
		if isappletv2 is true and content of popup button "optim" of ipodbox is presetappletv5120 and secondtrackfile is not " " then
			--Finished.
			set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
			update window "ReduxZero"
			
			if stitch is true then
				set stitchstack to (stitchstack & outputfile)
				set newext to " "
				set moreend to ""
			else
				try
					do shell script thequotedapppath & "/Contents/Resources/disabler " & outputfile & " " & secondtrackfile & " " & destpath & starttime & ".temp.mov ; exit 0"
					--	do shell script "mv -n " & outputfile & " " & newext & fileext
				end try
				
				set newext to (destpath & quoted form of filenoext) & fileext
				if (do shell script "/bin/test -f " & newext & " ; echo $?") is "0" then
					set moreend to fileext
				else
					set moreend to ""
				end if
				
				try
					do shell script "mv -n " & destpath & starttime & ".temp.mov " & newext & moreend
				end try
				
				if (do shell script "/bin/test -f " & newext & moreend & " ; echo $?") is "0" then
					try
						do shell script "rm " & outputfile
					end try
				end if
			end if
		else
			easyend() of snippets
		end if
	end if
	--Do the iTunes voodoo that we do, or just say it's done.	
	--Add like thunder!
	if content of button "autoadd" of ipodbox is true and stitch is false then
		try
			--	display dialog newext & moreend
			set itunesfile to (do shell script "echo " & newext & moreend & "") as POSIX file
			
			
			
			--	try
			--	do shell script "osascript -e 'tell application \"iTunes\" to add \"" & itunesfile & "\" '&> /dev/null &"
			--	on error
			--		try
			tell application "iTunes" to add itunesfile
			--		end try
			--	end try
			
			
			--do shell script "/usr/bin/open -a /Applications/iTunes.app " & newext & moreend
		end try
	end if
end mainend

on mostipodend()
	--Finished.
	set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
	update window "ReduxZero"
	set moreend to ""
	if stitch is true then
		set stitchstack to (stitchstack & outputfile)
		set newext to " "
	else
		set newext to (destpath & (quoted form of filenoext)) & fileext
		--	try
		if type is "mp4box" then
			if content of button "hint" of tab view item "mp4box" of tab view "tabbox" of window "ReduxZero" is true then
				do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4stream --exporter=mpg4 " & outputfile & " " & destpath & starttime & ".temp.mp4 > /dev/null 2>&1 ; exit 0"
			else
				
				do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 " & outputfile & " " & destpath & starttime & ".temp.mp4 > /dev/null 2>&1 ; exit 0"
			end if
		else
			if (content of popup button "optim" of ipodbox is presetiphone and content of slider "quality" of ipodbox as number < 3) then
				do shell script thequotedapppath & "/Contents/Resources/qt_export --loadsettings=" & thequotedapppath & "/Contents/Resources/mp4pass --exporter=mpg4 " & outputfile & " " & destpath & starttime & ".temp.mp4 > /dev/null 2>&1 ; exit 0"
			else
				do shell script thequotedapppath & "/Contents/Resources/AtomicParsley " & outputfile & " --encodingTool 'ReduxZero 1.34' -o " & destpath & starttime & ".temp.mp4 > /dev/null 2>&1 ; exit 0"
			end if
		end if
		--	end try
		try
			if (do shell script "/bin/test -f " & newext & " ; echo $?") is "0" then
				do shell script "mv -n " & destpath & starttime & ".temp.mp4 " & newext & fileext
				set moreend to fileext
			else
				do shell script "mv -n " & destpath & starttime & ".temp.mp4 " & newext
				set moreend to ""
			end if
		end try
		if (do shell script "/bin/test -f " & newext & moreend & " ; echo $?") is "0" then
			set howbig to (do shell script "ls -ln " & newext & moreend & " | /usr/bin/awk '{print $5}'") as number
			try
				if (howbig > 100) then
					do shell script "/bin/rm " & outputfile
				else
					do shell script "/bin/rm " & newext & moreend
				end if
			end try
		end if
	end if
	--	try
	--		do shell script "rm /x264_2pass.log"
	--	end try
end mostipodend

on procoptim()
	--Set either iPod or TV size, and figure out the ratio/size of the finished product.
	set origoptim to "ipod"
	set figurewidth to 321
	set figureheight to 241
	try
		if contents of text field "width" of advanced is "" then
			if qtproc is true then
				set figurewidth to origmovwidth as number
			else
				set figurewidth to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur |  grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $9}'") as number
				set figureheight to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur |  grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $10}'") as number
			end if
		else
			set figurewidth to (contents of text field "width" of advanced) as number
		end if
		--		display dialog figurewidth
		--	display dialog (content of cell "optim1" of matrix "optim" of ipodbox as string)
	end try
	
	
	if (figurewidth > 320) then
		if (content of popup button "optim" of ipodbox is not in {presetipodclassic, presetipodnano, presetipod5g}) then
			set origoptim to "tv"
		else
			if content of slider "quality" of ipodbox as number > 3 then
				set origoptim to "tv"
			end if
		end if
	end if
	
	
	
	--	try
	--	if (content of popup button "optim" of ipodbox is 4 or content of popup button "optim" of ipodbox is 7 or content of popup button "optim" of ipodbox is 8) and (figurewidth > 640 or figureheight > 480) then
	if ((content of popup button "optim" of ipodbox is presetappletv) and (figurewidth > 640 or figureheight > 480)) or (content of popup button "optim" of ipodbox is presetappletv51 or content of popup button "optim" of ipodbox is presetappletv5120) then
		--	display dialog "appletv"
		--		if thewidth < 1281 then
		
		if content of popup button "optim" of ipodbox is presetappletv51 or content of popup button "optim" of ipodbox is presetappletv5120 then
			set isappletv2 to true
		end if
		
		set origoptim to "appletv"
		if contents of text field "framerate" of advanced is "" then
			set atvfps to (do shell script "" & thequotedapppath & "/Contents/Resources/fpsfinder " & fullstarttime & " " & movfps & " " & ismov)
		else
			set atvfps to contents of text field "framerate" of advanced
		end if
		
		try
			try
				set atvfps to (atvfps as number)
			on error
				set atvfps to (do shell script "/bin/echo " & atvfps & " | /usr/bin/sed -e 's/" & backslash & "./,/g'") as number
			end try
		on error
			if atvfps is "ntsc" then
				set atvfps2 to 30
			end if
			if atvfps is "ntsc-film" then
				set atvfps2 to 23.976
			end if
			if atvfps is "film" then
				set atvfps2 to 24
			end if
			if atvfps is "pal" then
				set atvfps2 to 25
			end if
			try
				set atvfps to atvfps2
			on error
				set atvfps to 24
			end try
		end try
		
		try
			if atvfps as number > 25 then
				set origoptim to "appletv30"
			end if
		on error
			if atvfps is "ntsc" then
				set origoptim to "appletv30"
			end if
		end try
		
		set content of button "h264" of ipodbox to true
		set vcodec to " -vcodec h264 "
		update window "ReduxZero"
		--		else
		--			set origoptim to "720p"
		--		end if
	end if
	
	if (content of popup button "optim" of ipodbox is presetiphone or content of popup button "optim" of ipodbox is presetipodtouch) and (figurewidth > 320 or content of slider "quality" of ipodbox as number < 3) then
		set origoptim to "iphone"
		if (figurewidth > 320) and (content of slider "quality" of ipodbox as number > 3) then
			set origoptim to "tv"
		end if
	end if
	
	
	--	end try
	if contents of text field "width" of advanced is "" then
		(*		if origoptim is "appletv" or origoptim is "appletv30" then
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
			
		else *)
		--		if vcodec = " -vcodec h264 " then
		--			set origoptim to "ipod"
		--		end if
		if content of slider "quality" of ipodbox as number is 1 then
			set tiny to "tiny"
		else if (content of popup button "optim" of ipodbox is presetiphone and content of slider "quality" of ipodbox as number is 2) then
			set tiny to "tinyish"
		else
			set tiny to "nottiny"
		end if
		if vcodec = " -vcodec h264 " and origoptim is "tv" and content of popup button "optim" of ipodbox is not in {presetipodclassic, presetipodnano, presetiphone, presetipodtouch} then --(content of popup button "optim" of ipodbox is not 2 and content of popup button "optim" of ipodbox is not 3 and content of popup button "optim" of ipodbox is not 5 and content of popup button "optim" of ipodbox is not 6) then
			set tiny to "h264"
		end if
		--set {thewidth, theheight, theAR, thePAR, thecropleft, thecropright, thecroptop, thecropbottom} to sizer(origwidth, origheight, origAR, origPAR, 320, 0, 0, 1, 16) of snippets
		--tell application "Terminal" to do script "sh -x " & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & origoptim & " " & tiny & " " & mpegaspect
		set optim to do shell script "" & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & origoptim & " " & tiny & " " & mpegaspect
		set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
		set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}'")
		set optim to ((getmult(thewidth, 2) of snippets & "x" & getmult(theheight, 2) of snippets) as string)
		--		end if
		if stitch is true and whichone is 1 then
			set contents of text field "width" of advanced to ((getmult(thewidth, 2))) of snippets
			set contents of text field "height" of advanced to ((getmult(theheight, 2))) of snippets
		end if
	else
		-- ...or use the user's settings.
		--	set origoptim to "tv"
		set thewidth to contents of text field "width" of advanced
		set theheight to contents of text field "height" of advanced
		set optim to ((thewidth & "x" & theheight) as string)
	end if
end procoptim

--on clicked theObject
--	display alert (localized string "advanced")
--	show window "advanced"
--end clicked

--  Created by Tyler Loch on 3/26/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.


