-- itunes.applescript
-- SongRedux

global iscd
global cdtracknum

on itunesinfo()
	tell application "iTunes"
		set cdsource to playlist 1 of (first source whose kind is audio CD)
		set thistrack to (audio CD track (cdtracknum as number) of cdsource)
		set thetitle to name of thistrack
		set theartist to artist of thistrack
		set thetrack to cdtracknum as string
		set thealbum to album of thistrack
		set thegenre to genre of thistrack
		set theyear to (year of thistrack) as string
		set thealbum to album of thistrack
		set thecomment to comment of thistrack
	end tell
	return {thetitle, theartist, thealbum, thetrack, theyear, thegenre, thecomment}
end itunesinfo

on itunesadd(itunesfile)
	try
		tell application "iTunes" to add itunesfile
		delay 1
		if contents of default entry "itunesdelete" of user defaults is true then
			do shell script "/bin/mv " & quoted form of POSIX path of itunesfile & " ~/.Trash/"
		end if
	end try
end itunesadd
--  Created by Tyler Loch on 4/9/08.
--  Copyright 2008 __MyCompanyName__. All rights reserved.
