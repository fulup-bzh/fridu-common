#!/usr/bin/tclsh
#
#  Copyright(c) 2000 FRIDU a Free Software Company [fridu@fridu.com]
#
# FILE      :   redirector.tcl Squid redirector
# Projet    :   Diwan Internet acces
# SubModule :   Redirector
# Auteur    :   Fulup Ar Foll [fulup@fridu.com]
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/08 08:34:20 $
#      Revision    : $Revision: 1.2 $
#      Source      : $Source: /Master/jTcl/zDemo/Rpc/rpc/Tcl/rpcAdrDemo.jTcl,v $
#
# Modification History
# --------------------
# 01a,15jan00,fulup written
#

# ----------------------------------------------------------------------------
# This process loop forever reading stdin. Squid provides searced URL on
# stdin, redirector first check this URL is allows, if not it return
# n html pages with an error message. If URL is allowed it check that
# PPP is open on Internet, if not is start a shell to open the line.
# ----------------------------------------------------------------------------

# couple of predefined variable informations
# ------------------------------------------------------------------------------------
proc Redirector.SetDefault {} {
 global PARAM

 set PARAM(ppp)         ISDN                  ;# ISDN | MODEM
 set PARAM(blacklist)   /etc/squid/blacklist  ;# where URL blacklist store
 set PARAM(logfile)     /var/log/squid/redirector                        ;# where to store log info
 set PARAM(logsize)     1024                                             ;# max size in KB
 set PARAM(ppperrorurl) http://fridu.sene.bzh/squid/cannot_start_ppp.html     ;# error message
 set PARAM(forbidenurl) http://fridu.sene.bzh/squid/not_allowed_location.html ;# error message
 set PARAM(invalidurl)  http://fridu.sene.bzh/squid/invalid_url.html          ;# error message
 set PARAM(interface)   ippp0                 ;# default for one isdn card
 set PARAM(isdnctrl)    /sbin/isdnctrl        ;# default redhat location
 set PARAM(pppctrl)     /sbin/isdnctrl        ;# default redhat location
 set PARAM(route)       /proc/net/route       ;# route location in /proc filesystem
 set PARAM(maxretry)    10                    ;# number of retry for pppd to be actif (5-10=isdn,5-30=modem)
 set PARAM(sleeptime)   2                     ;# time in second to wait before each retry (2-5=isdn,5-20=modem)
 return
} ;# end Redirector.SetDefault

# =====================================================================================
# WARNING !!!!
# 
#  "blacklist" file should exist or set to NONE
#  "errorurl"  should a valid url for client browser
#
# In order to check your config before validating squid
# test it by hand using following command
# tclsh redirector.tcl
#   http://www.forbiden.com   ;# should return errorurl
#   http://www.allowed.com    ;# should return url
#
# In order to debug redirector set TCL_DEBUG env var
# before testing module example "export TCL_DEBUG='*'"
# 
# Do not forget chgrp squid /sbin/isdnctrl; chmod u+s /sbin/isdnctrl
# =====================================================================================


# bgerror is defines in TK lib and very usefull under Tcl
# -------------------------------------------------------
proc bgerror {MSG} {
  global errorInfo tcl_platform
  set info $errorInfo

  puts stderr "---------------- redirector error stack ----------------------"

  # Start tracing from first user effective proc
  for {set LEVEL [expr [info level] -3]} {$LEVEL > 0} {incr LEVEL -1} {
    set PROC_NAME   [lindex [info level $LEVEL] 0]
    set ARG_VAL     [lrange [info level $LEVEL] 1 end]
    set ARG_NAME    [info args $PROC_NAME]

    puts stderr -nonewline "$LEVEL $PROC_NAME" 

    for {set IND 0} {$IND < [llength $ARG_NAME]} {incr IND} {
      set NAME [lindex $ARG_NAME $IND]
      set VAL  [lindex $ARG_VAL $IND]

      # Display empty paramters
      if {$VAL == ""} {set VAL \{\}}
      puts stderr -nonewline " $NAME=$VAL"
    }
    puts ""
  } ;# foreach level 
  puts stderr "---------------------------------------------------------------------"
} ;# Warning both if and proc must end on the same line for jDoc

#    Display a message is verbose is set
# --------------------------------------
proc debug.msg {args} {
 global PARAM

 # Just get out if debug not set
 if {![info exists PARAM(debug)]} {return}

 set LEVEL [expr [info level] -1]
 set PROC_NAME   [lindex [info level $LEVEL] 0]

 if [string match $PARAM(debug) $PROC_NAME] {
    puts "DB.$LEVEL.$PROC_NAME \[$args\]"
 }
} ;# end debug.msg

