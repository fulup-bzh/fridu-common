#!/bin/sh -f
#
# Start Tcl interpretor
# \
exec tclsh  "$0" ${1+"$@"} 
#
#	Copyright(c) 95-98 Fridu a Free software company (Fulup Ar Foll)
#
# File      :   build.tcl
# Projet    : 	Fridu a Free Software Company
# SubModule :   encapculate make call
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/10 19:01:55 $
#      Revision    : $Revision: 3.4 $
#      Source      : $Source: /Master/Common/Config/Scripts/build.tcl,v $
#      State       : $State: Exp $
#
# Modification History
# ----------------------
# 1o,20feb99,fulup patched for solaris 
# 1m,17feb99,fulup corrected multi module conplete automatic rebuild
# 1n,09nov98,fulup moved to FRIDU_CONFIG env var
# 1m,16may98,fulup adapted to NT make sartup on demoIt model 
# 1n,15may98,fulup Corrected regexp for installation
# 1m,30mar98,fulup Add some value previouselly defined in default.mk
# 1l,16mar98,fulup Alphabetic sort of modules at build time
# 1k,03mar98,fulup added doc rule with jWrap and javadoc
# 1i,20feb98,fulup sorted directectory in alphabetic added dir list for depend tag
# 1h,27jan98,fulup added Exe target dir autobuild
# 1g,06jan98,fulup adapted to production tree and allowed multi modules make
# 1f,19oct97,fulup added Module concept
# 1e 16oct97,fulup corrected doc value
# 1d,20jun97,fulup added doc for html install
# 1c,01jun97,fulup correc glob when arriving in an empty dir
# 1b,21may97,fulup Make proto to work (add rule env var)
# 1a,19may97,fulup Writen in replacement to build.sh
#

