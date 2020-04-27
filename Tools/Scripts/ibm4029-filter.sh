#! /usr/local/pMaster/misc/magicfilter-1.1/bin/magicfilter
#
# Magic filter setup file for the HP LaserJet with 1.5 Mb of RAM or more
# THIS FILE IS UNTESTED!
#
# This file has been automatically adapted to your system.
#

# PostScript files: use GhostScript to convert to DVI file and pipe again
0	%!		filter	/usr/bin/gs  -q -dSAFER -dNOPAUSE \
	-r300 -sDEVICE=laserjet -sOutputFile=- -

# DVI files: print directely to HP printer whih no conversion
0	\367\002	ffilter	/usr/bin/dvilj -s26 -q -e- $FILE

# print C file true 
0   #in		pipe  /usr/local/lib/groff/tmac/vfontedpr \
	 -d /usr/local/lib/groff/tmac/vgrindefs -h "$LOGNAME" -lc - \
	| cat /usr/local/lib/groff/tmac/tmac.vgrind - 
0   /*			pipe /usr/local/lib/groff/tmac/vfontedpr \
	 -d /usr/local/lib/groff/tmac/vgrindefs -h "$LOGNAME" -lc - \
	| cat /usr/local/lib/groff/tmac/tmac.vgrind -
0   #!/bin/sh	pipe /usr/local/lib/groff/tmac/vfontedpr \
	 -d /usr/local/lib/groff/tmac/vgrindefs -h "$LOGNAME" -lsh - \
	| cat /usr/local/lib/groff/tmac/tmac.vgrind -
0   #!/bin/csh	pipe /usr/local/lib/groff/tmac/vfontedpr \
	 -d /usr/local/lib/groff/tmac/vgrindefs -h "$LOGNAME" -lcsh - \
	| cat /usr/local/lib/groff/tmac/tmac.vgrind -

# compress'd data
0	\037\235	pipe	/bin/gzip  -cdq 

# compressed files (packed, gzip, freeze, and SCO LZH respectively)
0	\037\036	pipe	/bin/gzip  -cdq 
0	\037\213	pipe	/bin/gzip  -cdq 
0	\037\236	pipe	/bin/gzip  -cdq 
0	\037\240	pipe	/bin/gzip  -cdq 

# troff documents
0	.so\040		reject	Attempted to print a ".so" troff file.
0	.\?\?\040	fpipe	`/usr/bin/grog  -Tdvi $FILE | sed 's/\.SH.*$//'`
0	'\?\?\040	fpipe	`/usr/bin/grog  -Tdvi $FILE` 
0	.\\\"		fpipe	`/usr/bin/grog  -Tdvi $FILE`
0	'\\\"		fpipe	`/usr/bin/grog  -Tdvi $FILE`
0	'.\\\"		fpipe	`/usr/bin/grog  -Tdvi $FILE`
0	\\\"		fpipe	`/usr/bin/grog  -Tdvi $FILE`

# ditroff
0	"x T ps"	pipe	/usr/bin/grops 
0	"x T dvi"	pipe    /usr/bin/grodvi
0	"x T ascii"	pipe	/usr/bin/grotty 
0	"x T latin1" pipe	/usr/bin/grotty 
0	"x T lj4"	reject	Cannot print LJ4 ditroff files.

#
#reject latex file and xfig file
#
0       #FIG            reject  Attempted to print a xfig file
0       \input          reject  Attempted to print a Latex file


# Portable bit-, grey- and pixmaps: convert to PostScript
0	P1\n		reject	Cannot print PBM files on this printer.
0	P2\n		reject	Cannot print PGM files on this printer.
0	P3\n		reject	Cannot print PPM files on this printer.
0	P4\n		reject	Cannot print PBM files on this printer.
0	P5\n		reject	Cannot print PGM files on this printer.
0	P6\n		reject	Cannot print PPM files on this printer.

# PCL control codes almost always start with a "reset" and are
# usually followed by at least one additional PCL control code.
0	\033E\033	cat

# PJL: Sorry, this printer doesn't do PJL
0	\033%-12345X	reject	Cannot print PJL files on this printer.
0	"@PJL "		reject	Cannot print PJL files on this printer.
0	@PJL\t		reject	Cannot print PJL files on this printer.
0	@PJL\r		reject	Cannot print PJL files on this printer.
0	@PJL\n		reject	Cannot print PJL files on this printer.


# GIF files: convert to PPM
0	GIF87a		reject	Cannot print GIF images on this printer.
0	GIF89a		reject	Cannot print GIF images on this printer.

# JFIF (JPEG) files: convert to PPM/PGM
0	\377\330\377\340\?\?JFIF\0	reject	Cannot print JPEG/JFIF \
	images on this printer.

# TIFF files (lousy magic!!)
0	MM		reject	Cannot print TIFF images on this printer.
0	II		reject	Cannot print TIFF images on this printer.

# BMP files (even lousier magic -- I guess that's what you can expect
# for something out of Microsoft)
0	BM\?\?\?\?\?\?\?\?\?\?\?\?\x0c	reject	Cannot print OS/2 1.x \
	bitmaps on this printer.
0	BM\?\?\?\?\?\?\?\?\?\?\?\?\x40	reject	Cannot print OS/2 2.x \
	bitmaps on this printer.
0	BM\?\?\?\?\?\?\?\?\?\?\?\?\x28	reject	Cannot print Windows 3.x \
	bitmaps on this printer.

# Sun rasterfiles
0	\x59\xa6\x6a\x95 reject	Cannot print Sun rasterfiles on this printer.

# SGI Imagelib (RGB) files
0	\x1\xda		reject	Cannot print SGI RGB files on this printer.
0	\xda\x1		reject	Cannot print SGI RGB files on this printer.

#
# Standard rejects... things we don't want to print
#

# Various archive formats
257	ustar\0		reject	Attempted to print a tar file.
257	"ustar  \0"	reject	Attempted to print a tar file.
0	07070		reject	Attempted to print a cpio file.
0	PK\3\4		reject	Attempted to print a zip file.
20	\xdc\xa7\xc7\xfd reject	Attempted to print a zoo file.

# Binaries (Linux): reject with email message
0	\013\1d\0	reject	Attempted to print a compiled binary.
0	\100\1d\0	reject	Attempted to print a compiled binary.
0	\007\1d\0	reject	Attempted to print a compiled binary.
0	\314\0d\0	reject	Attempted to print a compiled binary.
0	\177ELF		reject	Attempted to print an ELF object.
0	\007\001\0	reject	Attempted to print an object file.
216	\021\001\0\0	reject	Attempted to print a core dump file.
0	!<arch>		reject	Attempted to print an archive.
0	=<ar>		reject	Attempted to print an archive.

# Don't confuse this one with troff!
0	.snd		reject	Attempted to print Sun/NeXT audio data.

# wild guesses
# PCL control codes start with <ESC>
0	\033		cat
# optimistic troff magic
0	.		fpipe	`/usr/bin/grog  -Tps $FILE` 
# wacko troff magic
0	'''		fpipe	`/usr/bin/grog  -Tps $FILE` 

# Default entry -- for normal (text) files.  MUST BE LAST.
default			cat	\eE\e&k2G\e(0N	\eE >/tmp/default.prn


