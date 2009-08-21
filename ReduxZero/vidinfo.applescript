-- videoinfo.applescript
-- ReduxZero

global preinfovcodec
global preinfoacodec
global preinfocontainer

on vidinfo(thequotedorigpath)
	set tilde to ""
	set rzver to "131"
	set thePath to path of the main bundle as string
	set thequotedapppath to quoted form of thePath
	set ffmpegloc to (thequotedapppath & "/Contents/Resources/")
	do shell script "" & ffmpegloc & "ffmpeg -i " & thequotedorigpath & " 2> /tmp/reduxzero_info ; exit 0"
	
	
	set infowidth to (do shell script "cat /tmp/reduxzero_info | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $9}'")
	set infoheight to (do shell script "cat /tmp/reduxzero_info | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $10}'")
	set infofps to (do shell script "cat /tmp/reduxzero_info | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $11}'")
	set infocolorspace to (do shell script "cat /tmp/reduxzero_info | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $8}'")
	set preinfovcodec to (do shell script "cat /tmp/reduxzero_info | grep ',Video,' | grep -v parameters | head -1 | awk -F , '{print $7}'")
	set preinfoacodec to (do shell script "cat /tmp/reduxzero_info | grep ',Audio,' | grep -v parameters | head -1 | awk -F , '{print $7}'")
	set infoar to (do shell script "cat /tmp/reduxzero_info | grep ',Audio,' | grep -v parameters | head -1 | awk -F , '{print $8}'")
	set infoac to (do shell script "cat /tmp/reduxzero_info | grep ',Audio,' | grep -v parameters | head -1 | awk -F , '{print $9}'")
	set infoab to (do shell script "cat /tmp/reduxzero_info | grep ',Audio,' | grep -v parameters | head -1 | awk -F , '{print $10}'")
	set preinfodur to (do shell script "cat /tmp/reduxzero_info | grep 'Duration-' | cut -c 10-")
	set infobitrate to (do shell script "cat /tmp/reduxzero_info | grep 'bitrate-' | cut -c 9-")
	set infosize to (((round ((do shell script "ls -lan " & thequotedorigpath & " | awk '{print $5}'") / 1024)) / 1000) as string)
	set preinfocontainer to (do shell script "cat /tmp/reduxzero_info | grep 'Input ' | cut -c 11- | awk -F , '{print $1}'")
	vcodecgauntlet()
	acodecgauntlet()
	containergauntlet()
	
	--Duration
	set theseconds to preinfodur
	set theminutes to (round (theseconds / 60) rounding down)
	set theseconds to (((theminutes) * 60) - theseconds) * -1
	set text item delimiters to ""
	if (count of text items of (theseconds as string)) is 1 then
		set theseconds to ("0" & (theseconds))
	end if
	set contents of text field "length" of window "vidinfo" to (theminutes & ":" & theseconds as string)
	
	--Bitrate
	set contents of text field "bitrate" of window "vidinfo" to infobitrate & " kbits/sec"
	
	--Size
	set contents of text field "size" of window "vidinfo" to infosize & "MB"
	
	--Dimensions
	set contents of text field "widthheight" of window "vidinfo" to (infowidth & "x" & infoheight)
	
	--Colorspace
	set contents of text field "colorspace" of window "vidinfo" to infocolorspace
	
	--Framerate
	set contents of text field "framerate" of window "vidinfo" to infofps
	
	--Fidelity
	set contents of text field "ar" of window "vidinfo" to infoar & " Hz"
	
	--Channels
	set contents of text field "ac" of window "vidinfo" to infoac
	
	--Audio Bitrate
	set contents of text field "ab" of window "vidinfo" to infoab & " kbits/sec"
	
end vidinfo

