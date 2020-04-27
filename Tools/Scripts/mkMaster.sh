#!/bin/sh -f
#
#  $Header: /Master/Common/Tools/Scripts/mkMaster.sh,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   mkMaster.sh add RCS dir in all directory starting by a lowercase
# Projet    : 	vxNT
# SubModule :   add a make file in all directory
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: Writen
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:53 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Tools/Scripts/mkMaster.sh,v $
#      State       : $State: Exp $
#
# $Log: mkMaster.sh,v $
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
# Revision 1.1.1.1  1996/12/08 13:47:09  fulup
# Initiale cvs Version
#
# Revision 1.1  1996/11/18 15:45:51  fulup
#  Writen
#
# Revision 1.2  1996/11/18 14:37:21  fulup
#  Writen
#

# allows all group members to write in new directories
umask 007

if test -d "$1"
then
        chmod -R ug+rxw $1
	find $1 -name '[a-z]*' -type d \
            -exec mkdir -p {}\/RCS \; \
            -exec chmod g+ws {} \; 
	find $1 -name '*' -type f -exec chmod a-w {} \;
else
	echo "ERROR: syntaxe is rcs.sh dirname"
fi
