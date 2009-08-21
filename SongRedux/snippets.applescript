-- snippets.applescript
-- SongRedux
property fullpathcell : 1
property statustextcell : 2
property statusiconcell : 3
property shortnamecell : 4
property starttimecell : 5
property pidcell : 6
property exportfilecell : 7
property outputfilecell : 8
property durationnumcell : 9
property durationcell : 10

property ahver : 104

global thefilecell
global theFilepath
global theFile
global thePath
global ext
global extsize
global filenoext
global quotedfile
global quotedpath
global quotedorigpath
global custompath
global quotedcustompath
global destpath
global backslash
global fullstarttime
global filetoconvert
global writable
global bitforce
global hzforce
global chanforce
global hzset
global bitset
global chanset
global skipsec
global forcedur
global audiotrack
global forcetitle
global forceartist
global forcealbum
global forcetrack
global forceyear
global forcegenre
global forcecomment
global rawtitle
global rawartist
global rawalbum
global rawtrack
global rawyear
global rawgenre
global rawcomment
global ffaudios
global vol
global normalize
global toformat
global ffmpegstring
global quotedoutputfile
global outputfile
global tmpdir
global preview
global normalend
global howmany
global isqt
global pipe
global pipeprep
global durfile
global thequotedapppath
global theyear
global theartist
global thetitle
global thecomment
global thetrack
global thegenre
global thealbum
global setyear
global setartist
global settitle
global setcomment
global settrack
global setgenre
global setalbum
global stitch
global stitchstack
global donefile
global quoteddonefile
global fileext
global whichone
global exportfile
global ffmpeg
global buttonsscript
global stitchdestpath
global quotedstitchdestpath
global finishstitch
global theinfo
global appsup
global lossy
global aac
global mp3
global wma
global threeg
global ogg
global lossless
global aiff
global wav
global applelossless
global flac
global burn
global audiocd
global mp3cd
global otherextras
global acodec
global isflac
global isvlc
global thelogfile
global origformat
global origdur
global origsize
global origcodec
global origbitdepth
global orighz
global origchan
global origbitrate
global origtitle
global origartist
global origalbum
global origyear
global origcomment
global origtrack
global origgenre
global totalleft
global ismidi
global thedur
global thedurnum

global iscd
global cdtracknum

global whichpart

global thehz
global thechan

global whichsound

global whichwhendone
global dowhendone

global batchstarttime
global randombit
global statusrow
global batchtmpdir

on pathings(thefilecell)
	-- GET THE FILE PATH --
	set theFilepath to contents of thefilecell as Unicode text
	
	-- PICK IT APART --
	set theFile to call method "lastPathComponent" of theFilepath
	set thePath to ((call method "stringByDeletingLastPathComponent" of theFilepath) & "/") as Unicode text
	
	-- FILE EXTENSION --
	set ext to (call method "pathExtension" of theFilepath)
	set filenoext to (call method "stringByDeletingPathExtension" of (call method "lastPathComponent" of theFilepath))
	
	-- IMPORTANT QUOTED FORMS --
	set quotedfile to (quoted form of filenoext) --JUST THE FILE NAME, NO EXTENSION
	set quotedpath to (quoted form of thePath) --JUST THE PATH TO THE FILE
	set quotedorigpath to (quoted form of theFilepath) --THE ENTIRE PATH AND FILE
	set filetoconvert to quotedorigpath --ALL NORMAL FILES: SAME AS QUOTEDORIGPATH
	
	-- CHECK FOR WRITEABILITY IN OUTPUT DIR --
	set writable to true
	tell text field "saveto" of box "workflowbox" of box "box" of window "SongRedux"
		set custompath to contents
		if custompath is "" then
			try
				do shell script "/usr/bin/touch " & quotedpath & "/.ahtest"
				do shell script "/bin/rm " & quotedpath & "/.ahtest"
			on error
				set writable to false
			end try
		else
			-- SET CUSTOM PATH --
			set quotedcustompath to (quoted form of custompath)
			try
				do shell script "/usr/bin/touch " & quotedcustompath & "/.ahtest"
				do shell script "/bin/rm " & quotedcustompath & "/.ahtest"
			on error
				set writable to false
			end try
		end if
		if writable is false then
			set contents to (do shell script "cd ~/Desktop ; pwd")
		end if
		set saveto to contents
	end tell
	-- SET OUTPUT PATH --
	if saveto is "" then
		set destpath to (thePath)
	else
		if last text item of saveto is not "/" then
			set saveto to (saveto & "/")
		end if
		set destpath to (saveto) as Unicode text
	end if
	if stitch is true then
		set stitchdestpath to destpath
		set quotedstitchdestpath to quoted form of stitchdestpath
	end if
	
	set outputfile to (destpath & filenoext)
	set quotedoutputfile to quoted form of (destpath & filenoext)
	
	-- SPECIAL FORMAT EXCEPTIONS --
	if ext is "eyetv" then
		set filetoconvert to (quotedorigpath & "/*.mpg") as Unicode text
		set ext to "mpg"
	end if
	if ext is "iMovieProject" then
		set filetoconvert to (quotedorigpath & "/'Shared Movies/iDVD'/*.mov") as Unicode text
		set ext to "mov"
	end if
	if ext is "band" then
		set filetoconvert to (quotedorigpath & "/Output/Output.aif") as Unicode text
		set ext to "aif"
	end if
	
	-- CHECK IF IT'S A CD --
	if (do shell script "/bin/test -f " & quotedpath & "/.TOC.plist ; echo $?") is "0" then
		set iscd to true
		set AppleScript's text item delimiters to " " as Unicode text
		set cdtracknum to first text item of filenoext
	end if
