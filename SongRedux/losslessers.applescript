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
global endline
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

global theRow

--LOCAL GLOBALS
global which3g




on formatstart(toformat)
	
	if toformat is wav then
		set fileext to "wav"
		set acodec to "pcm_s16le"
	end if
	if toformat is aiff then
		set fileext to "aiff"
		set acodec to "pcm_s16be"
	end if
	if toformat is applelossless then
		set fileext to "wav"
		set acodec to "pcm_s16le"
		set {settitle, setartist, setalbum, settrack, setyear, setgenre, setcomment} to {" ", " ", " ", " ", " ", " ", " "}
		set whichpart to "ahworking1"
	end if
	if toformat is flac then
		set fileext to "flac"
		set acodec to "pcm_s16le"
		set {settitle, setartist, setalbum, settrack, setyear, setgenre, setcomment} to {" ", " ", " ", " ", " ", " ", " "}
	end if
	if preview is true then
		set fileext to "wav"
		set acodec to "pcm_s16le"
	end if
	if stitch is true then
		set fileext to ""
		set acodec to "pcm_s16le"
	end if
	
	if hzforce is true then
		set thehz to " -ar " & hzset & " "
		set finalhz to hzset
	else
		set finalhz to thehz
		set thehz to (" -ar " & thehz & " ")
	end if
	
	if chanforce is true then
		set thechan to " -ac " & chanset & " "
		set finalchan to chanset
	else
		set finalchan to thechan
		set thechan to ""
	end if
	
	if bitforce is true then
		set thebitrate to " -ab " & bitset & "k "
	else
		set thebitrate to ""
	end if
	
	set exportfile to quotedoutputfile & ".temp." & fileext
	
	-- SHOULD THIS GO HERE???
	if stitch is true then
		set exportfile to " -ar 48000 -ac 2 -f s16le - "
	else
		if toformat is flac then
			set exportfile to " -acodec pcm_s16le -f s16le - "
			--sector-align 
			set endline to " 2>> " & tmpdir & "songredux_time | " & appsup & "flac - --force-raw-format --endian=little --channels=" & finalchan & " --sample-rate=" & finalhz & " -7 --bps=16 --best --sign=signed -f " & otherextras & " -o " & quotedoutputfile & ".temp." & fileext & " 2>> /dev/stdout |  /usr/bin/grep -v '|' >> " & tmpdir & "songredux_time ; echo done > " & tmpdir & "songredux_working"
		end if
	end if
	-- FFMPEG TAGGING GRAVEYARD
	--  setyear & setartist & settitle & setcomment & settrack & setgenre & setalbum &
	set ffmpegstring to pipe & ffmpeg & pipeprep & "-y -i " & filetoconvert & audiotrack & skipsec & forcedur & " -vn -acodec " & acodec & " " & thehz & thechan & thebitrate & " " & vol & ffaudios & " " & exportfile
	
	if toformat is flac then
		set exportfile to quotedoutputfile & ".temp." & fileext
	end if
	
	if preview is false and whichpart is "ahworking1" then
		set AppleScript's text item delimiters to ","
		set contents of data cell statustextcell of theRow to ("ahworking1," & ({finalhz, finalchan, 0} as string) & ",16")
	end if
end formatstart

on normaldone()
	if stitch is false then
		specialtags() of snippets
	end if
end normaldone

(*
on alacconvert()
	--Finished.
	set the content of text field "timeremaining" of window "SongRedux" to (localized string "alacstep2") & whichone & "..."
	update window "SongRedux"
	
	set donefile to (quotedoutputfile & ".m4a")
	if (do shell script "/bin/test -f " & donefile & " ; echo $?") is "1" then
		-- DESTINATION IS CLEAR!
	else
		-- FILE ALREADY EXISTS!
		set donefile to (quotedoutputfile & "-lossless." & "m4a")
	end if
	do shell script thequotedapppath & "/Contents/Resources/afconvert -f m4af -d alac " & exportfile & " " & donefile
	do shell script "/bin/rm " & exportfile
end alacconvert
*)
--  Created by Tyler Loch on 10/31/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.
