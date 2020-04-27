#	Copyright(c) 96 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# File   	:   freeBsd.mk, FreeBsd specifics
# Projet	:   Common
# SubModule     :   Makefile configuration
# Auteur        :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:17 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/freeBsd.mk,v $
# 
# 01a,30mars98,Mikhail Teterin writen from linux86.mk
#
# --------------------------------------------------------------------
# WARNING: FreeBsd does not include getopt_long it not already done
#          on your site, you should build libPosix from
#          Common/Tools.
# --------------------------------------------------------------------
#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Unix
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := FreeBSD
  ARCH           := X86

# redefine some platform specific Value
# ----------------------------------------
  X11_LIB_PATH = -L/usr/X11R6/lib
  LIB_DL       = 

# define few VALUE for PROTO ERROR
# --------------------------------

  ARCH_OS_DEFINES=-DNO_XUSTAT -I$(TOP)/Common/Tools/src/posix \
                  -D$(ARCH_OS_NAME) -D$(ARCH) -D$(ARCH_OS_SIDE)

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Wcast-align \
   -Wconversion -Waggregate-return 

  ARCH_OS_LIBRARIES     = -lPosix
  ARCH_OS_CCPLUSOPTIONS	= -Wformat
  ARCH_OS_DYN_CAST      = -frtti

  override SH_CMD	:= cc -shared -Wl,-x -Wl,-assert -Wl,pure-text 

  TK_MASTER    := /usr/local
  TK_LIB       := -L$(TK_MASTER) -ltk8.0 -lXt -lX11
  TK_INC       := -I$(TK_MASTER)/include/tk8.0

  TCL_MASTER   :=  /usr/local
  TCL_LIB      :=  -L$(TCL_MASTER)/lib -ltcl8.0 -lm
  TCL_INC      :=  -I$(TCL_MASTER)/include/tcl8.0