# log write info in redirector log file, and reopen file
# if file is deleted.
# -------------------------------------------------------
proc debug.log {MSG} {
  global PARAM

  if [info exist PARAM(logfile)] {
    set  FD  [open $PARAM(logfile).log a]
    puts $FD $MSG

    # check size each 1000 write in log
    if {$PARAM(logind) > 1000} {
      if {[file size $PARAM(logfile).log] > [expr $PARAM(logsize) * 1024]} {
        puts $LOGFD "------- [Redirector.Date] log rotated ---------"
        close $LOGFD
        file rename -force $PARAM(logfile).log $PARAM(logfile).prev
      }
      set PARAM(logind) 0
    } else {
      incr  PARAM(logind)
    }
    close $FD
  }
} ;# end debug.log

#    Display a message is verbose is set
# --------------------------------------
proc debug.trace {LEVEL args} {
 global PARAM

 if [string match $PARAM(debug) [lindex $args 0]] {
      puts "TR.$LEVEL.$args"
 }
} ;# end debug.trace


# Install auto strace in debug mode we create a dummy proc that
# just print params values and rename originale proc to _D_name
# We now use two proc in order knowing with proc fail at compilation time
# -----------------------------------------------------------------------
proc debug.proc {NAME PARAMS BODY} {
 global PARAM

 if [info exists PARAM(debug)] {
  set DEBUG "debug.trace \"\[info level\]\" $NAME"
  foreach PRM $PARAMS {set DEBUG [concat $DEBUG \$\{[lindex $PRM 0]\}]}
  proc $NAME $PARAMS "$DEBUG; $BODY"

 } else {
  # No debug included
  proc $NAME $PARAMS $BODY 
 }
};# end debug.proc


# if PARAM(debug) is set in ENV we take it else we set one as default
# --------------------------------------------------------------
if [info exist env(TCL_DEBUG)] {
   set PARAM(debug) $env(TCL_DEBUG)
}

# "Generate a date string in HTTP format [from SUN example]"
# ----------------------------------------------------------
proc Redirector.Date {} {
  set SECONDS [clock seconds]
  return [clock format $SECONDS -format {%a, %d %b %Y %T %Z}]
}
  


# Check default route is set to wanter iterface
# return TRUE or FALSE depending on result
# -----------------------------------------------
debug.proc Redirector.CheckRoute {INTERFACE} {
global PARAM

 # default is default route not find
 set STATUS -1

 # check route in /proc filesystem
 set FD [open $PARAM(route) r]

 # loop on all route until default is found
 while {![eof $FD]} {
   set ROUTE [gets $FD]
   set DEV [lindex $ROUTE 0]
   set ADR [lindex $ROUTE 1]
   set FLG [lindex $ROUTE 3]

   # if 2th word = route 3th=actif status 0=defaultroute
   if {($ADR == 0) && ($FLG != 0)} {
     debug.msg default route == $DEV
     # check default route is effectivelly ppp one
     if {$DEV == $INTERFACE} {
       debug.msg got wanted default route == $DEV
       set STATUS 0
       break
     }
   }
 }
 close  $FD
 return $STATUS
} ;# end Redirector.CheckRoute

# This routine Start PPP it should return TRUE of FALSE
# depending if operation sucessed or not.
# ---------------------------------------------------
debug.proc Redirector.StartPPP {LINK} {
global PARAM

  # are we using ISDN
  switch -- $LINK {

      ISDN  {
	if [catch {exec $PARAM(isdnctrl) dial $PARAM(interface)} MSG] {
	    debug.log "[Redirector.Date] cannot start $PARAM(isdnctrl) dial $PARAM(interface) failed |$MSG|"
          return -1
        } else {
            debug.log "[Redirector.Date] activated ISDN for $PARAM(interface)"
        }
      }

      MODEM {
      }
  }

  # wait for route to be activated before returning
  set IND 0
  while  {[Redirector.CheckRoute $PARAM(interface)]} { 
     debug.msg waiting $PARAM(interface) as defaultroute
     after $PARAM(sleeptime)
     incr IND
     if {$IND > $PARAM(maxretry)} {
       debug.log "[Redirector.Date] Max Retry for DefaultRoute to $PARAM(interface) overrun"
       return -1
     }
  }   

  debug.msg link $LINK started defaultroute $PARAM(interface)
  debug.log "[Redirector.Date] started   $LINK for $PARAM(interface)"
  return 0
} ;# end Redirector.StartPPP

