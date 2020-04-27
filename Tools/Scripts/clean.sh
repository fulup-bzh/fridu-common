#!/bin/sh
#  $Header: /Master/Common/Tools/Scripts/clean.sh,v 3.1 1998/07/15 12:48:20 fulup Exp $
#
#  Copyright(c) 96-97 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Clean.sh
# Projet    :   Config
# SubModule :   Sheel tools
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:20 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Tools/Scripts/clean.sh,v $
#      State       : $State: Exp $
#
#Modification History 
#--------------------
#01a,22Aug97,fulup written 
#
#

if [ $# -eq 0 ]
then
  DIRNAME=.
else
  if test -d $1
  then 
    DIRNAME=$1
  else
    echo "Not a directory: $1"
    exit 1
  fi
fi

echo "Cleanup .bak & core file in $DIRNAME"

find $DIRNAME -name '*.bak' -exec rm {} \;
find $DIRNAME -name '*~' -exec rm {} \;
find $DIRNAME -name '.#*' -exec rm {} \;
find $DIRNAME -name 'core' -exec rm {} \;
find $DIRNAME -name 'vc40.pdb' -exec rm {} \;

