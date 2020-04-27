#
#       Copyright(c) 98 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz
#          Vannes IUP labo Valoria University of South Britany
#
# Projet    : 	Common
# SubModule :   Config Arch specific values
# Auteur    :   Fulup Ar Foll (fulup@fridu.com)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:18 $
#      Revision    : $Revision: 3.5 $
#      Source      : $Source: /Master/Common/Config/arch/ntx86-vc.mk,v $
#
# Modification History
# --------------------
# 01c,18may98,fulup adapted to Fridu configuration
# 01b,30jun97,fulup adpated to new config architecture
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
# NOTE: 
# 1)ntx86.mk is long and complex because it override almost all
#   rule.mk default Unix value. Warning c:,h: can be confused with
#   a rue, in which case error message are stupid [ex: set HOME='h: '
#   in pace of 'h:' will give an error message in line 196 or tmpl.mk [hug!!!]
# 2)In order not including all windows.h [200lines] we force _WINDOWS_ define
#   if you need specific to windows type you should undef it before
#   including windows.h 
#

# For some obscur raison W95 does not find cl !!!
# -----------------------------------------------
  FRIDU_HOME   := e:/pMaster/Fridu
  MSVC_MASTER  := c:/pMaster/msvc-4.2
  TCL_MASTER   := e:/pMaster/Tcl-8.0/include
  TORNADO_BASE := e:/pMaster/tornado-1.0

# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := WinDos
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Winnt
  ARCH           := X86


# define pMaster location
# -------------------------
ifndef PMASTER
  override  PMASTER  := e:/pMaster
endif

# by default NULL_DEV is /dev/null
# ---------------------------------
 override  NULL_DEV     := NUL

# make EXEC files as name.EXE and object as name.oBJ
# ---------------------------------------------------
 override  EXE_SFX   := .exe
 override  OBJ_SFX   := .obj
 override  LIB_SFX   := .lib

# Generic MSVC options
# ---------------------
 override MSVC_BIN   := $(MSVC_MASTER)/bin
 export   LIB        := $(MSVC_MASTER)/lib;$(FRIDU_HOME)/Common-3.02/lib
 export   include    := $(MSVC_MASTER)/include

# This line under define CC for build an 32 Bytes application an DLL
# ------------------------------------------------------------------
 override  CC_CMD            := $(MSVC_BIN)/cl.exe /c 
 override  CC_PLUS_CMD       := ${CC_CMD}

 override  O_FLG        := /Fo
 override  NO_ANSI_C    := /D "__ARCHC__"  /W1

 override  ARCH_OS_CCOPTIONS := /nologo /W3 /GX 
 override  ARCH_OS_CCPLUSOPTIONS := $(ARCH_OS_CCOPTIONS)
 override  ARCH_OS_DEFINES   := -DWIN32 -D_X86_ -D_WINDOWS_ -DMSDOS
 override  ARCH_OS_INCLUDES  := -I${FRIDU_HOME}/Common-3.02/include
 # for Windows ARCH_OS_LIB is in lib environement var

# use following for Microsoft linker
# ----------------------------------
 override  CC_LNK        := ${MSVC_BIN}/link.exe /nologo
 override  CC_PLUS_LNK   := $(CC_LNK)

 override  E_FLG         := /machine:ix86 /out:
 override  ARCH_LDFLAGS  := 
 override  L_FLG         := lib
 override  DLL_SFX       := .lib
 override  TOP_LIBRARIES :=
 override  TOP_LDFLAGS   :=

#   Warning adding lib by your own can product strange result under W95 [hug!!]
#   wsock32.lib msvcrt.lib oldnames.lib kernel32.lib \
#   advapi32.lib user32.lib gdi32.lib \
#   comdlg32.lib winspool.lib 

#  wsock32.lib kernel32.lib user32.lib\
#  gdi32.lib winspool.lib comdlg32.lib advapi32.lib\
#  shell32.lib uuid.lib

 CORE_LIB := kernel32.lib advapi32.lib user32.lib 
 XGUI_LIB := gdi32.lib comdlg32.lib winspool.lib
 override  ARCH_OS_LIBRARIES  := libc.lib $(CORE_LIB)

# use for building DLL (rule) warning SO_SFX should not be .dll
# is SHDIR == LIBDIR 
# --------------------------------------------------------------
 override  SH_CMD       := $(MSVC_BIN)/link.exe /nologo
 override  SHDIR        := $(TOP)/Exe/$(ARCH_OS)/bin
 override  SO_SFX       := .dll
 override  SA_SFX       := .lib
 override  SH_OUT       :=  /DLL /OUT:
 override  SH_DEF       := -def:
 override  SH_FLG       :=
 
 XGUI_LIB  := $(XGUI_LIB)
 override  SHLIBS :=  $(CORE_LIB)

# use following for microsoft lib mandager
# -----------------------------------------
 override  AR_ADD  := clib  $(MSVC_BIN)/lib.exe /nologo --
 override  AR_LIST := $(MSVC_BIN)/lib.exe /nologo 
 override  AR_OUT  := /list:
 override  DUMPEXTS:= cDumpExts
 override  RANLIB  := ctouch +
 override  RM      := cdel
 override  TOUCH   := ctouch +
 override  UNTOUCH := ctouch -

# misc Flags for Microsoft compiler [warning to = for pdb flag]
# -------------------------------------------------------------
 override ARCH_OS_CCDEBUG   := /Zi
 override ARCH_OS_CCO2      := /O2
 override ARCH_OS_SHDEBUG   = /DEBUG
 override ARCH_OS_SHO2      := /RELEASE
 override ARCH_OS_LDDEBUG   = /DEBUG
 override ARCH_OS_LDO2      := /RELEASE

# Lib Posix defines getoptlong
# -----------------------------
  LIBPOSIX      = libPosix.lib

# Tcl libraries and includes
# ---------------------------
  TCL_LIB       :=  /LIBPATH:$(TCL_MASTER)/lib tcl80vc.lib
  TCL_INCL      :=  -I$(TCL_MASTER)/include

# Define Windriver Tornado lib path (warning do not use WRS tcl.h)
# ----------------------------------------------------------------
  export WIND_BASE := $(TORNADO_BASE)
  TORNADO_INCL  := $(TCL_INCL) -I$(TORNADO_BASE)/host/include
#  SIMULATION    := 1
ifdef SIMULATION
  TORNADO_DEF   := -DSIMULATION  -DTORNADO -DHOST=x86-win32
  TORNADO_LIB   = $(LIBDIR)/libTornadoHat.lib
else
  TORNADO_DEF   := -DTORNADO -DHOST=x86-win32
  TORNADO_LIB   := $(WIND_BASE)/host/x86-win32/bin/wtxapidll.lib
endif

# Microsoft libs madatory for finding lib warning to upercase
#------------------------------------------------------------
  export LIB:=$(TOP)/Exe/$(ARCH_OS)/lib;$(LIB)