# This routine return FALSE if a URL is not allowed
# and Thrue if URL is not part of our backlist
# this routine is a callback attached to stdin
# ----------------------------------------------------
debug.proc Redirector.CheckURL {INFOIN} {
global PARAM
global BLACKLIST

 # squid passed some more information after url name
 set URL [lindex $INFOIN 0]
 # debug.log $URL

 # extract site name from URL
    if {![regexp -- {([^:]+)://([^:/]+)(.*)} $URL MATCH PROTOCOL SITE REMIDER]} {
   debug.log "[Redirector.Date] $URL is not a valid URL name"
   return -1
 }

 # check URL is not forbiden
 if [info exist BLACKLIST($SITE)] {
    debug.log "[Redirector.Date] $URL acces forbiden"
    return 1
 }

 # if passed all check return true
 debug.msg $SITE allowed
 return 0

} ;# end Redirector.CheckURL


# this routine return URL to squid depending on allowed
# or not URL list. When URL is allowed it push on stdout
# the URL name with no modification, or change it to
# not allowed URL. RedirectUrl is a callback routine
# ----------------------------------------------------
debug.proc Redirector.RedirectURL {} {
global PARAM

  # first read URL from stdin
  set URL [gets stdin]
 
  # If URL is allowed check PPP is active
  switch -- [Redirector.CheckURL $URL] {
  0  {
     # if timeout reach we recheck PPP actif status
     if {!$PARAM(checked)} {
       if [Redirector.CheckRoute $PARAM(interface)] {
 	if [Redirector.StartPPP $PARAM(ppp)] {
           puts stdout "$PARAM(ppperrorurl)" 
         } else {
           # route is valid we set a global flag bind to a watchdog
           set PARAM(checked)  1
         }
       }
     }
     after cancel $PARAM(watchdog)
     set    PARAM(watchdog) [after $PARAM(timeout) {set PARAM(checked) 0}]
     puts   stdout "$URL"
    }
  1 {
     # URL is forbiden
     puts stdout $PARAM(forbidenurl)
    }
 -1 {
     # URL is malformed
     puts stdout $PARAM(invalidurl)
    }    
  } ;# end switch

  # Effectively write URL on stdout now
  flush stdout

 return
} ;# end Redirector.RedirectURL

# Load blacklist store unallowed site adress in hashtable
# -------------------------------------------------------
debug.proc Redirector.LoadBlackList {FILENAME} {
 global BLACKLIST

 # try to open backlist URL list
 if [catch {open $FILENAME r} FD] {
    return -code error "cannot open $PARAM(blacklist) back list file"
 }
 # effectivelly load blacklist URL in RAM
 while {![eof $FD]} {
    set LINE [gets $FD]
     set SITE [lindex $LINE 0]
     set EXPR [lindex $LINE 1]
     if {($SITE != "") && ($SITE != "#")} {
       set BLACKLIST([lindex $LINE 0]) [lindex $LINE 1]
       debug.msg BLACKLIST($SITE) = $EXPR
     }
 }
 close $FD

} ;# end Redirector.LoadBlackList

# Init routine does all initialisation
#   Store URL backlist in a hashtable
# ----------------------------------------------------
debug.proc Redirector.InitParam {} {
 global PARAM

 # set or override somedefault
 set PARAM(checked)   0    
 set PARAM(watchdog)  unset
 set PARAM(sleeptime) [expr $PARAM(sleeptime) * 1000] ;# switch to ms
 set PARAM(logind)    0
 
 # Get timeout from ppp interface using ctrl commands
 switch -- $PARAM(ppp) {
   ISDN  {
     # Get timeout in second from isdncrtl
     set TIMEOUT [lindex [exec $PARAM(isdnctrl) huptimeout $PARAM(interface)] 4]
     set PARAM(timeout)  [expr $TIMEOUT *1000]
   }
   MODEM {
   }
 }
    debug.msg PARAM(timeout) = [expr $PARAM(timeout) / 1000]s 

 # load blacklist
 Redirector.LoadBlackList $PARAM(blacklist)

 debug.log "----------redirector [Redirector.Date] started--------------"

} ;# end Redirector.InitParam

# Our main entry point
# ---------------------
Redirector.SetDefault     ;# UserDefault
Redirector.InitParam      ;# does all init

# Debug if much simpler when not in event mode
Redirector.RedirectURL

# set callback and enter mainloop
fileevent stdin readable Redirector.RedirectURL
vwait FOREVER  ;# loop forever


