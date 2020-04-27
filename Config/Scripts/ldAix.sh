#!/bin/sh -f
#
# $Header: /Master/Common/Config/Scripts/ldAix.sh,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#  Copyright(c) 1996 FRIDU a Free Software Company [fridu@fridu.com]
#
# File      :   ldAix.sh build AIX shared library
# Projet    :   rtWeb
# SubModule :   
# Auteur    :   Fulup Ar Foll [fulup@fridu.com]
#
# Last
#      Modification: Writen from TCL shell
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Config/Scripts/ldAix.sh,v $
#      State       : $State: Exp $
#
#  $Log: ldAix.sh,v $
#  Revision 3.0.3.1  1998/05/30 11:25:52  fulup
#  First W95 version
#
#  Revision 1.1.1.1  1998/01/28 13:20:56  fulup
#  Moved to rubicon
#
#  Revision 1.1.1.1  1998/01/14 17:12:57  fulup
#  Newx arch for 3.01
#
#  Revision 1.1.1.1  1997/10/19 15:05:56  fulup
#  New project/module tree
#
#  Revision 1.1.1.1  1996/12/20 09:05:28  fulup
#  First Splited Master version
#
#  Revision 1.1.1.1  1996/12/08 13:47:09  fulup
#  Initiale cvs Version
#
#  Revision 1.1  1996/11/18 15:57:42  fulup
#   Writen from TCL shell
#
#
#

# ldAix ldCmd ldArg ldArg ...
#
# This shell script provides a wrapper for ld under AIX in order to
# create the .exp file required for linking.  Its arguments consist
# of the name and arguments that would normally be provided to the
# ld command.  This script extracts the names of the object files
# from the argument list, creates a .exp file describing all of the
# symbols exported by those files, and then invokes "ldCmd" to
# perform the real link.
#
# SCCS: @(#) ldAix 1.7 96/03/27 09:45:03

# Extract from the arguments the names of all of the object files.

args=$*
ofiles=""
for i do
    x=`echo $i | grep '[^.].o$'`
    if test "$x" != ""; then
	ofiles="$ofiles $i"
    fi
done

# Create the export file from all of the object files, using nm followed
# by sed editing.  Here are some tricky aspects of this:
#
# 1. Nm produces different output under AIX 4.1 than under AIX 3.2.5;
#    the following statements handle both versions.
# 2. Use the -g switch to nm instead of -e under 4.1 (this shows just
#    externals, not statics;  -g isn't available under 3.2.5, though).
# 3. Eliminate lines that end in ":": these are the names of object
#    files (relevant in 4.1 only).
# 4. Eliminate entries with the "U" key letter;  these are undefined
#    symbols (relevant in 4.1 only).
# 5. Eliminate lines that contain the string "0|extern" preceded by space;
#    in 3.2.5, these are undefined symbols (address 0).
# 6. Eliminate lines containing the "unamex" symbol.  In 3.2.5, these
#    are also undefined symbols.
# 7. If a line starts with ".", delete the leading ".", since this will
#    just cause confusion later.
# 8. Eliminate everything after the first field in a line, so that we're
#    left with just the symbol name.

nmopts="-g"
osver=`uname -v`
if test $osver -eq 3; then
  nmopts="-e"
fi
rm -f lib.exp
echo "#! " >lib.exp
/usr/ccs/bin/nm $nmopts -h $ofiles | sed -e '/:$/d' -e '/ U /d' -e '/[ 	]0|extern/d' -e '/unamex/d' -e 's/^\.//' -e 's/[ 	|].*//' | sort | uniq >>lib.exp

# Extract the name of the object file that we're linking.  If it's a .a
# file, then link all the objects together into a single file "shr.o"
# and then put that into the archive.  Otherwise link the object files
# directly into the .a file.

outputFile=`echo $args | sed -e 's/.*-o \([^ ]*\).*/\1/'`
noDotA=`echo $outputFile | sed -e '/\.a$/d'`
echo "noDotA=\"$noDotA\""
if test "$noDotA" = "" ; then
    linkArgs=`echo $args | sed -e 's/-o .*\.a /-o shr.o /'`
    echo $linkArgs
    eval $linkArgs
    echo ar cr $outputFile shr.o
    ar cr $outputFile shr.o
    rm -f shr.o
else
    eval $args
fi
