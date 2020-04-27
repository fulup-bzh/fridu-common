#	Copyright(c) 96 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# File   	:   linux86.mk, linux for Intel specific VALUES
# Projet	:   rtWeb
# SubModule     :   Makefile configuration
# Auteur        :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/11 10:46:29 $
#      Revision    : $Revision: 3.9 $
#      Source      : $Source: /Master/Common/Config/arch/linux86.mk,v $
#
# 
# 01b,10mar99,fulup make libfence to be used only on debug mode
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
# --------------------------------------------------------------------
# WARNING: Fridu use Redhat-5.0 as Linux reference
#          your distribution could have some different default
#          for tools and library location.
# --------------------------------------------------------------------
#

#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Unix
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Linux
  ARCH           := X86


# define few VALUE for PROTO ERROR
# --------------------------------
  ARCH_OS_DEFINES=-DNO_XUSTAT -DLINUX -D_IOSTREAM_H \
                  -D$(ARCH_OS_NAME) -D$(ARCH) -D$(ARCH_OS_SIDE)

# if checker wanted uncomment folowing line
# ---------------------------------------------
#  CC = /pMaster/GNU/Checker-0.7/linux86/bin/checkergcc
#override CC_PLUS=egcs

# lib electric fence is a malloc checker when ruuning in debug
#-------------------------------------------------------------
ifeq ($(CCDEBUG),1)
  LIBFENCE      :=  -lefence
endif

# WARNING: eFence end checker are incompatible

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Wcast-align \
   -Waggregate-return 
# -Wunused -Wconversion 

  ARCH_OS_CCPLUSOPTIONS= -Wformat
  ARCH_OS_DYN_CAST=      -frtti

# site libraries name and location
# --------------------------------
  TK_MASTER     := /usr/local
  TK_LIB        := -L$(TK_MASTER) -ltk8.0 -L/usr/X11R6/lib -lXt -lX11
  TK_INCL       := -I$(TK_MASTER)/include

  TCL_MASTER    :=  /usr/local
  TCL_LIB       :=  -L$(TCL_MASTER)/lib -ltcl8.0 -ldl -lm
  TCL_INCL      :=  -I$(TCL_MASTER)/include

# where to find readline at WRSec on erdre
# ----------------------------------------
  READLINE_LIB  := -lreadline -lcurses
  READLINE_DLL  := -lreadline -lcurses
  READLINE_INCL := -I/usr/include/readline
  READLINE_DEF  := -DREADLINE_LIBRARY 

# Warning Tornado provide a TCL7.6 Tcl that should be bypassed
# -------------------------------------------------------------
ifdef WIND_BASE
  TORNADO_BASE  :=  $(WIND_BASE)
  TORNADO_INCL  :=  -I/usr/include \
                    -I$(TORNADO_BASE)/host/include
  TORNADO_DEF   :=  -DHOST=sun4-solaris2.mk -DEASYC_PROTO_ONLY
  TORNADO_LIB   :=  -L$(TORNADO_BASE)/host/$(ARCH_OS)/lib -lLinuxWtx

  VXWORKS_INCL  :=  -I$(TORNADO_BASE)/include -I$(TORNADO_BASE)/target/h
  VXWORKS_DEF   :=  -DCPU=I80386
endif



