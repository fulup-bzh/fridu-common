#!/bin/sh -f
#
# $Header: /Master/Common/Tools/Scripts/mail.sh,v 3.0.3.1 1998/05/30 11:25:53 fulup Exp $
#
#  Copyright(c) 1996 FRIDU a Free Software Company
#
# File      :   send.sh send a bin mail true metamail
# Projet    :   divers
# SubModule :   none
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: Writen
#      Author      : fulup
#      Date        : 23-oct-96
#      Revision    : 1.0
#      Source      : /pMaster/mics/divers/bin/send.sh
#      State       : alpha
#
#  Log
#  Writen
#
if test $# -eq 0
then
   echo "ERROR: syntaxe is send.sh -s subject -t user@destination -f filaneme"
   exit
fi

metasend -b $* -m raw/ -D "Binary-file from send.sh" -e base64 -S 500000   
