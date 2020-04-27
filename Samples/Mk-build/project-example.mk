#  $Header: /Master/Common/Samples/Mk-build/project-example.mk,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#	Copyright(c) 97 Wandel & Goltermann CTS Rennes
#
# File      :   project.mk, project global definition
# Projet    : 	Dvb
# SubModule :   Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Samples/Mk-build/project-example.mk,v $
#      State       : $State: Exp $
#
# Modification History
# --------------------
# 01a,20sep97,fulup copied from jTcl project.mk
#
# Project Definition can be overrided by $(ARCH).mk
#
# Warning: This file deepely use GNU Make syntaxe, dont use your time trying
# -------  to run it with an ordinary make, you realy have to use gnu Make
# -------  When assigning Variable dont forget := is not equal to =
# -------  if you not sure that := will fit = is slower but works in any case

# Where to install production
# ---------------------------
  PRJ_VERSION   := Wandel-0.01
  PMASTER       := /pMaster
  INSTALL_DIR   := $(HOME)/pMaster/$(ARCH_OS)/$(PRJ_VERSION)

# Various location use by cTest under all Unix (override for ntx86)
# -------------------------------------------------------------------
  TK_MASTER     = $(PMASTER)/tk-8.0
  TK_LIB        = -L$(TK_MASTER) -ltk8.0 $(X11_LIB_PATH) -lXt -lX11
  TK_INC        = -I$(TK_MASTER)/include

  TCL_MASTER    =  $(PMASTER)/tcl-8.0
  TCL_LIB       =  -L$(TCL_MASTER)/lib -ltcl8.0 $(DL_LIB) $(MLIB)
  TCL_INC       =  -I$(TCL_MASTER)/include

  EXT2_MASTER    =  $(PMASTER)/e2fsprogs-1.10
  EXT2_LIB       =  -L$(EXT2_MASTER)/lib -lext2fs -lcom_err
  EXT2_INC       =  -I$(EXT2_MASTER)/include

  COMMON_MASTER  =  $(PMASTER)/Fridu/Common-3.00
  COMMON_LIB     =  
  COMMON_INC     =  -I$(COMMON_MASTER)/include
 
  JTCL_MASTER    =  $(PMASTER)/Fridu/jTcl-3.00
  JTCL_LIB       =  -L$(JTCL_MASTER)/lib -lCt
  JTCL_INC       =  -I$(JTCL_MASTER)/include
 
  TOP_LIBRARIES = -L$(LIBDIR)

  PRJ_LIBRARIES =  
  PRJ_INCLUDES  =  
  PRJ_DEFINES   = 

# Where to place obj and exe at production time
# -----------------------------------------------
  ifdef DESTDIR
    override RUNTIME   := ${DESTDIR}
  else
    override RUNTIME   := $(INSTALL_DIR)
  endif


# For demo purpose Java class are kept in dev tree
# ------------------------------------------------
  override CLASSDIR := ../Class

# Override ARCH option for EXT WARNING
# ------------------------------------
override ARCH_OS_CCOPTIONS=-finline-functions -Winline -Wall \
   -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Waggregate-return

PRJ_CCOPTIONS= 
CDEBUGFLAGS=-g
LDFLAGS=