end pathings


on advanceds()
	tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
		set skipsec to contents of slider "ss"
		if skipsec is not 0 then
			set skipsec to (" -ss " & skipsec & " ")
		else
			set skipsec to " "
		end if
		
		set AppleScript's text item delimiters to ""
		set thetrim to "trim"
		
		set forcedur to contents of slider "t"
		set durmax to maximum value of slider "t"
		if forcedur is not (durmax) and forcedur is not 0 then
			set totalleft to ((durmax - (contents of slider "ss")) - (durmax - (contents of slider "t"))) as integer
			-- FORCE RINGTONE TO WORK RIGHT
			if dowhendone is true and whichwhendone is 2 then
				if totalleft is greater than or equal to 40 then
					set totalleft to 39.9
				end if
			end if
			set forcedur to (" -" & first text item of thetrim & " " & totalleft & " ")
		else
			set forcedur to " "
			-- FORCE RINGTONE TO WORK RIGHT
			if dowhendone is true and whichwhendone is 2 then
				set forcedur to (" -" & first text item of thetrim & " " & (39.9) & " ")
			end if
		end if
		
		
	end tell
	
	
	tell tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
		set hzset to contents of combo box "audiohz"
		if hzset is "" or hzset is (localized string "auto") then
			set hzforce to false
		else
			set hzforce to true
		end if
		set chanset to contents of popup button "audiochannels"
		if chanset is 0 then
			set chanforce to false
		else
			set chanforce to true
		end if
		set fitonoff to contents of button "fitonoff"
		if fitonoff is true then
			set thefit to contents of text field "fit"
			set allthekbits to (thefit * 8192)
			if forcedur is not in {"", " "} then
				set bitset to (round ((allthekbits / totalleft) - 8) rounding down)
			else
				set bitset to (round ((allthekbits / thedurnum) - 8) rounding down)
			end if
			set bitforce to true
		else
			set bitset to contents of text field "audiobitrate"
			if bitset is "" then
				set bitforce to false
			else
				set bitforce to true
			end if
		end if
		set audiotrack to contents of popup button "audiotrack"
		if audiotrack is not 0 then
			set audiotrack to (" -map 0." & audiotrack & " ")
		else
			set audiotrack to " "
		end if
		set ffaudios to contents of text field "ffaudio"
		set otherextras to contents of text field "xxaudio"
		set volslider to contents of slider "vol"
		if volslider is 256 then
			if ismidi is true then
				set vol to " -vol 640 "
			else
				set vol to " "
			end if
		else
			set vol to " -vol " & (round volslider) & " "
		end if
		set normalize to contents of button "normalize"
		if volslider is 256 then
			if ismidi is true and normalize is false then
				set vol to " -vol 768 "
			else
				set vol to " "
			end if
		else
			set vol to " -vol " & (round volslider) & " "
		end if
	end tell
