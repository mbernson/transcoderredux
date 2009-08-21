-- lossies.applescript
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


global thePath
global thequotedapppath
global fullstarttime
global ffmpeg
global sysver
global stitchedfile
global stitch
global stitchstack
global ahver
global filetoconvert
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
global isauto
global theDataSource
global durfile
global buttonsscript
global theformat
global thedur
global thesize
global thecodec
global thebitdepth
global thehz
global thechan
global thebitrate
global thetitle
global theartist
global thealbum
global theyear
global thecomment
global thetrack
global thegenre
global snippets
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
global pipe
global ffmpegstring
global quotedoutputfile
global outputfile
global tmpdir
global preview
global normalend
global isqt
global pipe
global pipeprep
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
global appsup
global endline
global otherextras
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

global whichpart
global finalbit
global finalchan
global finalhz

global thedurnum

global whichwhendone
global dowhendone
global finalbitdepth
global theRow

--LOCAL GLOBALS
global which3g
global acodec
global qualitylevel

on formatstart(toformat)
	if toformat is aac then
		set fileext to "wav"
		set acodec to "pcm_s16le"
		set whichpart to "ahworking1"
	end if
	if toformat is mp3 then
		set fileext to "mp3"
		set acodec to "libmp3lame"
	end if
	if toformat is ogg then
		set fileext to "ogg"
		set acodec to "vorbis"
		cleartags() of snippets
	end if
	if toformat is wma then
		set fileext to "wma"
		set acodec to "wmav2"
	end if
	if toformat is threeg then
		set fileext to "wav"
		set acodec to "pcm_s16le"
		set which3g to matrix "codectype" of tab view item "lossy" of tab view "formatbox" of box "box" of window "SongRedux"
		--		if contents of cell 1 of which3g is true then
		--			set fileext to "m4a"
		--			set acodec to "libfaac"
		--		end if
		if contents of cell 1 of which3g is false then
			set hzforce to true
			set hzset to 8000
			set chanforce to true
			set chanset to 1
		end if
		set whichpart to "ahworking1"
	end if
	
	if hzforce is true then
		set thehz to hzset
	end if
	
	if chanforce is true then
		set thechan to chanset
	end if
	
	if bitforce is true then
		set thebitrate to bitset
	end if
	
	set qualitylevel to contents of slider "quality" of box "qualitybox" of box "box" of window "SongRedux"
	try
		set {finalhz, finalchan, finalbit} to audbasher(fileext, thehz as number, hzforce, thechan, chanforce, thebitrate, bitforce, qualitylevel)
	on error
		set {finalhz, finalchan, finalbit} to {44100, 2, 128}
	end try
	
	if preview is false then
		if toformat is aac and (((((((finalhz * finalchan * thebitdepth) / 8) / 1024) * thedurnum) as integer) > 2097152) or contents of default entry "faac" of user defaults is true) then
			set fileext to "m4a"
			if dowhendone is true then
				if whichwhendone is 1 then
					set fileext to "m4b"
				end if
				if whichwhendone is 2 then
					set fileext to "m4r"
				end if
			end if
			set acodec to "libfaac -f mp4"
			set whichpart to "ahworking0"
		end if
	end if
	
	-- FORCE RINGTONE TO WORK RIGHT
	if dowhendone is true and whichwhendone is 2 then
		set finalhz to 44100
		set finalchan to 2
	end if
	
	-- SHOULD THIS GO HERE???
	--	if preview is false then
	set exportfile to quotedoutputfile & ".temp." & fileext
	
	if toformat is ogg then
		set exportfile to " -acodec pcm_s16le -f s16le - "
		set endline to " 2>> " & tmpdir & "songredux_time | " & appsup & "oggenc - -r -C " & finalchan & " -R " & finalhz & " -b " & finalbit & " " & otherextras & " -o " & quotedoutputfile & ".temp." & fileext & " &> /dev/stdout |  /usr/bin/grep -v '|' | /usr/bin/grep -v '-' >> " & tmpdir & "songredux_time ; echo done > " & tmpdir & "songredux_working"
	end if
	if toformat is mp3 then
		set exportfile to " -acodec pcm_s16be -ac 2 -f s16be - "
		if finalchan is 2 then
			set howchan to " -m s "
		else
			set howchan to " -a "
		end if
		if "-v" is in otherextras then
			set cbr to ""
		else
			set cbr to " --cbr"
		end if
		if "-V " is in otherextras then
			set lamebit to ""
		else
			set lamebit to " -b " & finalbit
		end if
		set endline to " 2>> " & tmpdir & "songredux_time | " & appsup & "lame -r -s " & finalhz & " --resample " & finalhz & howchan & cbr & lamebit & " " & otherextras & " - -o " & quotedoutputfile & ".temp." & fileext & " 2>> " & tmpdir & "songredux_time >> " & tmpdir & "songredux_time ; echo done > " & tmpdir & "songredux_working"
	end if
	--	else
	--PUT SOMETHING HERE
	--	end if
	-- FFMPEG TAGGING GRAVEYARD
	--  setyear & setartist & settitle & setcomment & settrack & setgenre & setalbum &
	set ffmpegstring to pipe & ffmpeg & pipeprep & " -y -i " & filetoconvert & audiotrack & skipsec & forcedur & " -vn -acodec " & acodec & " -ar " & finalhz & " -ac " & finalchan & " -ab " & finalbit & "k" & vol & ffaudios & " " & exportfile
	
	--THIS IS DANGEROUS
	--set exportfile back
	set exportfile to quotedoutputfile & ".temp." & fileext
	
	if preview is false and whichpart is "ahworking1" then
		set AppleScript's text item delimiters to ","
		set contents of data cell statustextcell of theRow to ("ahworking1," & ({finalhz, finalchan, finalbit} as string) & ",16")
	end if
