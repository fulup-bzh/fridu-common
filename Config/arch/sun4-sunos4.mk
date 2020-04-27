#	Copyright(c) 96 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# Projet	:   Firdu Realtime Booster
# SubModule     :   Makefile configuration
# Auteur        :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:18 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/sun4-sunos4.mk,v $
#
#
# Modification History
# --------------------
# 01b,04apr97,fulup adapted to CCRI sun4 zeus+clipper config
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
# ---------------------------------------------------------------------------
# WARNING: Sunos default cc is not ansi and won't compile Fridu projects
#          you need Gcc to be installed, uncomment flex if you want to
#          rebuild lex files.
# ---------------------------------------------------------------------------
#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Unix
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Sunos
  ARCH           := Sparc

# by default Sunos ld result are sharable no specific options needed
# ------------------------------------------------------------------
  override SH_CMD    := ld
  override UNTOUCH   := /usr/5bin/touch -m 01010000
  override LEX       := echo !!! Old Sunos lex ignored for file; $(UNTOUCH)

# define few VALUE for PROTO ERROR
# --------------------------------
  ARCH_OS_DEFINES=-DSUNOS -D__USE_FIXED_PROTOTYPES__

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Wcast-align \
   -Wconversion -Waggregate-return 

# site libraries name and location
# --------------------------------
  TK_MASTER     := /usr/local
  TK_LIB        := -L$(TK_MASTER) -ltk8.0 -L/usr/X11/lib -lXt -lX11
  TK_INC        := -I$(TK_MASTER)/include

  TCL_MASTER    :=  /usr/local
  TCL_LIB       :=  -L$(TCL_MASTER)/lib -ltcl8.0 -ldl -lm
  TCL_INC       :=  -I$(TCL_MASTER)/include
