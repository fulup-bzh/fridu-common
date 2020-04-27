#
#	Copyright(c) 97 Fridu a Free Software Company
#
# File      :   project.mk, project global definition
# Projet    : 	Config
# SubModule :   Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/02/16 17:29:45 $
#      Revision    : $Revision: 3.5 $
#      Source      : $Source: /Master/Common/Etc/Project.mk,v $
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
  ifndef FRIDU_HOME
   FRIDU_HOME   := $(HOME)/pMaster
  endif
  # WARNING don't leave any space after following variables	
  PRJ_VERSION   := Common-3.08
  INSTALL_DIR   := $(FRIDU_HOME)/$(PRJ_VERSION)

# Various project specific options
# --------------------------------
  PRJ_INCLUDES  =  
  PRJ_DEFINES   = 
  PRJ_CCOPTIONS = 

# Global debug/optimization flag
# ------------------------------
# set all flasg for a full debug or oprtimized mode
# -------------------------------------------------
ifeq ($(CCDEBUG),1)
    DEBUGCCFLAGS=$(ARCH_OS_CCDEBUG)
    DEBUGSHFLAGS=$(ARCH_OS_SHDEBUG)
    DEBUGLDFLAGS=$(ARCH_OS_LDDEBUG)
else
    DEBUGCCFLAGS=$(ARCH_OS_CCO2)
    DEBUGSHFLAGS=$(ARCH_OS_SHO2)
    DEBUGLDFLAGS=$(ARCH_OS_LDO2)
endif

