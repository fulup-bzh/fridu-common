#!/bin/sh -f 
#
#  $Header: /Master/Common/Tools/Scripts/cancel.sh,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   cancel.sh cancel a file in the Master
# Projet    : 	vxNT
# SubModule :   encapculated RCS call
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: Writen
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:53 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Tools/Scripts/cancel.sh,v $
#      State       : $State: Exp $
#
# $Log: cancel.sh,v $
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
# Revision 1.1  1996/11/18 15:45:45  fulup
#  Writen
#
# Revision 1.1  1996/11/18 15:08:53  fulup
#  Writen
#
# Revision 1.1  1996/11/18 14:04:13  fulup
#  Writen
#

# take good TOP dir and then call make with apropriated rules file

# tell bash under Linux to follow link
set -P

for FILE in $*
do
	if test -f $FILE
        then
		rcs -u $FILE || break
		rm     $FILE || break
		ln -s RCS/../$FILE $FILE
		
	else
		echo "WARNING: $FILE not a plain file ignored"
        fi
done
