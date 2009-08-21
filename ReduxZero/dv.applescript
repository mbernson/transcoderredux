-- dv.applescript
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
global theRow
global theList
global fullstarttime
global isrunning
global outputfile
global dashr
global vn
global vcodec
global backslash
global normalnuller
global mpegaspect
global origheight
global origwidth
global extaudio
global extaudiofile
global threadscmd
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
global ffmpegstring
global format
global widescreen
global previewstring
global previewpic
global xgridffmpegstring
global origAR
global origPAR
global thePath
global filenoext
global ffvideos
global ffaudios
global xpipe
global thequotedfile
global fileext
global vol
global serverfile
global serverinput
global colorspace
global ffmpegloc
global ext
global stitch
global forcemov
global normalend
on mainstart()
	set dvbox to tab view item "dvbox" of tab view "tabbox" of window "ReduxZero"
	set fileext to ".dv"
	
	
	previewsetup() of snippets
	
	
	proccrop() of snippets
	deinterlacer() of snippets
	set format to "ntsc"
	set yuv to " -pix_fmt yuv411p "
	if content of cell "pal" of matrix "format" of dvbox is true then
		set format to "pal"
		set yuv to " -pix_fmt yuv420p "
	end if
	set tiny to "nottiny"
	if content of button "widescreen" of dvbox is true then
		set tiny to "16by9"
	end if
	
	if content of button "fcp" of dvbox is true then
		set forcemov to "  -f mov -aspect 2:3 "
	else
		set forcemov to " "
	end if
	
	set optim to do shell script "/usr/bin/ulimit -u 256 ; " & thequotedapppath & "/Contents/Resources/ratiofinder " & fullstarttime & " " & format & "dv " & tiny & " " & mpegaspect
	set thewidth to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $1}'")
	set theheight to (do shell script "/bin/echo " & optim & " | /usr/bin/awk -F x '{print $2}' | awk '{print $1}'")
	
	(*
	try
		set audchan to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Audio | head -1 | awk -F , '{print $9}'")
		set audhz to (do shell script "/bin/cat /tmp/rztemp/" & fullstarttime & "/reduxzero_dur | grep Audio | head -1 | awk -F , '{print $8}'")
		if audchan is 1 or audhz < 44100 or "wmv" is in theFile then
			do shell script (ffmpegloc & "ffmpeg -y -i " & thequotedorigpath & colorspace & " -qscale 1 -async 50 -ac 2 -ar 48000 -ab 320k /tmp/rztemp/" & fullstarttime & "/reduxzero_wmvfix.avi")
			set thequotedorigpath to "/tmp/rztemp/" & fullstarttime & "/reduxzero_wmvfix.avi"
		end if
	end try
*)
	
	set ffmpegstring to ("" & pipe & ffmpegloc & "ffmpeg -y " & forcepipe & " -i " & thequotedorigpath & threadscmd & colorspace & extaudio & deinterlace & croptop & cropbottom & cropleft & cropright & " -ar 48000 -vcodec dvvideo " & " -r " & format & " -s " & optim & yuv & ffvideos & vol & " -async 50 " & " -acodec pcm_s16le -ac 2 " & ffaudios & forcemov & previewstring & outputfile & normalend)
	xpiper() of snippets
	set xgridffmpegstring to (xpipe & serverfile & " " & backslash & "$loc/ffmpeg -y " & forcepipe & " -i " & serverinput & threadscmd & colorspace & extaudio & deinterlace & croptop & cropbottom & cropleft & cropright & " -vcodec dvvideo " & " -r " & format & " -s " & optim & yuv & ffvideos & vol & " -async 50 " & " -acodec pcm_s16le -ar 48000 -ac 2 " & ffaudios & forcemov & backslash & "$dir/" & thequotedfile & ".temp.dv > /dev/null 2> /dev/null ")
end mainstart


on mainend()
	if forcemov is not " " then
		if stitch is true then
			easyend() of snippets
		else
			set the content of text field "timeremaining" of window "ReduxZero" to (localized string "finishing") & whichone & "..."
			update window "ReduxZero"
			set newext to (destpath & quoted form of filenoext) & fileext
			if (do shell script "/bin/test -f " & newext & " ; echo $?") is "0" then
				set moreend to fileext
				try
					do shell script thequotedapppath & "/Contents/Resources/flattercmd " & outputfile & " " & newext & fileext
				end try
			else
				try
					do shell script thequotedapppath & "/Contents/Resources/flattercmd " & outputfile & " " & newext
				end try
				set moreend to ""
			end if
			if (do shell script "/bin/test -f " & newext & moreend & " ; echo $?") is "0" then
				set howbig to (do shell script "ls -ln " & newext & moreend & " | /usr/bin/awk '{print $5}'") as number
				if (howbig > 100) then
					do shell script "/bin/rm " & outputfile
				else
					do shell script "/bin/rm " & newext & moreend
				end if
			end if
		end if
	else
		easyend() of snippets
	end if
end mainend

--  Created by Tyler Loch on 4/1/06.
--  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
