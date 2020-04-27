#
#	Copyright(c) 95-96 Fridu a Free Sotfware Company
#
# File   	:   ntx86.mk, NT specific VALUES for Cygnus NT tools
# Projet	:   rtWeb
# SubModule     :   Makefile configuration
# Auteur        :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:17 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/ntx86-gnu.mk,v $
#
#  1.2 1997/06/30 fulup   adapted to cygwin32
#  1.1 1996/11/28 fulup   Writen
#
#

# define OS Name for further use
# ------------------------------
  ARCH_OS_TYPE   := Window
  ARCH_OS_SIDE   := Host
  ARCH_OS_NAME   := Winnt
  ARCH           := X86


# define few VALUE for PROTO ERROR
# --------------------------------

  ARCH_OS_DEFINES=-DWINDOWS

# allows inline function
# -----------------------
  ARCH_OS_CCOPTIONS=-finline-functions -Winline -W -Wimplicit -Wreturn-type \
   -Wswitch -Wformat -Wchar-subscripts -Wparentheses \
   -Wshadow -Wpointer-arith -Wcast-align \
   -Wconversion -Waggregate-return 

# change option from default
# ---------------------------------
  override  CC      := gcc 
  override SH_CMD   := echo >${NULL_DEV}

# define some plateform speficif Values
# --------------------------------------
  override TCOV_DIR     :=   
  override READLINE_DIR :=   
  override INCLUDE      :=
  override LIB          :=

# define pMaster location
# -------------------------
override  PMASTER      := e:/pMaster

# by default NULL_DEV is /dev/null
# ---------------------------------
override  NULL_DEV     := NUL

# make EXEC files as name.EXE and object as name.oBJ
# ---------------------------------------------------
override  EXE_SFX   := .exe
override  OBJ_SFX   := .obj
override  LIB_SFX   := .lib

# use for building DLL (rule)
# ------------------------------
override  SO_SFX       := so.dll
override  SA_SFX       := so.lib






