#!/bin/sh
#  $Header: /Master/Common/Config/Scripts/version.sh,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   version.sh extract time and version stamp from module
# Projet    : 	vxNT
# SubModule :   config management
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: Writen
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Config/Scripts/version.sh,v $
#      State       : $State: Exp $
#

# Revision 1.1  1996/11/18 15:45:55  fulup  Writen
#

for TOKEN in $*
do
    if test -f $TOKEN
    then
	echo -------------------------------------------------------------------
	echo $TOKEN
	echo -------------------------------------------------------------------
	strings - $TOKEN | grep 'Version\.' 
	echo ===================================================================
    else

	for FILE in $TOP/exe/$ARCH_OS/[l,b]*/*${TOKEN}*
	do
	     RESULT=`strings - $FILE | grep Version`
	     if test ! -z "$RESULT"
	     then
		echo -------------------------------------------------------------------
		echo "                  $FILE"
		echo -------------------------------------------------------------------
		strings - $FILE | grep Version
		echo ===================================================================
             fi
	done
    fi
done