end advanceds

on quicktimedetect()
	set forcedecoder to false
	set whichdecoder to contents of popup button "decoder" of tab view item "advancedaudiobox" of tab view "advancedbox" of window "advanced"
	if whichdecoder > 0 then
		set isqt to false
		set isvlc to false
		set isflac to false
		set ismidi to false
		set forcedecoder to true
		if whichdecoder is 1 then
			set isqt to true
			--	set forcedecoder to true
		end if
		if whichdecoder is 3 then
			set isvlc to true
			--		set forcedecoder to true
		end if
	end if
	if (("mov,mp4,m4a" is in (do shell script "/bin/cat " & durfile) or ext is "caf" or ext is "amr") and forcedecoder is false) or (isqt is true) then
		set isqt to true
		set pipe to (thequotedapppath & "/Contents/Resources/mov123 " & quotedorigpath & " | ")
		set pipeprep to " -f s16le -acodec pcm_s16le -ar 48000 -ac 2 "
		set thechan to 2
		set thehz to 48000
		set filetoconvert to "-"
	end if
	if (ext is "mid" or ext is "midi") and forcedecoder is false then
		set ismidi to true
		set midiaiff to (tmpdir & "midi.aiff")
		do shell script (thequotedapppath & "/Contents/Resources/aiffer " & quotedorigpath & " " & midiaiff & " ; exit 0")
		set thechan to 2
		set thehz to 44100
		set filetoconvert to midiaiff
	end if
	if (ext is "flac") and forcedecoder is false then
		set isflac to true
		-- old and busted raw flags:  --force-raw-format --sign=signed --endian=little 
		set pipe to (appsup & "flac -F -d " & quotedorigpath & " -c 2>> " & tmpdir & "songredux_time | ")
		--		set pipeprep to " -f s16le -ac " & origchan & " -ar " & orighz & " "
		set pipeprep to " -f wav "
		set filetoconvert to "-"
	end if
	if isvlc is true then
		if (contents of default entry "vlcloc" of user defaults as string) is "" then
			--		set contents of default entry "vlcloc" of user defaults to (POSIX path of (path to application "VLC"))
			try
				set contents of default entry "vlcloc" of user defaults to (do shell script "/usr/bin/osascript -l AppleScript -e 'POSIX path of (path to application \"VLC\")'")
			on error
				stoprun() of (load script (scripts path of main bundle & "/main.scpt" as POSIX file))
				error (localized string "novlc")
			end try
		end if
		
		set pipe to (((quoted form of (contents of default entry "vlcloc" of user defaults as string)) & "/Contents/MacOS/clivlc -I dummy  " & quotedorigpath & " --sout='#transcode{acodec=mpga,channels=2,samplerate=48000,ab=320}:std{mux=ps,dst=-}' vlc:quit 2>> " & tmpdir & "songredux_time | "))
		set pipeprep to " -f mpeg "
		set filetoconvert to "-"
	end if
end quicktimedetect

on cleartags()
	set {settitle, setartist, setalbum, settrack, setyear, setgenre, setcomment} to {" ", " ", " ", " ", " ", " ", " "}
end cleartags

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

on easyend()
	--Finished.
	if finishstitch is true then
		set the content of text field "timeremaining" of window "SongRedux" to (localized string "finishing")
		--	else
		--		set the content of text field "timeremaining" of window "SongRedux" to (localized string "finishingfile") & whichone & "..."
	end if
	update window "SongRedux"
	
	(* MODIFY FOR VISUALHUB 	if stitch is true then
		set stitchstack to (stitchstack & quotedoutputfile)
		set quoteddonefile to " "
	else *)
	set donefile to (outputfile & "." & fileext)
	if (do shell script "/bin/test -f " & quoted form of donefile & " ; echo $?") is "1" then
		-- DESTINATION IS CLEAR!
	else
		-- FILE ALREADY EXISTS!
		set thedate to do shell script "/bin/date +%y%m%d-%H%M%S"
		set donefile to (outputfile & "-converted-" & thedate & "." & fileext)
	end if
	set quoteddonefile to quoted form of donefile
	try
		do shell script "/bin/mv -n " & exportfile & " " & quoteddonefile
	end try
	--	end if