on vcodecgauntlet()
	set contents of text field "vcodec" of window "vidinfo" to preinfovcodec
	if preinfovcodec is "mpeg4" then
		set contents of text field "vcodec" of window "vidinfo" to "MPEG-4 Video"
	end if
	if preinfovcodec is "mpeg2video" then
		set contents of text field "vcodec" of window "vidinfo" to "MPEG-2"
	end if
	if preinfovcodec is "mpeg1video" then
		set contents of text field "vcodec" of window "vidinfo" to "MPEG-1"
	end if
	if preinfovcodec is "cinepak" then
		set contents of text field "vcodec" of window "vidinfo" to "Cinepak"
	end if
	if preinfovcodec is "dvvideo" then
		set contents of text field "vcodec" of window "vidinfo" to "DV Video"
	end if
	if preinfovcodec is "flv" then
		set contents of text field "vcodec" of window "vidinfo" to "Flash 6/7 Video"
	end if
	if preinfovcodec is "h263" then
		set contents of text field "vcodec" of window "vidinfo" to "H.263"
	end if
	if preinfovcodec is "h264" then
		set contents of text field "vcodec" of window "vidinfo" to "H.264 / AVC"
	end if
	if preinfovcodec is "huffyuv" then
		set contents of text field "vcodec" of window "vidinfo" to "HuffYUV"
	end if
	if preinfovcodec is "indeo3" then
		set contents of text field "vcodec" of window "vidinfo" to "Intel Indeo 3"
	end if
	if preinfovcodec is "mjpeg" then
		set contents of text field "vcodec" of window "vidinfo" to "Motion JPEG"
	end if
	if preinfovcodec is "mjpegb" then
		set contents of text field "vcodec" of window "vidinfo" to "Motion JPEG B"
	end if
	if "msmpeg4" is in preinfovcodec then
		set contents of text field "vcodec" of window "vidinfo" to "MS-MPEG4"
	end if
	if preinfovcodec is "qtrle" then
		set contents of text field "vcodec" of window "vidinfo" to "QuickTime Animation"
	end if
	if preinfovcodec is "rawvideo" then
		set contents of text field "vcodec" of window "vidinfo" to "Uncompressed Video"
	end if
	if preinfovcodec is "rv20" then
		set contents of text field "vcodec" of window "vidinfo" to "Real Video G2"
	end if
	if preinfovcodec is "svq1" then
		set contents of text field "vcodec" of window "vidinfo" to "Sorenson Video"
	end if
	if preinfovcodec is "svq3" then
		set contents of text field "vcodec" of window "vidinfo" to "Sorenson Video 3"
	end if
	if preinfovcodec is "theora" then
		set contents of text field "vcodec" of window "vidinfo" to "Ogg Theora"
	end if
	if preinfovcodec is "vp3" then
		set contents of text field "vcodec" of window "vidinfo" to "On2 VP3"
	end if
	if preinfovcodec is "vp5" or preinfovcodec is "vp6" or preinfovcodec is "vp6f" then
		set contents of text field "vcodec" of window "vidinfo" to "On2 VP6"
	end if
	if preinfovcodec is "wmv1" then
		set contents of text field "vcodec" of window "vidinfo" to "Windows Media Video 7"
	end if
	if preinfovcodec is "wmv2" then
		set contents of text field "vcodec" of window "vidinfo" to "Windows Media Video 8"
	end if
	if preinfovcodec is "wmv3" then
		set contents of text field "vcodec" of window "vidinfo" to "Windows Media Video 9 / VC-1"
	end if
	if preinfovcodec is "fraps" then
		set contents of text field "vcodec" of window "vidinfo" to "Fraps"
	end if
end vcodecgauntlet




on acodecgauntlet()
	set contents of text field "acodec" of window "vidinfo" to preinfoacodec
	if preinfoacodec is "aac" or preinfoacodec is "mpeg4aac" then
		set contents of text field "acodec" of window "vidinfo" to "MPEG-4 Audio / AAC"
	end if
	if "pcm" is in preinfoacodec then
		if "le" is in preinfoacodec then
			set contents of text field "acodec" of window "vidinfo" to "Uncompressed Little Endian"
		else
			set contents of text field "acodec" of window "vidinfo" to "Uncompressed Big Endian"
		end if
	end if
	if "adpcm" is in preinfoacodec then
		if "ima" is in preinfoacodec then
			set contents of text field "acodec" of window "vidinfo" to "ADPCM IMA"
		else
			set contents of text field "acodec" of window "vidinfo" to "ADPCM"
		end if
	end if
	if preinfoacodec is "alac" then
		set contents of text field "acodec" of window "vidinfo" to "Apple Lossless"
	end if
	if preinfoacodec is "amr_nb" then
		set contents of text field "acodec" of window "vidinfo" to "AMR Narrowband"
	end if
	if preinfoacodec is "amr_wb" then
		set contents of text field "acodec" of window "vidinfo" to "AMR Wideband"
	end if
	if preinfoacodec is "dts" then
		set contents of text field "acodec" of window "vidinfo" to "DTS"
	end if
	if preinfoacodec is "flac" then
		set contents of text field "acodec" of window "vidinfo" to "FLAC"
	end if
	if preinfoacodec is "mp3" then
		set contents of text field "acodec" of window "vidinfo" to "MPEG-1 Layer 3 Audio / MP3"
	end if
	if preinfoacodec is "mp2" then
		set contents of text field "acodec" of window "vidinfo" to "MPEG-1 Layer 2 Audio"
	end if
	if preinfoacodec is "vorbis" then
		set contents of text field "acodec" of window "vidinfo" to "Ogg Vorbis"
	end if
	if preinfoacodec is "ac3" then
		set contents of text field "acodec" of window "vidinfo" to "AC3"
	end if
	if preinfoacodec is "wmav1" then
		set contents of text field "acodec" of window "vidinfo" to "Windows Media Audio 7"
	end if
	if preinfoacodec is "wmav2" then
		set contents of text field "acodec" of window "vidinfo" to "Windows Media Audio 8/9"
	end if
