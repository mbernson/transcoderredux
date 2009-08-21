-- cds.applescript
-- SongRedux

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

global batchtmpdir

--LOCAL GLOBALS
global burnspeed
global pregap
global drive
global mp3ok
global acodec
global endline
global cddir

on formatstart(toformat)
	
	set mp3ok to false
	
	if toformat is audiocd then
		set fileext to "wav"
		set acodec to "pcm_s16le"
		set hzforce to false
		set chanforce to false
		set bitforce to false
		set setyear to ""
		set setartist to ""
		set settitle to ""
		set setcomment to ""
		set settrack to ""
		set setgenre to ""
		set setalbum to ""
		if preview is true then
			set fileext to "wav"
			set acodec to "pcm_s16le"
		end if
		set audstring to " "
	end if
	if toformat is mp3cd then
		set fileext to "mp3"
		set acodec to "libmp3lame"
		
		set alldurs to contents of data cell durationcell of every data row of data source of table view "table" of scroll view "table" of window "SongRedux"
		set fulldur to calcbigdur(alldurs) of (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
		--		if fulldur < 58333 then
		set topbit to 96
		set qualitylevel to 6
		--		end if		
		if fulldur < 43000 then
			set topbit to 128
			set qualitylevel to 3
		end if
		if fulldur < 29000 then
			set topbit to 192
			set qualitylevel to 4
		end if
		
		set bitok to false
		if thebitrate is less than or equal to topbit then
			set bitok to true
		end if
		
		--		repeat with thisone in {ext, hzforce, chanforce, bitforce, thehz, thechan, bitok}
		---			display dialog thisone as string
		--	end repeat
		
		if {ext, hzforce, chanforce, bitforce, thehz as number, thechan as number, bitok} is {"mp3", false, false, false, 44100, 2, true} then
			set mp3ok to true
		else
			if hzforce is true then
				set thehz to hzset
			else
				set thehz to 44100
			end if
			
			if chanforce is true then
				set thechan to chanset
			else
				set thechan to 2
			end if
			
			if bitforce is true then
				set thebitrate to bitset
			end if
			
			set {finalhz, finalchan, finalbit} to audbasher(fileext, thehz as number, hzforce, thechan, chanforce, thebitrate, bitforce, qualitylevel) of (load script (scripts path of main bundle & "/lossies.scpt" as POSIX file))
			set audstring to (" -ar " & finalhz & " -ac " & finalchan & " -ab " & finalbit & "k ")
		end if
	end if
	
	
	-- SHOULD THIS GO HERE???
	if stitch is true then
		set exportfile to " -ar 44100 -ac 2 -f s16le - "
	else
		if toformat is mp3cd then
			set cddir to batchtmpdir & "SongRedux_CD/"
		else
			set cddir to batchtmpdir & "cd/"
		end if
		do shell script "/bin/mkdir " & cddir & " ; exit 0"
		set prenum to ""
		if whichone < 100 then
			set prenum to "0"
		end if
		if whichone < 10 then
			set prenum to "00"
		end if
		if toformat is audiocd then
			set exportfile to cddir & prenum & whichone & ".wav"
		else
			set outputfile to cddir & prenum & whichone & " " & filenoext
			set quotedoutputfile to quoted form of outputfile
			set exportfile to quotedoutputfile & ".temp." & fileext
		end if
	end if
	
	if mp3ok is true and preview is false then
		do shell script "/bin/cp " & filetoconvert & " " & exportfile & " ; exit 0"
	else
		if toformat is mp3cd then
			set otherexportfile to exportfile
			set exportfile to " -acodec pcm_s16be -ac 2 -f s16be - "
			if finalchan is 2 then
				set howchan to " -m s "
			else
				set howchan to " -a "
			end if
			if "vbr" is in otherextras then
				set cbr to ""
			else
				set cbr to " --cbr"
			end if
			set endline to " 2>> " & tmpdir & "songredux_time | " & appsup & "lame -r -s " & finalhz & howchan & cbr & " -b " & finalbit & " " & otherextras & " - -o " & otherexportfile & " 2>> /dev/stdout >> " & tmpdir & "songredux_time ; echo done > " & tmpdir & "songredux_working"
		end if
		set ffmpegstring to pipe & ffmpeg & pipeprep & " -y -i " & filetoconvert & audiotrack & skipsec & forcedur & " -vn -acodec " & acodec & audstring & vol & ffaudios & " " & exportfile
		--	set ffmpegstring to pipe & ffmpeg & pipeprep & "-y -i " & filetoconvert & audiotrack & skipsec & forcedur & " -vn -acodec " & acodec & " " & audstring & " " & vol & setyear & setartist & settitle & setcomment & settrack & setgenre & setalbum & ffaudios & " " & exportfile
		if toformat is mp3cd then
			set exportfile to otherexportfile
		end if
	end if
	
	
end formatstart

on normaldone()
	if toformat is mp3cd then
		specialtags() of (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
	end if
end normaldone

on cdprep()
	set thebar to progress indicator "bar" of window "SongRedux"
	set indeterminate of thebar to true
	set maximum value of thebar to 100
	set minimum value of thebar to 0
	tell thebar to start
	update window "SongRedux"
	
	set the content of text field "filenum" of window "SongRedux" to (localized string "stepspace") & 2 & (localized string "spaceofspace") & 2
	set the content of text field "timeremaining" of window "SongRedux" to (localized string "burning")
	set whichdrive to contents of default entry "useburner" of user defaults
	if whichdrive is 0 then
		set drive to ""
	else
		set drive to ("-drive " & whichdrive)
	end if
	set burnspeedset to contents of default entry "burnspeed" of user defaults
	if burnspeedset is 5 then
		set burnspeed to " "
	else
		set burnspeed to (" -speed " & ((2 ^ burnspeedset) as integer)) & " "
	end if
	
	set pregap to contents of popup button "pregap" of tab view item "cd" of tab view "formatbox" of box "box" of window "SongRedux"
	set drive to ""
	if "blank" is not in (do shell script "/usr/bin/drutil " & drive & " status | /usr/bin/grep Writability ; exit 0") then
		--set the content of text field "timeremaining" of window "SongRedux" to (localized string "waitingfordisc")
		display dialog (localized string "blankcd") attached to window "SongRedux" buttons {(localized string "OK")} with icon "cd" default button (localized string "OK")
		beep
		do shell script "/usr/bin/drutil " & drive & " eject ; exit 0"
		beep
		delay 2
		set the content of text field "timeremaining" of window "SongRedux" to (localized string "burning")
	end if
end cdprep

on audiocdburn()
	do shell script "/usr/bin/drutil " & drive & " burn -audio -pregap " & pregap & burnspeed & cddir & " > " & tmpdir & "songredux_cd 2>> " & tmpdir & "songredux_time &"
end audiocdburn

on mp3cdburn()
	do shell script "/usr/bin/drutil " & drive & " burn  -iso9660 " & burnspeed & tmpdir & cddir & " > " & tmpdir & "songredux_cd 2>> " & tmpdir & "songredux_time &"
end mp3cdburn

on watchburn()
	set pid to (do shell script "/bin/ps xwwo pid,command | /usr/bin/grep drutil | /usr/bin/grep -v grep | /usr/bin/tail -1 | /usr/bin/awk '{print $1}'" as string)
	set contents of text field "pid" of window "SongRedux" to pid
	set cdpercent to 0
	set cdgoing to true
	repeat until cdgoing is false
		delay 1.5
		iscancelled() of (load script (scripts path of main bundle & "/main.scpt" as POSIX file))
		try
			--FUCK, IT'S BROKEN
			set cdpercent to (do shell script "/usr/bin/strings " & tmpdir & "songredux_cd | /usr/bin/grep '%' | /usr/bin/tail -1 | /usr/bin/awk -F '] ' '{print $2}' | /usr/bin/sed -e 's/%//g'") as number
		end try
		if cdpercent > 0 and cdpercent < 100 then
			set indeterminate of thebar to false
			set contents of thebar to cdpercent
		end if
		set burnstatus to (do shell script "/usr/bin/tail -n 5 " & tmpdir & "songredux_cd ; exit 0")
		if "Burn complete" is in burnstatus or "Burn failed" is in burnstatus then
			set cdgoing to false
		end if
	end repeat
end watchburn
--  Created by Tyler Loch on 10/31/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.


--  Created by Tyler Loch on 1/2/08.
--  Copyright 2008 __MyCompanyName__. All rights reserved.