end easyend

on whereffmpeg(onlaunched)
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	set isffmpeg to contents of default entry "ffmpegloc" of user defaults
	set appsup to (thequotedapppath & "/Contents/Resources/")
	return (thequotedapppath & "/Contents/Resources/ffmpeg")
end whereffmpeg

on specialtags()
	set specialtag to false
	if toformat is in {applelossless, aac, threeg} then
		if toformat is aac then
			if whichpart is "ahworking0" then
				easyend()
			end if
		end if
		set specialtag to true
		if toformat is threeg then
			set titlearg to " --3gp-title "
			set artistarg to " --3gp-performer "
			set albumarg to " --3gp-album "
			set trackarg to " trknum="
			set yeararg to " --3gp-year "
			set genrearg to " --3gp-genre "
			set commentarg to " --3gp-description "
			set which3g to matrix "codectype" of tab view item "lossy" of tab view "formatbox" of box "box" of window "SongRedux"
			if contents of cell 3 of which3g is true then
				set specialtag to false
				easyend()
			end if
		else
			set titlearg to " --title "
			set artistarg to " --artist "
			set albumarg to " --album "
			set trackarg to " --tracknum "
			set yeararg to " --year "
			set genrearg to " --genre "
			set commentarg to " --comment "
		end if
	else
		easyend()
	end if
	if toformat is in {flac, ogg, mp3, wma, mp3cd} then
		set titlearg to " -t "
		set artistarg to " -a "
		set albumarg to " -A "
		set trackarg to " -T "
		set yeararg to " -y "
		set genrearg to " -g "
		set commentarg to " -c "
		set specialtag to true
	end if
	if specialtag is true then
		
		
		tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
			set forcetitle to contents of text field "oneofftitle"
			if forcetitle is "" then
				if thetitle is "" then
					set settitle to " "
					set rawtitle to ""
				else
					set settitle to (" -title " & quoted form of thetitle & " ")
					set rawtitle to thetitle
				end if
			else
				set settitle to (" -title " & quoted form of forcetitle & " ")
				set rawtitle to forcetitle
			end if
			
			
			set forceartist to contents of text field "oneoffartist"
			if forceartist is "" then
				if theartist is "" then
					set setartist to " "
					set rawartist to ""
				else
					set setartist to (" -author " & quoted form of theartist & " ")
					set rawartist to theartist
				end if
			else
				set setartist to (" -author " & quoted form of forceartist & " ")
				set rawartist to forceartist
			end if
			
			set forcealbum to contents of text field "oneoffalbum"
			if forcealbum is "" then
				if thealbum is "" then
					set setalbum to " "
					set rawalbum to ""
				else
					set setalbum to (" -album " & quoted form of thealbum & " ")
					set rawalbum to thealbum
				end if
			else
				set setalbum to (" -album " & quoted form of forcealbum & " ")
				set rawalbum to forcealbum
			end if
			
			set forcetrack to contents of text field "oneofftrack"
			if forcetrack is "" then
				if thetrack is "" or thetrack is "0" then
					set settrack to " "
					set rawtrack to ""
				else
					set settrack to (" -track " & quoted form of thetrack & " ")
					set rawtrack to thetrack
				end if
			else
				if forcetrack is "#" then
					set settrack to (" -track " & whichone & " ")
					set rawtrack to whichone
				else
					try
						forceyear as number
						set settrack to (" -track " & quoted form of forcetrack & " ")
						set rawtrack to forcetrack
					on error
						set settrack to " "
						set rawtrack to ""
					end try
				end if
			end if
			
			set forceyear to contents of text field "oneoffyear"
			if forceyear is "" then
				if theyear is "" or theyear is "0" then
					set setyear to " "
					set rawyear to ""
				else
					set setyear to (" -year " & quoted form of theyear & " ")
					set rawyear to theyear
				end if
			else
				try
					forceyear as number
					set setyear to (" -year " & quoted form of forceyear & " ")
					set rawyear to forceyear
				on error
					set setyear to " "
					set rawyear to ""
				end try
			end if
			
			--		set forcegenre to contents of text field "oneoffgenre"
			set forcegenre to contents of text field "oneoffgenre"
			--display thegenre
			if forcegenre is "" then
				if thegenre is "" then
					set setgenre to " "
					set rawgenre to ""
				else
					set setgenre to (" -genre " & quoted form of thegenre & " ")
					set rawgenre to thegenre
				end if
			else
				set setgenre to (" -genre " & quoted form of forcegenre & " ")
				set rawgenre to forcegenre
			end if
			--OH NOS!
			--set setgenre to " "
			--set rawgenre to ""
			
			set forcecomment to contents of text field "oneoffcomment"
			if forcecomment is "" then
				if thecomment is "" then
					set setcomment to " "
					set rawcomment to ""
				else
					set setcomment to (" -comment " & quoted form of thecomment & " ")
					set rawcomment to thecomment
				end if
			else
				set setcomment to (" -comment " & quoted form of forcecomment & " ")
				set rawcomment to forcecomment
			end if
		end tell
		
		-- REDO TAGS FOR TAGWRITER
		if (rawtitle is "" and rawartist is "" and rawalbum is "" and rawtrack is "" and rawyear is "" and rawgenre is "" and rawcomment is "" and (whichwhendone is not 1) and toformat is not applelossless) then
			-- DON'T DO ANYTHING!
		else
			if rawtitle is "" then
				set newtitle to ""
			else
				set newtitle to titlearg & quoted form of rawtitle & " "
			end if
			if rawartist is "" then
				set newartist to ""
			else
				set newartist to artistarg & quoted form of rawartist & " "
			end if
			if rawalbum is "" then
				set newalbum to ""
			else
				set newalbum to albumarg & quoted form of rawalbum & " "
			end if
			if rawtrack is "" then
				set newtrack to ""
			else
				set newtrack to trackarg & quoted form of rawtrack & " "
			end if
			if rawyear is "" then
				set newyear to ""
			else
				set newyear to yeararg & quoted form of rawyear & " "
			end if
			if rawgenre is "" then
				set newgenre to ""
			else
				if rawgenre is "Rock" then
					set rawgenre to "Rock "
				end if
				set newgenre to genrearg & quoted form of rawgenre & " "
			end if
			if rawcomment is "" then
				set newcomment to ""
			else
				set newcomment to commentarg & quoted form of rawcomment & " "
			end if
			if toformat is in {flac, ogg, mp3, wma, mp3cd} then
				do shell script thequotedapppath & "/Contents/Resources/tagwriter " & newtitle & newartist & newalbum & newtrack & newyear & newgenre & newcomment & " " & quoted form of donefile & " ; exit 0"
				--				do shell script thequotedapppath & "/Contents/Resources/tagwriter " & newtitle & newartist & newalbum & newtrack & newyear & newgenre & newcomment & " " & quoteddonefile & " ; exit 0"
			end if
			if toformat is in {applelossless, aac, threeg} then
				-- FORCE AUDIOBOOK TO WORK RIGHT
				if toformat is aac and dowhendone is true and whichwhendone is 1 then
					set stik to " --stik value=2 --encodingTool 'SongRedux 1.07'"
				else
					set stik to " --encodingTool 'SongRedux 1.07' "
				end if
				
				do shell script "/bin/cp -n " & thequotedapppath & "/Contents/Resources/AtomicParsley /tmp/ahtemp/AtomicParsley ; exit 0"
				
				--				do shell script thequotedapppath & "/Contents/Resources/AtomicParsley " & quoteddonefile & stik & newtitle & newartist & newalbum & newtrack & newyear & newgenre & newcomment & " --overWrite ; exit 0"
				--set rand to " /tmp/" & (do shell script "echo $RANDOM") & ".m4a "
				--tell application "Terminal" to do script "ditto " & quoteddonefile & " " & rand & " ; /tmp/ahtemp/AtomicParsley " & rand & stik & newtitle & newartist & newalbum & newtrack & newyear & newgenre & newcomment & " --overWrite ; exit 0"
				do shell script "/tmp/ahtemp/AtomicParsley " & quoted form of donefile & " " & stik & newtitle & newartist & newalbum & newtrack & newyear & newgenre & newcomment & " --overWrite ; exit 0"
			end if
		end if
	end if
