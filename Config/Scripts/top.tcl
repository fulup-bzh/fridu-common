#!/bin/sh -f
#
# Start Tcl interpretor
# \
exec tclsh  "$0" ${1+"$@"}
#
#  $Header: /Master/Common/Config/Scripts/top.tcl,v 3.3 1999/02/21 12:29:58 fulup Exp $
#
#	Copyright(c) 95-96 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   start.tcl start an Fridu Exe from TOP in debug or direct mode
# Projet    : 	Fridu a Free Software Company
# SubModule :   encapculate make call
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/02/21 12:29:58 $
#      Revision    : $Revision: 3.3 $
#      Source      : $Source: /Master/Common/Config/Scripts/top.tcl,v $
#      State       : $State: Exp $
#
# Modification History
# ----------------------
# 1b,1-feb99,fulup added LIBRARY_PATH
# 1a,20feb98,written from build.tcl
#

# Move down in directory tree in order to find top
# when top is founded compute projet dir name
# -------------------------------------------------
proc searchTop {} {
 global env
 
  # If we find a module.mk we only compile a module
  if [file exists Etc/Module.mk] \
  {
     set MOD_DIR [pwd]
     cd ..
     set PRJ_DIR [pwd]
     cd ..
     set TOP_DIR [pwd]

     # Note that . is either / or \ for NT
     regsub  -- $PRJ_DIR. $MOD_DIR  {} MODULE
     regsub  -- $TOP_DIR. $PRJ_DIR  {} PROJET

     # puts "TOP_DIR=$TOP_DIR PROJET=$PROJET MODULE=$MODULE"
     return [list $TOP_DIR $PROJET $MODULE]
   }

  # if we find a Project.mk we compile all modules from a project
  if [file exists Etc/Project.mk] \
  {
     if [catch {
                 foreach MOD [glob */Etc/Module.mk] \
                   { lappend MOD_DIR [lindex [file split $MOD] 0] }
               }
     ] {
       puts "ERROR: no Module.mk in Project/*/Etc (not a valid Fridu tree)"
       exit
  }
     set PRJ_DIR [pwd]
     cd ..
     set TOP_DIR [pwd]

     # Note that . is either / or \ for NT
     regsub  -- $PRJ_DIR. $MOD_DIR  {} MODULE
     regsub  -- $TOP_DIR. $PRJ_DIR  {} PROJET

     puts "TOP_DIR=$TOP_DIR PROJET=$PROJET MODULE=$MODULE"

     return [list $TOP_DIR $PROJET $MODULE]
   }
  
  # move back in directories tree until roor dir
  set prevDir [pwd]
  cd ..

  # Did we reach root dir ?
  if {[pwd] == $prevDir} \
  {
    puts "ERROR: searching project TOP Etc/Project.mk|Module.mk not found"
    puts "       (Not a valid Fridu project tree)" 
    exit
  }

  return [searchTop]
} ;# end searchTop


if {$argc < 1} {
  puts "ERROR: invalid argument (try start.tcl --help)"
  exit
}

if {[lindex $argv 0] == "--help"} {
  puts "start.tcl top an executable from TOP Exe directory"
  puts "Syntaxe: top.tcl \[--debug\] ExeName Arg1 ... Argn"
  exit
}

if {![info exist env(ARCH_OS)]} {
 puts "ERROR: ARCH_OS not defined"
 exit
}

set CURRENT [pwd]
set TOP  [lindex [searchTop] 0] 
set ARCH $env(ARCH_OS)

#update LIBRARY_PATH
if [info exist env(LD_LIBRARY_PATH)] {
    set LD_LIBRARY_PATH $TOP/Exe/$ARCH/lib:$env(LD_LIBRARY_PATH)
} else {
    set LD_LIBRARY_PATH $TOP/Exe/$ARCH/lib
}
set env(LD_LIBRARY_PATH) $LD_LIBRARY_PATH
if [info exist env(FRIDU_DEBUG)] {
    puts "LD_LIBRARY_PATH=$env(LD_LIBRARY_PATH)"
}       

if {[lindex $argv 0] == "--debug"} {
   set   env(GDB) 1
   set   ARGS  [lrange $argv 2 end]
   set   FILE  /tmp/gdb.cmd.[pid]
   set   FD    [open $FILE w]
   set   EXE   $TOP/Exe/$ARCH/bin/[lindex $argv 1]
   set   CMD   "exec gdb -x $FILE $EXE"
   puts  $FD   "set args $ARGS"
   close $FD
} else {
   set   EXE   $TOP/Exe/$ARCH/bin/[lindex $argv 0]
   set   ARGS  [lrange $argv 1 end]
   set   CMD   "exec $EXE $ARGS"
}

if {![file isfile $EXE]} {
  puts "ERROR: $EXE is not a valid file"
}

if {![info exist env(TTY)]} {set env(TTY) /dev/tty}
 
if [info exist env(JTCL_DEBUG)] {
 puts "TOP=$TOP"
 puts "ARCH_OS=$env(ARCH_OS)"
 puts "CMD=[lindex $argv 0]"
 puts "ARGS= $ARGS"
 puts "TTY=$env(TTY)"
 puts "Starting: $CMD"
}

# move back in original directory
cd $CURRENT

if [catch {eval $CMD >& $env(TTY)} ERR] \
   { puts "ERR=$ERR" }
   
#clean up gdb file if any
if [info exist FILE] {file delete $FILE}

