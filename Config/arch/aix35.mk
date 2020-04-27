#	Copyright(c) 96 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# Projet	:   Fridu a Free Software Company
# SubModule     :   Makefile configuration
# Auteur        :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:16 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/aix35.mk,v $
#
# Modification History
# ---------------------
# 01b,11mar97,fulup added sahre lib functions under AIX-3.5
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
# ---------------------------------------------------------------------------
# WARNING: Those option are written for an AIX using gcc, IBM compiler
#          will need some more specifics options. Note that share
#          libraries requirer a shell "ldAix.sh" this shell is a modify version
#          of Tcl aix specific utilities and is include in Fridu/Common
# ----------------------------------------------------------------------------
#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Unix
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Aix
  ARCH           := Pwc

# define few VALUE for PROTO ERROR
# --------------------------------
  ARCH_OS_DEFINES   = -DAIX -D__USE_FIXED_PROTOTYPES__

# Override some mandatory commands
# ---------------------------------
  override SH_CMD  := $(TOP)/config/tools/ldAix.sh /bin/ld \
                      -bhalt:4 -bM:SRE -bE:lib.exp -H512 -T512 $(SH_LIBS)
  override UNTOUCH := touch -t 01010000

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Wcast-align \
   -Wconversion -Waggregate-return 

# site libraries name and location
# --------------------------------
  TK_MASTER     := /usr/local
  TK_LIB        := -L$(TK_MASTER) -ltk8.0  -lXt -lX11
  TK_INC        := -I$(TK_MASTER)/include

  TCL_MASTER    :=  /lusr/local
  TCL_LIB       :=  -L$(TCL_MASTER)/lib -ltcl8.0 -lm
  TCL_INC       :=  -I$(TCL_MASTER)/include