# Move down in directory tree in order to find top
# when top is founded compute projet dir name
# -------------------------------------------------
proc searchTop {} \
{
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

     #puts "1:TOP_DIR=$TOP_DIR PROJET=$PROJET MODULE=$MODULE"
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

     #puts "2:TOP_DIR=$TOP_DIR PROJET=$PROJET MODULE=$MODULE"
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

# Search a Configuration either in dev or productioin tree
# ---------------------------------------------------------
proc searchConfig {} {
 global env
 
  # We have a special case when we run inside common project
  if [file exist $env(TOP)/Common/Config/arch/$env(ARCH_OS).mk] {
    return $env(TOP)/Common/Config
  }

  # For all other project we use production tree in FRIDU_HOME or default dir
  if {![info exists env(FRIDU_CONFIG)]} {
   if [catch {lsort -decreasing [glob $env(FRIDU_HOME)/Common*/lib/Config]} CONFIGPATH] {
      puts "ERROR: can't find any valid Common-xxx directory (check FRIDU_HOME)"
      exit
   }
  }
  
  # Now loop on PATH for Dvb Etc/package files
  foreach CFG_DIR $CONFIGPATH {
     if [file exists $CFG_DIR/arch/$env(ARCH_OS).mk] \
       { return $CFG_DIR }
  }

 if {![info exists env(FRIDU_CONFIG)]} \
 {
   puts "ERROR: Did not find any valid config for your arch"
   puts "       Check FRIDU_HOME & ARCH_OS env var"
   exit
 }
} ;# end searchConfig

# This effectively build module subcontracting make
# -------------------------------------------------
proc buildModule {CURRENT} \
{
 global env
 global argv
 global argv0
 
 if [info exists env(SUBDIRS)]  {unset env(SUBDIRS)}
 if [info exists env(EXTDIRS)]  {unset env(EXTDIRS)}
 if [info exists env(BUILD_MK)] {unset env(BUILD_MK)}
 if [info exists env(TCL)]      {unset env(TCL)}
 if [info exists env(TK)]       {unset env(TK)}
 if [info exists env(SHL)]      {unset env(SHL)}
 if [info exists env(INC)]      {unset env(INC)}

 # move in module dir
 if [catch {cd $CURRENT} ERR] {
    puts "ERROR: build.tcl $ERR"
    exit 1
 }

 if [info exist env(FRIDU_LOG)] {
   set CMD "exec -- $env(MAKE) -f $env(FRIDU_CONFIG)/makeSkel/generic.mk >& $env(FRIDU_LOG)"
 } else {
   set CMD "exec -- $env(MAKE) -f $env(FRIDU_CONFIG)/makeSkel/generic.mk >&@ stdout"
 }

 if [info exist env(FRIDU_DEBUG)] {
   puts "***OPTION=$argv *** PWD=[pwd]\n***CMD=$CMD"
 }

 # Computer Subdir name
 # --------------------
 set SUBDIRS {}; set EXTDIRS {}
 if {![catch {glob *} DIR_LST]} \
 {
  foreach DIR [glob *] \
  {
    if [file isdirectory $DIR] \
    {
     if [string match {[a-z]*} $DIR] \
     {
          # If directory start by a lower case take it
          lappend SUBDIRS $DIR
     } else {
          # don't include full upercase name
	 if {[string match {[A-Z][a-z]*} $DIR]} {lappend EXTDIRS $DIR}
     }
    }
  }
 } else {
 }

 # Search TCLSH path from path
 # ---------------------------
 if {![info exist env(TCLSH)]} {
  global tcl_library
  set TCL_DIR    [file split $tcl_library]
  set TCL_DIR    [lrange $TCL_DIR 0 [expr [llength $TCL_DIR] - 3]]
  set TCL_DIR    [eval file join $TCL_DIR bin tclsh*]
  set env(TCLSH) [lindex [glob $TCL_DIR] 0]
 
  if {![file exist $env(TCLSH)]} {
     puts "WARNING: tclsh command not found use tclsh80 & default path"
     set  env(TCLSH) tclsh80
  }
 }  

 # BUILD path from command line should alway be the exact one
 # ----------------------------------------------------------
 set env(BUILD)   $argv0

 # set mandatoty env var# search wish command for sub process
 # ---------------------
  set env(CURRENT_DIR) [lindex [file split $CURRENT] end]
  set env(RULE)        [lindex $argv end]

 if [info exist env(FRIDU_DEBUG)] {
   puts "TCLSH      =$env(TCLSH)"
   puts "BUILD      =$env(BUILD)"
   puts "RULE       =$env(RULE)"
   puts "CURRENT_DIR=$env(CURRENT_DIR) CURRENT=$CURRENT"
 }
 
 # Cleanup some user variable that would disturn build.tcl
 # -------------------------------------------------------
  set env(DOC) ""
  set env(TCL) ""
  set env(INC) ""
  set env(SHL) ""
  
  
 # puts "[pwd] CURRENT=$env(CURRENT_DIR) DIR=$SUBDIRS EXT=$EXTDIRS"
 if {![info exist env(TTY)]} {set env(TTY) /dev/tty}


 # set optional env var
 # --------------------
 if {$SUBDIRS != {}} {set env(SUBDIRS) [lsort $SUBDIRS]} 
 if {$EXTDIRS != {}} {set env(EXTDIRS) [lsort $EXTDIRS]} 

 if {![catch {glob {[a-z]*.mk} *.jTcl *.ht* *.gif *.jpg *.def *.version} TCL]} \
 {
   set env(TCL) $TCL
 }
 if {![catch {glob  *.licence *.doc *.piv *.tex *.text *.faq {*README*[a-z]}} DOC]}\
 {
   set env(DOC) $DOC 
 } 
 if {![catch {glob *.h *.rc}  INC]}    {set env(INC) $INC} 
 if {![catch {glob *.sh *.tcl} SHL]}   {set env(SHL) $SHL} 
 if [file exist Build.mk]              {set env(BUILD_MK) Build.mk} 

 # Check if make should look for dependency
 # ----------------------------------------
 if [info exist env(BUILD_MK)] {
   switch @$env(RULE) {
    @depend    -
    @clean     -
    @help      -
    @proto     {set env(INCL_DEP) 0}
    default    {set env(INCL_DEP) 1}
  }
 } else {
   # If no Build.mk don't check dependencies
   set env(INCL_DEP) 0
 }
 
 # comptute a depend tag
 set LEN [llength [file split $env(TOP)]]
 set TAG [lrange  [file split [pwd]] $LEN end]
 set env(DIR_TAG) [join $TAG @]
 # puts "tag = $env(DIR_TAG)"

 # puts "$CMD  $argv >& $env(TTY)"
 # effectively exec make and ignore exit status
 if [catch {eval $CMD  $argv } ERR] \
  { puts "ERR=$ERR" }

} ;# end build Module


# Start saving current direcory
set CURRENT [pwd]

# Compute TOP only at first call
if {![info exist env(__R_CALL)]} {

 set env(__R_CALL) 1
 
 # cleanup some variables make expect empty
 # -----------------------------------------
 foreach VAR [list EXE LIBS SHARED] { 
   if [info exist env($VAR)] {
      puts "WARNING: $VAR=$env($VAR) ignored"
      unset env($VAR)
   }
 }

 # recompute TOP even if already set
 # ---------------------------------
   set RET [searchTop]
   set env(TOP)     [lindex $RET 0]
   set env(PROJECT) [lindex $RET 1]
   set env(MODULES) [lsort [lindex $RET 2]]

 # Check ARCH_OS is defined
  if {![info exists env(ARCH_OS)]} \
  {
    puts "ERROR: \$ARCH_OS environment variable not set"; exit
  } else {
    # add $TOP/Exe/... in path
    set env(PATH) "$env(TOP)/Exe/$env(ARCH_OS)/bin:$env(PATH)"

    # Check target dir exist
    foreach DIR [list bin obj etc include lib jDoc] {
      if {![file isdirectory $env(TOP)/Exe/$env(ARCH_OS)/$DIR]} {
        puts "WARNING: creating target dir $env(TOP)/Exe/$env(ARCH_OS)/$DIR"
	if [catch {file mkdir $env(TOP)/Exe/$env(ARCH_OS)/$DIR} ERR] {
	  if [catch {exec mkdir -p $env(TOP)/Exe/$env(ARCH_OS)/$DIR} ERR] {
	  puts "ERROR: can't create target directory $ERR"
	  exit
          }
       }
     }
   }
  }


 # Set some mics value for makeskel
 if {![info exists env(MAKE)]}     {set env(MAKE) "gmake -r"}
 if {![info exists env(HOSTNAME)]} {set env(HOSTNAME) [exec hostname]}
 if {![info exists env(DATE)]}     {
     set env(DATE) [clock format [clock seconds] -format {%d-%h-%y\[%Hh%M\]}]
 }
 
 # Search makefile skeleton
  if {![info exist env(FRIDU_CONFIG)]} \
     {set env(FRIDU_CONFIG) [searchConfig]}

 if [info exist env(FRIDU_DEBUG)] {
   puts " TOP=$env(TOP)\n PRJ=$env(PROJECT)\n MODS=$env(MODULES)\n FRIDU_CONFIG=$env(FRIDU_CONFIG)"
 }
}

# Effectively build module(s) from project
if {[llength $env(MODULES)] == 1} {
  # If we have only one module we only build current dir
  set env(MODULE) $env(MODULES)

  # Check is we have a destination directory
  if {[lindex $argv 0] == "-D"} {
     set CURRENT [file join $CURRENT [lindex $argv 1]]
     set argv [lrange $argv 2 end]
  }
  buildModule $CURRENT
} else {

  # check if first argument is -s
  if {[lindex $argv 0] == "-s"} {
    set FIRST_OPT  1
    set SILENT_OPT "-s"
  } else {
    set FIRST_OPT 0
  }

  # in project root directory user should have an effective choice
  if {[llength $argv] == $FIRST_OPT} {
    puts "-----------------------------------------------------------------"
    puts "ERROR  : in Project root directory user sould select an option"
    puts "Example: build.tcl -s \[ clean | proto | all | install | world \]"
    puts "-----------------------------------------------------------------"
    puts "ERROR  : in Project root directory user sould select an option"
    exit
  }  

  switch -- [lindex $argv $FIRST_OPT] {
      world    {set OPTIONS [list clean proto lib shared exe install]}
      all      {set OPTIONS [list lib shared exe]}
      default  {set OPTIONS [lindex $argv $FIRST_OPT]}
  }

  # save MODULES in order making multi module as a multi call
  set MODULES $env(MODULES)

  foreach OPTION $OPTIONS {
    # when build is start from TOP we build all modules
    foreach MOD $MODULES {
      # check we did not start from an invalid project
      if {"$env(TOP)/$env(PROJECT)" != "$CURRENT"} \
      {
        puts "$env(TOP)/$env(PROJECT) != $CURRENT"
        puts "You in not in a module tree from a Fridu project (Module.mk not found)"
        exit
      }
      puts "### Module=$MOD OPT=$OPTION ###"
      set env(MODULES) $MOD
      set env(MODULE)  $MOD
      set env(LST_DIR) [join [concat $env(PROJECT) $MOD] @]
      set argv    [concat $SILENT_OPT $OPTION]
      buildModule $CURRENT/$MOD
    }
  }
}
