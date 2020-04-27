#!/bin/sh -f 
#
#  $Header: /Master/Common/Tools/Scripts/in.sh,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   in.sh checkin a file in the Master
# Projet    : 	vxNT
# SubModule :   encapculated RCS call
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: add ; in sed command for metahtml
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:53 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Tools/Scripts/in.sh,v $
#      State       : $State: Exp $
#
# $Log: in.sh,v $
# Revision 3.0.3.1  1998/05/30 11:25:53  fulup
# First W95 version
#
# Revision 1.1.1.1  1998/01/28 13:20:57  fulup
# Moved to rubicon
#
# Revision 1.1.1.1  1998/01/14 17:12:58  fulup
# Newx arch for 3.01
#
# Revision 1.1.1.1  1997/10/19 15:05:56  fulup
# New project/module tree
#
# Revision 1.1.1.1  1996/12/20 09:05:28  fulup
# First Splited Master version
#
# Revision 1.1.1.1  1996/12/08 13:47:09  fulup
# Initiale cvs Version
#
# Revision 1.5  1996/11/27 20:38:25  fulup
#  add ; in sed command for metahtml
#
# Revision 1.4  1996/11/24 16:48:30  fulup
#  Echo selected modhist when checkin
#
# Revision 1.3  1996/11/24 16:46:27  fulup
#  Echo selected modhist when checkin
#
# Revision 1.2  1996/11/24 15:04:19  fulup
#  add auto history facility
#
#
# Revision 1.1  1996/11/18 14:04:13  fulup
#  Writen
#

# tell bash under Linux to follow link
set -P

for FILE in $*
do
	if test -f $FILE
        then
                MOD_HIST=`sed -n '/^[\#, ,/,*,;]*Modification./s///p' <$FILE`
		echo modhist=[$MOD_HIST]
		ci -m"$MOD_HIST" $FILE || break
		ln -s RCS/../$FILE $FILE
		cd RCS/..
		co -q -u $FILE
		
	else
		echo "WARNING: $FILE not a plain file ignored"
        fi
done
