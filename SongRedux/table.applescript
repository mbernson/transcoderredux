-- table.applescript
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

global theFiles
global fullstarttime
global ffmpeg
global snippets
global durfile
global tmpdir
global preview
global iscd
global cdtracknum
--  Created by Tyler Loch on 10/1/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.

on drop theObject drag info dragInfo
	set snippets to (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
	tmpgetter(true) of snippets
	
	-- DRAG AND SORT --
	set theDataSource to (data source of table view "table" of scroll view "table" of window "SongRedux")
	set dataTypes to types of pasteboard of dragInfo
	if "file names" is in dataTypes then
		set theFiles to {}
		set preferred type of pasteboard of dragInfo to "file names"
		set theFiles to contents of pasteboard of dragInfo
		if (count of theFiles) > 0 then
			set contents of text field "dragfiles" of window "SongRedux" to (localized string "checkingfiles")
			
			--	set update views of theDataSource to false
			set theFiles2 to ASCII_Sort(theFiles) as list
			-- prepare temp directory and variables --
			set ffmpeg to whereffmpeg(false) of snippets
			-- slam through files --
			repeat with theItem in theFiles2
				--	if (do shell script "/usr/bin/file -b " & quoted form of theItem & " ; exit 0") is "directory" then
				set theinsidefiles to (do shell script "/usr/bin/find " & quoted form of theItem & " -type f '!' -name '.*' '!' -path '.*' ; exit 0")
				set AppleScript's text item delimiters to return
				set theinsidefileslist to (text items of theinsidefiles)
				repeat with theinsideitem in theinsidefileslist
					tableadder(theinsideitem, fullstarttime)
				end repeat
				--	else
				--tableadder(theItem, fullstarttime)
				--	end if
			end repeat
			tmpcleaner(false) of snippets
			--	set update views of theDataSource to true
		end if
	end if
	gethowmany() of (load script (scripts path of main bundle & "/buttons.scpt" as POSIX file))
	return true
end drop

on clicked theObject
	-- DRAGGER BUTTON DELETE SHORTCUT
	if enabled of table view "table" of scroll view "table" of window "SongRedux" is true then
		removeitem() of (load script (scripts path of main bundle & "/buttons.scpt" as POSIX file))
		gethowmany() of (load script (scripts path of main bundle & "/buttons.scpt" as POSIX file))
	end if
end clicked

on selection changed theObject
	tell tab view item "advancedoneoffbox" of tab view "advancedbox" of window "advanced"
		set enabled of button "trimonoff" to true
		set contents of button "trimonoff" to false
		set enabled of slider "ss" to false
		set enabled of slider "t" to false
		set enabled of text field "startat" to false
		set contents of text field "startat" to (localized string "startatcolonspace")
		set contents of text field "endat" to (localized string "endatcolonspace")
		set enabled of text field "endat" to false
		set contents of text field "total" to ""
		set filedur to 240
		tell slider "ss" to set contents to 0
		-- BIIIIIG NUMBERRRRRR
		tell slider "t" to set contents to 999999
	end tell
	set visible of box "errorbox" of tab view item "advancedinfobox" of tab view "advancedbox" of window "advanced" to false
	if visible of window "advanced" is true and content of control "advancedtabs" of window "advanced" is 2 then
		try
			audinfo(null) --(selected data row of table view "table" of scroll view "table" of window "SongRedux")
		end try
	end if
	return true
end selection changed

on quickinfo(theItem, fullstarttime, justdur)
	set thePath to path of the main bundle as string
	set snippets to (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
	set buttonsscript to (load script (scripts path of main bundle & "/buttons.scpt" as POSIX file))
	-- prepare and clear out durfile --
	set durfile to tmpdir & "songredux_info"
	do shell script "/bin/echo '' > " & durfile
	set AppleScript's text item delimiters to "."
	set infoext to last text item of theItem
	set extgauntet to {"mp3", "m4a", "m4v", "mp4", "wma", "wmv", "ogg", "ogm", "flac"}
	try
		if (infoext is in extgauntet) then --"mp3" or infoext is "m4a" or infoext is "m4v" or infoext is "mp4" or infoext is "wma" or infoext is "wmv" or infoext is "ogg" or infoext is "ogm" or infoext is "flac" then
			do shell script quoted form of thePath & "/Contents/Resources/tagreader " & quoted form of theItem & " > " & durfile & " 2> /dev/null &"
			-- CHECK FOR UPDATES TO DURFILE 20 TIMES, THEN DIE AND KILL
			set deadcount to 0
			set thedur to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a length- | /usr/bin/cut -c 8-")
			repeat until thedur is not ""
				if deadcount > 20 then
					try
						do shell script "/usr/bin/killall tagreader"
					end try
					exit repeat
				end if
				set thedur to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a length- | /usr/bin/cut -c 8-")
				set deadcount to (deadcount + 1)
			end repeat
			if thedur is not "" then
				try
					set thedur to (timeswap(timeswap(thedur) of buttonsscript) of buttonsscript)
				end try
				set thedurseconds to (timeswap(thedur) of buttonsscript)
				if justdur is true then
					return {thedur, thedurseconds}
				else
					--					set thesize to (((round ((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1048.8)) / 1000) as string)
					set thesize to (((round ((((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1024)) / 1024) * 10) / 10) as string)
					set thebitdepth to 16
					set thehz to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a 'sample rate-' | /usr/bin/cut -c 13-")
					set thechan to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a channels- | /usr/bin/cut -c 10-")
					if thechan is "0" then
						error
					end if
					set AppleScript's text item delimiters to return
					set thetags to do shell script "/bin/cat " & durfile
					
					set thetagslist to (every text item of thetags)
					
					set AppleScript's text item delimiters to "bitrate-"
					set thebitrate to text item 2 of (item 8 of thetagslist)
					
					set AppleScript's text item delimiters to "title-"
					set thetitle to text item 2 of (item 1 of thetagslist)
					
					set AppleScript's text item delimiters to "artist-"
					set theartist to text item 2 of (item 2 of thetagslist)
					
					set AppleScript's text item delimiters to "album-"
					set thealbum to text item 2 of (item 3 of thetagslist)
					
					set AppleScript's text item delimiters to "year-"
					set theyear to text item 2 of (item 4 of thetagslist)
					
					set AppleScript's text item delimiters to "comment-"
					set thecomment to text item 2 of (item 5 of thetagslist)
					
					set AppleScript's text item delimiters to "track-"
					set thetrack to text item 2 of (item 6 of thetagslist)
					
					set AppleScript's text item delimiters to "genre-"
					set thegenre to text item 2 of (item 7 of thetagslist)
					
					set AppleScript's text item delimiters to ""
					
					--FIX BAD CARRIAGE RETURNS IN WMV FILES
					if infoext is in {"wmv", "wma", "asf"} then
						try
							if (count of text items of thetitle) > 0 and last text item of thetitle is "" then
								set thetitle to (text items 1 through -3 of thetitle as string)
							end if
						on error
							set thetitle to ""
						end try
						try
							if (count of text items of theartist) > 0 and last text item of theartist is "" then
								set theartist to (text items 1 through -3 of theartist as string)
							end if
						on error
							set theartist to ""
						end try
						try
							if (count of text items of thealbum) > 0 and last text item of thealbum is "" then
								set thealbum to (text items 1 through -3 of thealbum as string)
							end if
						on error
							set thealbum to ""
						end try
						try
							if (count of text items of thecomment) > 0 and last text item of thecomment is "" then
								set thecomment to (text items 1 through -3 of thecomment as string)
							end if
						on error
							set thecomment to ""
						end try
						try
							if (count of text items of thegenre) > 0 and last text item of thegenre is "" then
								set thegenre to (text items 1 through -3 of thegenre as string)
							end if
						on error
							set thegenre to ""
						end try
					end if
					(*
-- OLD WAY
					set thebitrate to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a bitrate- | /usr/bin/cut -c 9- | strings")
					set thetitle to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a title- | /usr/bin/cut -c 7- | strings")
					set theartist to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a artist- | /usr/bin/cut -c 8- | strings")
					set thealbum to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a album- | /usr/bin/cut -c 7- | strings")
					set theyear to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a year- | /usr/bin/cut -c 6-")
					set thecomment to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a comment- | /usr/bin/cut -c 9- | strings")
					set thetrack to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a track- | /usr/bin/cut -c 7-")
					set thegenre to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a genre- | /usr/bin/cut -c 7- | strings")
					*)
				end if
			else
				error
			end if
		else
			if infoext is in {"mid", "midi", "aif", "aiff", "aifc", "amr", "caf"} then
				if infoext is in {"mid", "midi", "amr"} then
					do shell script quoted form of thePath & "/Contents/Resources/qt_info " & quoted form of theItem & " > " & durfile & " 2> /dev/null"
					set thedurseconds to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep 'movie duration' | /usr/bin/awk '{print $5}' | /usr/bin/awk -F . '{print $1}'")
					if thedurseconds is "" then
						return "?"
					end if
					set thedur to (timeswap(thedurseconds) of buttonsscript)
					if justdur is true then
						return {thedur, thedurseconds}
					else
						--					set thesize to (((round ((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1048.8)) / 1000) as string)
						set thesize to (((round ((((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1024)) / 1024) * 10) / 10) as string)
						set thebitdepth to 16
						if infoext is "amr" then
							set thehz to "8000"
							set thechan to 1
						else
							set thehz to "48000"
							set thechan to 2
						end if
						set thebitrate to ""
						set thetitle to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep 'Full Name' | /usr/bin/awk -F 'Full Name : ' '{print $2}' ; exit 0")
						if thetitle is "untitled" then
							set thetitle to ""
						end if
						set theartist to ""
						set thealbum to ""
						set theyear to ""
						set thecomment to ""
						set thetrack to ""
						set thegenre to ""
					end if
				end if
				if infoext is in {"aif", "aiff", "aifc", "caf"} then
					do shell script "/usr/bin/mdls " & quoted form of theItem & " > " & durfile & " 2> /dev/null"
					set thedurseconds to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemDurationSeconds | /usr/bin/awk '{print $3}' | /usr/bin/awk -F . '{print $1}'")
					if thedurseconds is "" then
						return "?"
					end if
					set thedur to (timeswap(thedurseconds) of buttonsscript)
					if justdur is true then
						return {thedur, thedurseconds}
					else
						--					set thesize to (((round ((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1048.8)) / 1000) as string)
						set thesize to (((round ((((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1024)) / 1024) * 10) / 10) as string)
						set thebitdepth to 16
						set thehz to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemAudioSampleRate | /usr/bin/awk '{print $3}'")
						set thechan to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemAudioChannelCount | /usr/bin/awk '{print $3}'")
						set thebitrate to ""
						set thetitle to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemTitle | /usr/bin/awk -F '= \"' '{print $2}' | /usr/bin/rev | /usr/bin/cut -c 2- | /usr/bin/rev")
						if thetitle is "untitled" then
							set thetitle to ""
						end if
						set theartist to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -A 1 kMDItemAuthors | /usr/bin/tail -1 | /usr/bin/awk -F '    \"' '{print $2}' | /usr/bin/rev | /usr/bin/cut -c 2- | /usr/bin/rev")
						set thealbum to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemAlbum | /usr/bin/awk -F '= \"'  '{print $2}' | /usr/bin/rev | /usr/bin/cut -c 2- | /usr/bin/rev")
						set theyear to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemRecordingYear | /usr/bin/awk '{print $3}'")
						set thecomment to ""
						set thetrack to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemAudioTrackNumber | /usr/bin/awk  -F '= \"' '{print $2}' | /usr/bin/rev | /usr/bin/cut -c 2- | /usr/bin/rev | /usr/bin/awk -F '/' '{print $1}'")
						set thegenre to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep kMDItemMusicalGenre | /usr/bin/awk  -F '= \"' '{print $2}' | /usr/bin/rev | /usr/bin/cut -c 2- | /usr/bin/rev")
					end if
				end if
			else
				error
			end if
		end if
	on error
		try
			-- FFMPEG AND OTHERS METHOD
			if infoext is "m4p" or infoext is "aa" or infoext is "rax" then
				set contents of data cell statusiconcell of last data row of data source of table view "table" of scroll view "table" of window "SongRedux" to (load image "error")
				set contents of data cell statustextcell of last data row of data source of table view "table" of scroll view "table" of window "SongRedux" to "error"
				return "DRM"
			else
				do shell script ffmpeg & " -i " & quoted form of theItem & " 2> " & durfile & " > /dev/null ; exit 0"
				set thedurseconds to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a 'Duration-' | cut -c 10-")
				if ": Unknown format" is in (do shell script "/bin/cat " & durfile) then
					return "?"
				end if
				if thedurseconds is "NA" then
					return "?"
				end if
				set thedur to timeswap(thedurseconds) of buttonsscript
				if justdur is true then
					return {thedur, thedurseconds}
				else
					--set thesize to (((round ((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1048.8)) / 1000) as string)
					set thesize to (((round ((((do shell script "ls -lan " & quoted form of theItem & " | awk '{print $5}'") / 1024)) / 1024) * 10) / 10) as string)
					set thebitdepth to 16
					set thehz to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a ',Audio,' | /usr/bin/grep -v 'parameters' | /usr/bin/head -1 | /usr/bin/awk -F , '{print $8}'")
					set thechan to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a ',Audio,' | /usr/bin/grep -a -v 'parameters' | /usr/bin/head -1 | /usr/bin/awk -F , '{print $9}'")
					set thebitrate to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep -a ',Audio,' | /usr/bin/grep -v 'parameters' | /usr/bin/head -1 | /usr/bin/awk -F , '{print $10}'")
					set thetitle to ""
					set theartist to ""
					set thealbum to ""
					set theyear to "0"
					set thecomment to ""
					set thetrack to ""
					set thegenre to ""
					try
						if iscd is true then
							if (do shell script "/bin/ps auxww | /usr/bin/grep '/Applications/iTunes.app' | /usr/bin/grep -cv grep") is "1" then
								set {thetitle, theartist, thealbum, thetrack, theyear, thegenre, thecomment} to (itunesinfo() of (load script (scripts path of main bundle & "/itunes.scpt" as POSIX file)))
							end if
						end if
					end try
				end if
			end if
		on error
			return "?"
		end try
	end try
	if justdur is false then
		do shell script ffmpeg & " -i " & quoted form of theItem & " 2> " & durfile & " > /dev/null ; exit 0"
		set theformat to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep 'Input ' | /usr/bin/cut -c 11- | /usr/bin/awk -F , '{print $1}'")
		set thecodec to (do shell script "/bin/cat " & durfile & " | /usr/bin/grep ',Audio,' | /usr/bin/grep -v parameters | /usr/bin/head -1 | /usr/bin/awk -F , '{print $7}'")
		
		if infoext is in {"mid", "midi"} then
			set theformat to "midi"
			set thecodec to "midi"
		end if
		
		return {theformat, thedur, thesize, thecodec, thebitdepth, thehz, thechan, thebitrate, thetitle, theartist, thealbum, theyear, thecomment, thetrack, thegenre}
	end if
end quickinfo

on audinfo(whichrow)
	if visible of window "advanced" is true and content of control "advancedtabs" of window "advanced" is 2 then
		set snippets to (load script (scripts path of main bundle & "/snippets.scpt" as POSIX file))
		set ffmpeg to whereffmpeg(false) of snippets
		tmpgetter(true) of snippets
		if whichrow is not null then
			set thisrow to contents of data cell fullpathcell of data row whichrow of data source of table view "table" of scroll view "table" of window "SongRedux"
		else
			try
				set thisrow to contents of data cell fullpathcell of selected data row of table view "table" of scroll view "table" of window "SongRedux"
			on error
				set thisrow to contents of data cell fullpathcell of data row 1 of data source of table view "table" of scroll view "table" of window "SongRedux"
			end try
		end if
		if whichrow is not null then
			set statuscell to contents of data cell statustextcell of data row whichrow of data source of table view "table" of scroll view "table" of window "SongRedux"
		else
			try
				set statuscell to contents of data cell statustextcell of selected data row of table view "table" of scroll view "table" of window "SongRedux"
			on error
				set statuscell to contents of data cell statustextcell of data row 1 of data source of table view "table" of scroll view "table" of window "SongRedux"
			end try
		end if
		set {theformat, thedur, thesize, thecodec, thebitdepth, thehz, thechan, thebitrate, thetitle, theartist, thealbum, theyear, thecomment, thetrack, thegenre} to quickinfo(thisrow, fullstarttime, false)
		tmpcleaner(false) of snippets
		
		set theformat to (formatgauntlet(theformat))
		set thecodec to (acodecgauntlet(thecodec))
		tell tab view item "advancedinfobox" of tab view "advancedbox" of window "advanced"
			set contents of text field "infoformat" to theformat
			set contents of text field "infolength" to thedur
			set contents of text field "infosize" to thesize & "MB"
			set contents of text field "infocodec" to thecodec
			--set contents of text field "infobitdepth" to thebitdepth
			set contents of text field "infohz" to thehz & "Hz"
			set contents of text field "infochan" to thechan
			set contents of text field "infobitrate" to thebitrate & " kbps"
		end tell
		if "aherror-" is in statuscell then
			set AppleScript's text item delimiters to "aherror-"
			tell tab view item "advancedinfobox" of tab view "advancedbox" of window "advanced"
				set contents of text field "errortext" of box "errorbox" to text item 2 of statuscell
				set visible of box "errorbox" to true
			end tell
		end if
	end if
	tmpcleaner(false) of snippets
	return true
end audinfo

on tableadder(theItem, fullstarttime)
	if enabled of table view "table" of scroll view "table" of window "SongRedux" is true then
		set theDataSource to (data source of table view "table" of scroll view "table" of window "SongRedux")
		-- duration check
		set thequickinfos to quickinfo(theItem, fullstarttime, true)
		if ("0:00" is in (thequickinfos as string) or "?" is in (thequickinfos as string)) and contents of default entry "addunknowns" of user defaults is false then
			--IGNORE FILE
			return true
		else
			set update views of theDataSource to false
			set newrow to (make new data row at end of data rows of theDataSource)
			--		set newrow to make new data row at end of data rows of theDataSource
			set contents of data cell fullpathcell of newrow to theItem as Unicode text
			-- status text
			set contents of data cell statustextcell of newrow to "ahready"
			-- status blip
			set contents of data cell statusiconcell of newrow to (load image "ready")
			-- shortname
			set AppleScript's text item delimiters to "/"
			set contents of data cell shortnamecell of newrow to (last text item of theItem as Unicode text)
			if "0:00" is in thequickinfos or "?" is in thequickinfos then
				set contents of data cell statusiconcell of newrow to (load image "readyunknown")
				set contents of data cell durationnumcell of newrow to 0
				set contents of data cell durationcell of newrow to "?"
			else
				set {contents of data cell durationcell of newrow, contents of data cell durationnumcell of newrow} to thequickinfos
			end if
			try
				do shell script "/usr/bin/killall tagreader"
			end try
			set update views of theDataSource to true
			return true
		end if
	else
		display alert (localized string "disabledtable") attached to window "SongRedux"
		error number -128
	end if
end tableadder

on opener()
	-- ON LAUNCHED --
	tell table view "table" of scroll view "table" of window "SongRedux"
		set contents to {""}
		tell data source 1
			set allows reordering to true
			try
				set contents to ""
			end try
		end tell
	end tell
	tell button "dragger" of window "SongRedux" to register drag types {"file names"}
end opener

on ASCII_Sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	repeat (count of items of my_list) times
		set the low_item to ""
		repeat with i from 1 to (count of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list as text
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if this_item comes before the low_item then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end ASCII_Sort

on acodecgauntlet(thecodec)
	set foundname to ""
	if thecodec is "aac" or thecodec is "mpeg4aac" or thecodec is "libfaad" then
		set foundname to "MPEG-4 Audio / AAC"
	end if
	if "pcm" is in thecodec then
		if "le" is in thecodec then
			set foundname to "Uncompressed Little Endian"
		else
			set foundname to "Uncompressed Big Endian"
		end if
	end if
	if "adpcm" is in thecodec then
		if "ima" is in thecodec then
			set foundname to "ADPCM IMA"
		else
			set foundname to "ADPCM"
		end if
	end if
	if thecodec is "alac" then
		set foundname to "Apple Lossless"
	end if
	if thecodec is "amr_nb" then
		set foundname to "AMR Narrowband"
	end if
	if thecodec is "amr_wb" then
		set foundname to "AMR Wideband"
	end if
	if thecodec is "dts" then
		set foundname to "DTS"
	end if
	if thecodec is "flac" then
		set foundname to "FLAC"
	end if
	if thecodec is "mp3" then
		set foundname to "MPEG-1 Layer 3 Audio / MP3"
	end if
	if thecodec is "mp2" then
		set foundname to "MPEG-1 Layer 2 Audio"
	end if
	if thecodec is "vorbis" then
		set foundname to "Ogg Vorbis"
	end if
	if thecodec is "ac3" then
		set foundname to "AC3"
	end if
	if thecodec is "wmav1" then
		set foundname to "Windows Media Audio 7"
	end if
	if thecodec is "wmav2" then
		set foundname to "Windows Media Audio 8/9"
	end if
	if thecodec is "midi" then
		set foundname to "MIDI"
	end if
	if foundname is "" then
		return thecodec
	else
		return foundname
	end if
end acodecgauntlet

on formatgauntlet(theformat)
	set foundname to ""
	if theformat is "3g2" or theformat is "3gp" then
		set foundname to "3GPP - Mobile"
	end if
	if theformat is "ac3" then
		set foundname to "AC3 Audio"
	end if
	if theformat is "matroska" then
		set foundname to "Matroska / MKV"
	end if
	if theformat is "mov" then
		set foundname to "QuickTime / MPEG-4"
	end if
	if theformat is "mp2" then
		set foundname to "MPEG-1 Layer 2"
	end if
	if theformat is "mp3" then
		set foundname to "MP3 Audio"
	end if
	if theformat is "mpeg" or theformat is "mpegvideo" then
		set foundname to "MPEG Program Stream"
	end if
	if theformat is "mpeg1video" then
		set foundname to "MPEG-1 Elementary Stream"
	end if
	if theformat is "mpeg2video" then
		set foundname to "MPEG-2 Elementary Stream"
	end if
	if theformat is "mpegts" then
		set foundname to "MPEG Transport Stream"
	end if
	if theformat is "nut" then
		set foundname to "Nut"
	end if
	if theformat is "ogg" or theformat is "ogm" then
		set foundname to "Ogg Media Format"
	end if
	if theformat is "rm" then
		set foundname to "Real Media"
	end if
	if theformat is "swf" then
		set foundname to "Flash Animation"
	end if
	if theformat is "wav" then
		set foundname to "WAVE"
	end if
	if theformat is "aiff" then
		set foundname to "Apple AIFF"
	end if
	if theformat is "asf" then
		set foundname to "Microsoft WMV / ASF"
	end if
	if theformat is "avi" then
		set foundname to "AVI"
	end if
	if theformat is "dv" then
		set foundname to "DV Video"
	end if
	if theformat is "dvd" then
		set foundname to "DVD VOB"
	end if
	if theformat is "flac" then
		set foundname to "FLAC"
	end if
	if theformat is "flv" then
		set foundname to "Flash Video"
	end if
	if theformat is "midi" then
		set foundname to "MIDI"
	end if
	if foundname is "" then
		return theformat
	else
		return foundname
	end if
end formatgauntlet