end specialtags

on calcbigdur(alldurs)
	(* --OLD WAY
	set durwork to 0
	repeat with thisdur in alldurs
		--try
		set durwork to ((durwork) + (timeswap(thisdur) of (load script (scripts path of main bundle & "/buttons.scpt" as POSIX file))))
		--end try
	end repeat
	*)
	
	set AppleScript's text item delimiters to "+"
	set durwork to do shell script "echo '" & alldurs & "' | /usr/bin/bc"
	
	set AppleScript's text item delimiters to ""
	
	return durwork
end calcbigdur

on writelog()
	--WRITE THE LOG
	try
		do shell script "/usr/bin/head -c 6000 " & quotedorigpath & " | /usr/bin/gzip | /usr/bin/uuencode -m - >> " & batchtmpdir & "songredux_time"
	end try
	try
		do shell script "/bin/mkdir -p ~/Library/Logs/Techspansion ; exit 0"
	end try
	set thelogfiledate to do shell script "/bin/date +%y%m%d-%H%M"
	set thelogfile to "~/Library/Logs/Techspansion/ah" & thelogfiledate & "-" & quotedfile & ".txt"
	do shell script "/bin/cp " & batchtmpdir & "songredux_time " & thelogfile
end writelog

on backslasher()
	set backslash to "\\"
	try
		if (do shell script "/bin/echo " & (ASCII character 128) & "a") is "a" then
			set backslash to (ASCII character 128)
		end if
	end try
