#!/bin/sh
#  $Header: /Master/Common/Config/Scripts/buildAll.sh,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#	Copyright(c) 96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   build.sh
# Projet    : 	vxNT
# SubModule :   build from cratch all vxNT tree
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Modification: Writen
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Config/Scripts/buildAll.sh,v $
#      State       : $State: Exp $
#
# Modification History
# ----------------------
# Revision 1.B  1997/04/07 10:42:41  fulup adpated to new Firdu project.mk organization
# Revision 1.1  1996/11/18 16:11:41  fulup written
# 

# start Makefile in order to build all project.

# tell bash under Linux to follow link
# ------------------------------------
if test ! -z "$BASH"
then
  set -P
fi

# check for a TOP env VAR
# -----------------------
if test -z "$TOP"
then
   TOP=`searchTop.sh`
   if test $? -ne 0
   then
     echo "ERROR: $TOP"
     exit
   fi
fi

if test -z "$PROJECT"
then
# We need both path to be absolute
  CURRENT_DIR=`pwd`; export CURRENT_DIR
  cd $TOP
  TOP=`pwd`; export TOP
  cd $CURRENT_DIR

# get project name
# -----------------
  PROJECT=`echo $CURRENT_DIR | sed s#$TOP/## | sed 's#/[1-z]*##g'`
  export PROJECT
fi

# check OS/ARCH config exist
# --------------------------
  echo ----------------------------------------------------------------------
  if test -f $TOP/config/arch/$ARCH_OS.mk
  then
	  echo "Build $VERSION for Architecture $ARCH_OS"
  else
	  echo "ERROR: ARCH_OS=[$ARCH_OS] unknow architecture in [config/arch/$ARCH_OS.mk not found]"
	  exit
  fi

# set tmp dir by priority to $HOME/tmp /tmp /temp
# -----------------------------------------------
  if test -d /temp
  then
	  TMPDIR=/temp
  fi

  if test -d /tmp
  then
	  TMPDIR=/tmp
  fi

  if test -d $HOME/tmp
  then
	  TMPDIR=$HOME/tmp
  fi

  echo "outputs redirected to $TMPDIR/make*-$ARCH_OS.[out|err]"
  echo ----------------------------------------------------------------------
  echo +

# Build from project root
# ------------------------
  cd $TOP/$PROJECT
  if test ! -f Etc/project.mk
  then
    echo "ERROR: $TOP/$PROJECT is not a Fridu project [project.mk not found]"
    exit
  fi

# get ct version
# --------------
  VERSION=`grep PRJ_VERSION $TOP/$PROJECT/Etc/project.mk`
  if test -z "$VERSION"
  then
        VERSION=Unknown
  fi

echo + Making clean [time=1-2mn]
# -----------------------------
  rm -f $TMPDIR/makeClean-$ARCH_OS.out
  rm -f $TMPDIR/makeClean-$ARCH_OS.err
  build.sh clean >>$TMPDIR/makeClean-$ARCH_OS.out 2>>$TMPDIR/makeClean-$ARCH_OS.err

echo + Making proto [time=2-4mn]
# -----------------------------
  rm -f $TMPDIR/makeProto-$ARCH_OS.out 
  rm -f $TMPDIR/makeProto-$ARCH_OS.err 
  build.sh proto >>$TMPDIR/makeProto-$ARCH_OS.out 2>>$TMPDIR/makeProto-$ARCH_OS.err

echo + Making all $VERSION [time=5-10mn]
# -------------------------------------
  rm -f $TMPDIR/makeAll-$ARCH_OS.out 
  rm -f $TMPDIR/makeAll-$ARCH_OS.err 
  build.sh all >>$TMPDIR/makeAll-$ARCH_OS.out 2>>$TMPDIR/makeAll-$ARCH_OS.err

# prompr user for output result
# -----------------------------
  echo +
  echo ----------------------------------------------------------------------
  echo check result in $TMPDIR/makeAll-$ARCH_OS.err
  echo to install use build.sh install 
  echo ---------------------------- done ------------------------------------

