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
#      Date        : $Date: 1999/03/04 08:31:08 $
#      Revision    : $Revision: 3.2 $
#      Source      : $Source: /Master/Common/Config/arch/linuxAxp.mk,v $
#
#
# 01c,03mar99,fulup added readline
# 01b,06dec98,fulup add -r paramters for dll under ELF linux
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
#
# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Unix
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Linux
  ARCH           := Axp


# redefine some platform specific Value
# ----------------------------------------
  X11_LIB_PATH = -L/usr/X11R6/lib
  LIB_DL       = -ldl

# define few VALUE for PROTO ERROR
# --------------------------------

  ARCH_OS_DEFINES=-DNO_XUSTAT  -DLINUX  -D__apha__ \
                  -D$(ARCH_OS_NAME) -D$(ARCH) -D$(ARCH_OS_SIDE)

# where to find readline at WRSec on erdre
# ----------------------------------------
  READLINE_LIB  := -lreadline -lcurses
  READLINE_DLL  := -lreadline -lcurses
  READLINE_INCL := -I/usr/include/readline
  READLINE_DEF  := -DREADLINE_LIBRARY 

# if checker wanted uncomment folowing line
# ---------------------------------------------
#  CC = /pMaster/GNU/Checker-0.7/linux86/bin/checkergcc

#   lib electric fence is a malloc checker
#------------------------------------------
#    LIBFENCE      :=  -lefence

# WARNING: eFence end checker are incompatible

# allows inline function
# -----------------------
  override ARCH_OS_CCOPTIONS=-finline-functions -Winline -Wall \
   -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Waggregate-return -fno-defer-pop

# override ARCH_OS_LDFLAGS=-r$(LIBDIR)







