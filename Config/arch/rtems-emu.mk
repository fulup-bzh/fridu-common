#
#	Copyright(c) 99 Fridu a Free Software Company
#
# Projet    : 	Common
# SubModule :   Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/01/18 19:05:38 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/rtems-emu.mk,v $
#
# Modification History
# -------------------------
#
# 01a,12jan99,fulup written from VxWorks.mk


# ---------------------------------------------------------------------
# WARNING: impose to change : to :: for 
#   clean:  in leaf.cfg:183
#   depend: gcc-target-default.cfg:47
# ---------------------------------------------------------------------


#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE           := Rtems
  ARCH_OS_SIDE           := Target
  ARCH_OS_NAME           := Emulator
  ARCH                   := X86
             
# Include Rtems Gnu makefile skeleton
# -----------------------------------
RTEMS_MAKEFILE_PATH      :=/pMaster/rtems-4.0/emulator/rtems/posix
include $(RTEMS_MAKEFILE_PATH)/Makefile.inc
include $(RTEMS_CUSTOM)
include $(PROJECT_ROOT)/make/leaf.cfg


# Pass RTEM flag to Fridu build.mk
# -----------------------------------
override TOP_LIBRARIES   := 

override CC_CMD          := ${COMPILE.c}
override CXX_CMD         := ${COMPILE.c}

override SH_CMD          := $(LD) $(LDFLAGS_INCOMPLETE) $(XLDFLAGS)
override CC_LNK          := $(CC) ${CFLAGS_OPTIMIZE}

override LDLIBS          := ${LDFLAGS} ${LINK_FILES}

#   lib electric fence is a malloc checker
#------------------------------------------
  LIBFENCE      :=  -lefence

