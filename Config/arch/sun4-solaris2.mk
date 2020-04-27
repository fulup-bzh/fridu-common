#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# Projet	: 	cTest
# SubModule :   Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/11 10:46:29 $
#      Revision    : $Revision: 3.6 $
#      Source      : $Source: /Master/Common/Config/arch/sun4-solaris2.mk,v $
#      State       : $State: Exp $
#
# 1.6, 1999/03/03  fulup, added readline in /opt
# 1.6, 1999/02/20  fulup  adapted to new Fridu Solaris /opt package
# 1.5, 1998/07/15, fulup, adapted to elorn clear case vue
# 1.4, 1998/05/13, fulup, adapted to Wind River config
# 1.3, 1998/02/04, fulup, update to new rules 
# 1.2, 1996/04/18, fulup, Cleaned for multi ARCH_OS 2.1 release
#
#
# ----------------------------------------------------------------------------
# This config is made for GCC using Sun C++ will impose some change in
# options. Usually there is no troubles running Fridu projects under Solaris.
# Check that Tcl localtions and other tools is valid for your site.  
# ----------------------------------------------------------------------------

# define OS Name for further use
# ------------------------------
 ARCH_OS_TYPE   := Unix
 ARCH_OS_SIDE   := Host
 ARCH_OS_NAME   := Solaris
 ARCH           := Sparc

# Specific option to Solaris
# ------------------------------
 ARCH_OS_DEFINES   = -DSOLARIS 
 ARCH_OS_INCLUDES  = -I$(PMASTER)/shadow/include -I/usr/local/include
 ARCH_OS_LIBRARIES = -L$(PMASTER)/$(ARCH_OS)/lib -lnsl -lsocket -lPosix

 override RANLIB   := ar -rs
 override SH_CMD   := /usr/ccs/bin/ld -G -z text 
#override SH_CMD   := echo >/dev/null
 override UNTOUCH  := touch -t 01010000
#override YACC     := bison -y
 override SH_DIR   := lib

# where to find readline at WRSec on erdre
# ----------------------------------------
  READLINE_LIB  := -lreadline -ltermcap
  READLINE_DLL  := -lreadline -ltermcap
  READLINE_INCL := -I/opt/shadow/include/readline
  READLINE_DEF  := -DREADLINE_LIBRARY 

# lib electric fence is a malloc checker
#------------------------------------------
#  LIBFENCE      := -L$(PMASTER)/lib -lefence

#  select gcc compiler 
#  -------------------
#  GCC_HOME := /view/wrs.tor2_0.tempest-a/vobs/wpwr/native/sun4-solaris2
#  export GCC_EXEC_PREFIX=$(GCC_HOME)/lib/gcc-lib/
#  export PATH:=$(GCC_HOME)/bin:$(PATH)

# use vincent clear case view compiler
# ------------------------------------
# override CC=/pMaster/gcc-1.7/bin/gcc
  override CC=gcc -fPIC

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wpointer-arith -Waggregate-return
  
  LIBCXX_HOME=/opt/libstdc++-2.8.1.1
  ARCH_OS_CCPLUSOPTIONS= -fPIC -I$(LIBCXX_HOME)/include/g++ \
                         -I$(LIBCXX_HOME)/sparc-sun-solaris2.5.1/include\
                         -Wformat
  ARCH_OS_DYN_CAST=      -frtti

# site libraries name and location
# --------------------------------
  TK_MASTER     := /opt/shadow
  TK_LIB        := -L$(TK_MASTER) -ltk8.0 -L/usr/openwin/lib -lXt -lX11
  TK_INCL       := -I$(TK_MASTER)/include -I/usr/local/include

  TCL_MASTER    :=  /opt/shadow
  TCL_LIB       :=  -L$(TCL_MASTER)/lib -ltcl8.0 -ldl -lm
  TCL_INCL      :=  -I$(TCL_MASTER)/include

ifdef WIND_BASE   
#  WARNING: TORNADO 1.02 as a tcl.h (7.6) check you will take tcl.h(8.0)
  TORNADO_BASE  := $(WIND_BASE)
  TORNADO_INCL  := $(TCL_INCL) -I/usr/include -I$(TORNADO_BASE)/host/include
  TORNADO_DEF   := -DHOST=sun4-solaris2 -DTORNADO -DEASYC_PROTO_ONLY

# TORNADO_LIB   := -L$(TORNADO_BASE)/host/$(ARCH_OS)/lib -lwpwr -lthread
  TORNADO_LIB   := -lLinuxWtx -lthread

# Define some flag for not include Solaris system structure that confuse vxWorks
  VXWORKS_DEF   := -D_SYS_TIME_H -D_SYS_SELECT_H -D_CLOCKID_T \
                   -D_TIMER_T
  VXWORKS_INCL  := -I$(TORNADO_BASE)/include -I$(TORNADO_BASE)/target/h
endif




