#
#	Copyright(c) 96-98 FRIDU a Free Software Company (Fulup Ar Foll)
#
# Projet    : 	Config
# SubModule :   Generic Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/22 09:50:12 $
#      Revision    : $Revision: 3.10 $
#      Source      : $Source: /Master/Common/Config/makeSkel/default.mk,v $
#
# Modification History
# --------------------
# 01h,21feb99,fulup corrected libincl for jWrap install changed shared default
# 01g,20may98,fulup Cleanup for W95 and NT
# 01h,30mar98,fulup Freebsd cleanup [thanks to Mikhail Teterin] add TOPLDFLAGS
# 01g,03mar98,fulup added doc rule
# 01f,04feb98,fulup Tune CC options to be C++ compliant change Cproto
# 01e,02Dec97,fulup Corrected Module Includes & change dll default name
# 01d,20jun97,fulup added doc and Html rules
# 01c,10jun97,fulup add PROJECT dir in include list
# 01b,07apr97,fulup adapted to new build.version number model
# 01a,18mar97,fulup move to new history

# by default NULL_DEV is /dev/null
# ---------------------------------
  NULL_DEV     := /dev/null

# Add specific architecture directories to SUBDIRS
# ------------------------------------------------
  override SUBDIRS  := $(SUBDIRS) \
                       $(wildcard ${ARCH_OS_TYPE}) $(wildcard ${ARCH_OS_SIDE}) \
                       $(wildcard ${ARCH_OS_NAME}) $(wildcard ${ARCH}) 

# ---------------------------------------------
# Warning file list (TCL,DOC,TK, ...)
# comes either from build.mk or from build.tcl
# ---------------------------------------------

# Location for obj and exe at compilation time 
# Can be change in project.mk but not in Build.mk
# -----------------------------------------------
  OBJDIR   := $(TOP)/Exe/$(ARCH_OS)/obj
  DEPDIR   := $(TOP)/Exe/$(ARCH_OS)/etc
  BINDIR   := $(TOP)/Exe/$(ARCH_OS)/bin
  LIBDIR   := $(TOP)/Exe/$(ARCH_OS)/lib
  JDOCDIR  := $(TOP)/Exe/$(ARCH_OS)/jDoc
  SHDIR    := $(TOP)/Exe/$(ARCH_OS)/lib
  INCDIR   := $(TOP)/Exe/$(ARCH_OS)/include
  MANDIR   := $(TOP)/doc/man 
  CLASSDIR := $(TOP)/Exe/Class
ifndef LIBINCL
  LIBINCL  := ../Include
endif

# RUNTIME DIR
# -----------
# Where to place obj and exe at production time
# -----------------------------------------------
  ifndef RUNTIME
    RUNTIME   := /usr/local
  endif

  ifdef DESTDIR
     override RUNTIME := ${DESTDIR}/${ARCH_OS}
  else
     override RUNTIME := $(INSTALL_DIR)
  endif

  RUNTIME_BINDIR   := $(RUNTIME)/bin
  RUNTIME_LIBDIR   := $(RUNTIME)/lib
  RUNTIME_SHDIR    := ${RUNTIME}/lib
  RUNTIME_MANDIR   := $(RUNTIME)/man
  RUNTIME_SHLDIR   := $(RUNTIME)/bin
  RUNTIME_DOCDIR   := $(RUNTIME)/docs/$(MOD_VERSION)
  RUNTIME_TCLDIR   := $(RUNTIME)/lib/$(MOD_VERSION)/${CURRENT_DIR}
  RUNTIME_INCDIR   := $(RUNTIME)/include
  RUNTIME_CLASSDIR := $(RUNTIME)/Class

  TOP_LIBRARIES    := -L/usr/local