end formatstart

on audbasher(type, hz, hzforce, chan, chanforce, bit, bitforce, qualitylevel)
	--BACKUP DEFAULTS
	set endhz to 44100
	set chanbit to 64
	set endchan to 2
	
	--SCARE HZ STRAIGHT
	try
		if hz is greater than 44100 then
			set endhz to 48000
			set chanbit to 64
			if qualitylevel is 2 then
				set endhz to 44100
				set chanbit to 64
			end if
			if qualitylevel is 1 then
				set endhz to 22050
				set chanbit to 16
			end if
		end if
		if hz is less than or equal to 44100 then
			set endhz to 44100
			set chanbit to 64
			if qualitylevel is 2 then
				set endhz to 44100
				set chanbit to 64
			end if
			if qualitylevel is 1 then
				set endhz to 22050
				set chanbit to 32
			end if
		end if
		if hz is less than or equal to 32000 then
			set endhz to 32000
			set chanbit to 48
			if qualitylevel is 2 then
				set endhz to 22050
				set chanbit to 32
			end if
			if qualitylevel is 1 then
				set endhz to 11025
				set chanbit to 16
			end if
		end if
		if hz is less than or equal to 22050 then
			set endhz to 22050
			set chanbit to 32
			if qualitylevel is 2 then
				set endhz to 11025
				set chanbit to 16
			end if
			if qualitylevel is 1 then
				set endhz to 11025
				set chanbit to 16
			end if
		end if
		if hz is less than or equal to 11025 then
			set endhz to 11025
			set chanbit to 16
		end if
		if hz is less than or equal to 8000 then
			set endhz to 8000
			set chanbit to 8
		end if
		if qualitylevel is 4 then
			set chanbit to round (chanbit * 1.5)
		end if
		if qualitylevel is 5 then
			set chanbit to round (chanbit * 2.5)
		end if
		--SPECIAL FOR MP3CD
		if qualitylevel is 6 then
			set chanbit to round (chanbit * 0.75)
		end if
	end try
	
	--UNDERSTAND CHANNELS
	if chanforce is false then
		try
			if chan as string is "5.1" then
				set endchan to 2
			end if
			if chan as string is "5 channels" then
				set endchan to 2
			end if
			if chan as string is "6" then
				set endchan to 2
			end if
			if chan as string is "5" then
				set endchan to 2
			end if
			if chan as string is "4" then
				set endchan to 2
			end if
			if chan as string is "3" then
				set endchan to 2
			end if
			if chan as string is "2" then
				set endchan to 2
			end if
			if chan as string is "1" then
				set endchan to 1
			end if
			-- FORCE QUALITY PRESET CHANNELS
			if qualitylevel < 3 then
				set endchan to 1
			end if
		end try
	else
		set endchan to chan
	end if
	
	--FORCED BIT CALC
	if hzforce is true then
		set endhz to hz
		try
			if endhz is greater than or equal to 44100 then
				set chanbit to 64
			end if
			if endhz is less than 44100 then
				set chanbit to 48
			end if
			if endhz is less than or equal to 24000 then
				set chanbit to 32
			end if
			if endhz is less than or equal to 11025 then
				set chanbit to 16
			end if
			if endhz is less than or equal to 8000 then
				set chanbit to 8
			end if
		end try
	end if
	
	if bitforce is true then
		set endbit to bit
	else
		set endbit to (chanbit * endchan)
	end if
	
	if toformat is wma and endbit is 16 then set endbit to 24
	
	if toformat is threeg then
		if contents of cell 1 of which3g is false then
			set endbit to 5900
			if qualitylevel is 1 then
				set endbit to 4.75
			end if
			if qualitylevel is 2 then
				set endbit to 5.15
			end if
			if qualitylevel is 3 then
				set endbit to 5.9
			end if
			if qualitylevel is 4 then
				set endbit to 7.95
			end if
			if qualitylevel is 5 then
				set endbit to 10.2
			end if
		end if
	end if
	
	if type is "mp3" then
		if endhz > 24000 then
			set rategauntlet to {8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 192, 224, 256, 320}
		else
			set rategauntlet to {8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160}
		end if
		set newbit to 8
		repeat with eachone in rategauntlet
			if endbit as number is greater than or equal to eachone then
				set newbit to eachone
			end if
		end repeat
		set endbit to newbit
	end if
	
	return {endhz as number, endchan as number, endbit as number}
end audbasher


on normaldone()
	specialtags() of snippets
	--	easyend() of snippets
end normaldone
--  Created by Tyler Loch on 10/31/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.