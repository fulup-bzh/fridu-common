#!/usr/local/bin/tclsh
#
# tcl2html
#
# Converts tcl code to HTML
#
# Uses either files on command line (creating a file.html for each file)
# or the PATH_INFO for use on a W3 server
#
# Command line usage:
# % tcl2html ?-stdout? <filenames...>
# The -stdout flag makes it print it's results to stdout.  Otherwise each
# file processed has it's extension replaced with .html (ie - tcl2html.tcl
# becomes tcl2html.html).  Has weird algorithm to never overwrite a file
# (creates a unique filename.html.# instead of overwriting existing file).
#
# W3 script usage:
# http://domain.name/script-dir/tcl2html/virtual.path/doc
# It uses PATH_INFO and PATH_TRANSLATED to find the file, so it must
# be available to the web server.
# Test the script on itself at:
# http://www.cs.uoregon.edu/~jhobbs/htbin/tcl2html.cgi/~jhobbs/htbin/tcl2html.cgi
#
#include "standard_disclaimer.h"
#
# Further questions contact: jhobbs@cs.uoregon.edu
# http://www.cs.uoregon.edu/~jhobbs/


set version 0.47

if [info exists env(PATH_INFO)] { set w3 1 } else { set w3 0 }

proc usage {} {
  global argv0;

  if $w3 {
    puts "$argv0 called incorrectly"
    error "$argv0 called incorrectly"
  }
  error "Usage: [file tail $argv0] ?-stdout? <filenames...>"
}

array set H {
  comment	{<EM><FONT color=#CC00FF>}
  /comment	</FONT></EM>
  proc		<B>
  /proc		</B>
  str		{<FONT color=#FFFF00>}
  /str		</FONT>
}


# Takes in tcl script as data
# Returns data in HTML form

proc tcl2html { title data {header {}} } {
  global H CMD
  set inComment 0; set inString 0; set inExec 0;

  regsub -all {&} $data {\&amp;} data
  regsub -all {<} $data {\&lt;} data
  regsub -all {>} $data {\&gt;} data

  lappend html "<HTML><HEAD><TITLE>$title</TITLE></HEAD>" "<BODY>"  "<H1>$title</H1>" "<HR>" $header "<PRE>";

  set strings [split $data \n]

  set cmnt "^\[\t \]*\#"
  foreach line $strings {
    if {![string length [string trim $line]]} {
      lappend html {}
    } elseif {[regexp $cmnt $line]} {
      if !$inComment {
	lappend html $H(comment)
	set inComment 1
      }

      lappend html $line
    } else {
      if $inComment {
	lappend html $H(/comment)
	set inComment 0
      }

      lappend html [procit $line]
    }
  }
  if $inComment { lappend html $H(/comment) }

  lappend html </PRE> </BODY> </HTML>

  return [join $html \n]
}

proc procit {line} {
  global CMD H
  set trim "\t \{\}\[\]\"'\;"
  foreach word [split $line] {
    set word [string trim $word $trim]
    if {[info exists CMD($word)]} {
      regsub $word $line $H(proc)&$H(/proc) line
    }
  }
  return $line
}


# Hack to get auto_index loaded up

catch i_want_auto_index_loaded

foreach cmd [concat [info commands] [array names auto_index]] {
  set CMD($cmd) {}
}


if $w3 {
  if [file isfile $env(PATH_TRANSLATED)] {
    set fn $env(PATH_TRANSLATED)
  } else {
    error "$argv0 ERROR: Could not find file based on $env(PATH_INFO)"
  }
  set fid [open $fn r]
  set data [read -nonewline $fid]
  close $fid

  puts "Content-type: text/html\n"

  if [catch "tcl2html $env(PATH_INFO) {$data}" html] {
    puts "Error occured while processing '$fn':\n$html"
    error "$argv0 ERROR: occured while processing '$fn':\n$html"
  } else {
    puts "$html"
  }

} else {


  # Handle - options


  set OUTPUT {}
  while {[string match \-* [lindex $argv 0]]} {
    switch -glob -- [lindex $argv 0] {
      -s* {
	set OUTPUT stdout
	set argv [lreplace $argv 0 0]
      }
      default { usage }
    }
  }

  foreach fn $argv {
    if [file exists $fn] {
      set fid [open $fn r]
      set data [read -nonewline $fid]
      close $fid
      puts "Processing $fn"

      if {[string comp stdout $OUTPUT]} {
	set fn $fn.html
	if [file exists $fn] {
	  set i 0
	  set fn $fn.$i
	  while [file exists $fn] {
	    incr i
	    set fn "[file rootname $fn].$i"
	  }
	}
	set fid [open $fn w]
	set OUTPUT $fid
      }
      if {[catch [list tcl2html $fn $data] html]} {
	puts "Error occured while processing '$fn':\n$html"
      } else {
	puts $OUTPUT $html
	if {$OUTPUT == $fid} { close $fid }
      }
    } else {
      puts "File '$fn' not found, skipping..."
    }
  }
}

exit