end acodecgauntlet


on containergauntlet()
	set contents of text field "format" of window "vidinfo" to preinfocontainer
	if preinfocontainer is "3g2" or preinfocontainer is "3gp" then
		set contents of text field "format" of window "vidinfo" to "3GPP - Mobile"
	end if
	if preinfocontainer is "ac3" then
		set contents of text field "format" of window "vidinfo" to "AC3 Audio"
	end if
	if preinfocontainer is "matroska" then
		set contents of text field "format" of window "vidinfo" to "Matroska / MKV"
	end if
	if preinfocontainer is "mov" then
		if preinfovcodec is "mpeg4" or preinfovcodec is "h264" then
			set contents of text field "format" of window "vidinfo" to "MPEG-4"
		else
			set contents of text field "format" of window "vidinfo" to "QuickTime"
		end if
	end if
	if preinfocontainer is "mp2" then
		set contents of text field "format" of window "vidinfo" to "MPEG-1 Layer 2"
	end if
	if preinfocontainer is "mp3" then
		set contents of text field "format" of window "vidinfo" to "MPEG-1 Layer 3 / MP3"
	end if
	if preinfocontainer is "mpeg" or preinfocontainer is "mpegvideo" then
		set contents of text field "format" of window "vidinfo" to "MPEG Program Stream"
	end if
	if preinfocontainer is "mpeg1video" then
		set contents of text field "format" of window "vidinfo" to "MPEG-1 Elementary Stream"
	end if
	if preinfocontainer is "mpeg2video" then
		set contents of text field "format" of window "vidinfo" to "MPEG-2 Elementary Stream"
	end if
	if preinfocontainer is "mpegts" then
		set contents of text field "format" of window "vidinfo" to "MPEG Transport Stream"
	end if
	if preinfocontainer is "nut" then
		set contents of text field "format" of window "vidinfo" to "Nut"
	end if
	if preinfocontainer is "ogg" or preinfocontainer is "ogm" then
		set contents of text field "format" of window "vidinfo" to "Ogg Media Format"
	end if
	if preinfocontainer is "rm" then
		set contents of text field "format" of window "vidinfo" to "Real Media"
	end if
	if preinfocontainer is "swf" then
		set contents of text field "format" of window "vidinfo" to "Flash Animation"
	end if
	if preinfocontainer is "wav" then
		set contents of text field "format" of window "vidinfo" to "WAVE"
	end if
	if preinfocontainer is "aiff" then
		set contents of text field "format" of window "vidinfo" to "Apple AIFF"
	end if
	if preinfocontainer is "asf" then
		set contents of text field "format" of window "vidinfo" to "Microsoft WMV / ASF"
	end if
	if preinfocontainer is "avi" then
		set contents of text field "format" of window "vidinfo" to "AVI"
	end if
	if preinfocontainer is "dv" then
		set contents of text field "format" of window "vidinfo" to "DV Video"
	end if
	if preinfocontainer is "dvd" then
		set contents of text field "format" of window "vidinfo" to "DVD VOB"
	end if
	if preinfocontainer is "flac" then
		set contents of text field "format" of window "vidinfo" to "FLAC"
	end if
	if preinfocontainer is "flv" then
		set contents of text field "format" of window "vidinfo" to "Flash Video"
	end if
end containergauntlet

--  Created by Tyler Loch on 1/22/07.
--  Copyright 2007 __MyCompanyName__. All rights reserved.