# shell to be used by Makefile to start command
# ----------------------------------------------
#  SHELL        := /bin/sh
  CCAT         := ccat + stdout
  FCAT         := ccat -
  FAPPEND      := ccat +
  CPROTO       := cproto
  CDEPEND      := cdepend
  CECHO        := cecho + stdout
  FECHO        := cecho -
  FADD         := cecho + 
  CSED         := sed
  DUMPEXTS     := sed s#^.*$#$(OBJDIR)/&#
  RM           := rm -rf
  MV           := mv -f
  CP           := cp -f
  MKDIR        := mkdir -p
  CHOWN        := chown
  CHMOD        := chmod
  CPP          := gcc -E
  CO           := co
  JAVADOC      := javadoc
  CI           := ci
  RCS          := rcs
  YACC         := bison -y -d -v
  RANLIB       := ranlib
  UNTOUCH      := touch -d 0:0
  JWRAP        := jWrap
  JWRAP_TARGET := --cc2jTcl
  JWRAP_SOURCE := --cc
  LEX          := lex -8
  AWK          := awk
  GREP         := grep
  DEFAULT_RM   := t?t? dummy core .*lib *.bak RCS/*.bak,v *.*~
  INDENT       := indent \
		  --indent-level2 \
		  --leave-optional-blank-lines \
                  --blank-lines-after-declarations \
		  --blank-lines-after-procedures   \
                  --blank-lines-after-commas \
		  --brace-indent2 \
		  --continuation-indentation3 \
		  --case-indentation2 \
		  --braces-on-if-line \
		  --cuddle-else \
		  --else-endif-column2 \
		  --comment-delimiters-on-blank-lines \
		  --start-left-side-of-comments \
                  --line-comments-indentation0 \

# by default gcc compilation flags
# --------------------------------
 CC              := gcc -fPIC
 O_FLG           := -o 
 CC_CMD          := ${CC} -c
 CC_LNK          := ${CC} 
 CC_PLUS         := g++
 CC_PLUS_CMD     := ${CC_PLUS} -c
 CC_PLUS_LNK     := ${CC_PLUS} 
 ARCH_OS_CCDEBUG := -g
 ARCH_OS_CCO2    := -O2

# define default UNIX linker flags
# --------------------------------
 E_FLG             := -o 
 L_FLG             := -l
 SH_OUT            := -o 
 OBJ_SFX           := .o
 ARCH_OS_LDDEBUG   := -g
 ARCH_OS_LDO2      := -s

# default gcc shared library
# ----------------------------
 SH_CMD    := ld -shared -L$(LIBDIR)
 SO_SFX    := .so
 SA_SFX    := .sa
 DLL_SFX   :=
 ARCH_OS_SHDEBUG   := -g
 ARCH_OS_SHO2      := -s
 

# default unix library manager flag
# ----------------------------------
 AR_LIST   := ar t
 AR_ADD    := ar r
 LIB_SFX   := .a
 SHLIBS    := 


# define General default FLAGS
# -----------------------------
  TOP_INCLUDES  =-I. -I$(LIBINCL) -I${FRIDU_CONFIG}/Include/${ARCH_OS_TYPE} \
                 -I${INCDIR} -I${DEPDIR}

  TOP_LDFLAGS   =-L$(TOP)/Exe/$(ARCH_OS)/lib

  ALLINCLUDES   = $(TOP_INCLUDES) $(MK_INCLUDES) $(MOD_INCLUDES) \
                  $(ARCH_OS_INCLUDES) $(PRJ_INCLUDES)

  ALLDEFINES    = -DFRIDU $(TOP_DEFINES) $(MK_DEFINES) $(MOD_DEFINES) \
                  $(ARCH_OS_DEFINES) $(PRJ_DEFINES)

  CFLAGS        = $(DEBUGCCFLAGS) $(TOP_CCOPTIONS) $(MK_CCOPTIONS) $(ARCH_OS_CCOPTIONS) \
                  $(MOD_CCOPTIONS) $(PRJ_CCOPTIONS) $(ALLDEFINES) $(ALLINCLUDES)

  CPLUSFLAGS    = $(DEBUGCCFLAGS) $(TOP_CCPLUSOPTIONS) $(MK_CCPLUSOPTIONS) \
                  $(ARCH_OS_CCPLUSOPTIONS) $(MOD_CCPLUSOPTIONS) \
                  $(PRJ_CCPLUSOPTIONS) $(ALLDEFINES) $(ALLINCLUDES)

  LDLIBS        = $(TOP_LIBRARIES) $(MK_LIBRARIES) \
                  $(ARCH_OS_LIBRARIES) $(MOD_LIBRARIES) \
                  $(PRJ_LIBRARIES) $(SYS_LIBRARIES)

  LDFLAGS       = $(DEBUGLDFLAGS) $(TOP_LDFLAGS) $(MK_LDFLAGS) $(ARCH_OS_LDFLAGS) \
                  $(PRJ_LDFLAGS) 

  SHFLAGS       = $(DEBUGSHFLAGS) $(TOP_SHFLAGS) $(MK_SHFLAGS) $(ARCH_OS_SHFLAGS) \
                  $(PRJ_SHFLAGS) 

  COFLAGS       := -q -p
  RCS_LOCK_FLG  := -q -l
  # WARNING CIFLAGS & RCS_SYM_FLG as to be and = and not and := value
  VERSION_LOG   = mkSkel:`sed  -n '/^[\#, ,/,*]*Modification./s///p' < $* 2>${NULL_DEV}`
  CIFLAGS       =  -q -T -t-"" -u -N"${VERSION_CLASS}/${VERSION_NUM}" -m"${VERSION_LOG}"
  RCS_SYM_FLG   =  -q -N"${VERSION_CLASS}/${VERSION_NUM}":

# set auto dependency search
# --------------------------
  vpath %.h %.i ${INCDIR} ../include ${DEPDIR} ${LIBDIR}
  VPATH = ${LIBDIR}

# get default version
# -------------------

  space         := ${empty} ${empty}
  dot           := "."
  VERSION_C     := ${FRIDU_CONFIG}/Include/version.c
  VERSION_DATE  := ${DATE}
  VERSION_HOST  := ${HOSTNAME}
  VERSION_TEXT  = Version.$(notdir $(basename $@)).${PRJ_VERSION}/${MOD_VERSION}.${ARCH_OS}.${DEBUGCCFLAGS}.the.${VERSION_DATE}.by.${LOGNAME}.on.${VERSION_HOST}