end backslasher

on tmpgetter(justadd)
	set fullstarttime to do shell script "/bin/date +%s"
	set randombit to do shell script "echo $RANDOM$RANDOM$RANDOM$RANDOM | /usr/bin/cut -c 1-4"
	if justadd is false then
		set contents of text field "fullstarttime" of window "SongRedux" to batchstarttime
		set tmpdirname to (batchstarttime & "/" & fullstarttime & randombit)
	else
		set tmpdirname to (fullstarttime & randombit)
	end if
	if (contents of default entry "tmploc" of user defaults as string) is "/tmp/" then
		try
			do shell script "/bin/mkdir -p /tmp/ahtemp/" & tmpdirname
		end try
		try
			do shell script "/bin/chmod 777 /tmp/ahtemp" & tmpdirname
		end try
		try
			do shell script "/bin/chmod -R 777 /tmp/ahtemp"
		end try
	else
		try
			--display dialog (quoted form of (contents of default entry "tmpdir" of user defaults as string))
			do shell script "/bin/ln -s " & (quoted form of (contents of default entry "tmploc" of user defaults as string)) & " /tmp/ahtemp"
		end try
		try
			do shell script "/bin/mkdir -p /tmp/ahtemp/" & tmpdirname
		end try
		try
			do shell script "/bin/chmod -R 777 /tmp/ahtemp"
		end try
	end if
	set tmpdir to "/tmp/ahtemp/" & tmpdirname & "/"
end tmpgetter

on tmpcleaner(fullclean)
	if fullclean is true then
		try
			do shell script "/bin/rm -r /tmp/ahtemp"
		end try
	else
		try
			do shell script "/bin/rm -r /tmp/ahtemp/" & fullstarttime
		end try
	end if
end tmpcleaner

on commadecimal()
	if (0.73 as string) is "0,73" then
		return true
	else
		return false
	end if
end commadecimal

--  Created by Tyler Loch on 9/30/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.
