#!/bin/sh -f
#
#  $Header: /Master/Common/Tools/Scripts/out.sh,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   out.sh checkout a file in the Master
# Projet    : 	vxNT
# SubModule :   encapculated RCS call
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: rebuild link when co failed
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:53 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Tools/Scripts/out.sh,v $
#      State       : $State: Exp $
#
# $Log: out.sh,v $
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
# Revision 1.1.1.1  1996/12/20 09:05:29  fulup
# First Splited Master version
#
# Revision 1.1.1.1  1996/12/08 13:47:10  fulup
# Initiale cvs Version
#
# Revision 1.2  1996/11/25 11:07:20  fulup
#  rebuild link when co failed
#
# Revision 1.1  1996/11/18 15:45:52  fulup
#  Writen
#

# tell bash under Linux to follow link
set -P

# take good TOP dir and then call make with apropriated rules file

for FILE in $*
do
	if test -L $FILE
        then
		rm $FILE
		co -l $FILE || ln -s ./RCS/../$FILE . 
	else
		echo "WARNING: $FILE not a link ignored"
        fi
done
