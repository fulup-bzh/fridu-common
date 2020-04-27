#  $Header: /Master/Common/Tools/src/posix/Build.mk,v 3.1 1999/02/21 12:30:15 fulup Exp $
#
#  Copyright(c) 1997 Wandel & Golterman Cersem Rennes
#  Copyright(c) 96-97 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Build.mk
# Projet    :   Posix compatibility for NT and comercial Unix
# SubModule :   Bench Posixhrone
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/02/21 12:30:15 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Tools/src/posix/Build.mk,v $
#      State       : $State: Exp $
#
#Modification History 
#--------------------
#01a,26jun97,fulup written from jTcl example
#


# Posix getopt is standard under Linux
ifneq (${ARCH_OS_NAME},Linux)

# Define init modules
# ------------------------
  LIB_SRCS = getopt.c getopt1.c
  LIB_OBJS = $(LIB_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  BIN_SRCS  = mainPosix.c
  BIN_OBJS  = $(BIN_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  SRCS         = ${LIB_SRCS} ${BIN_SRCS}

# define meta rules
# ------------------
  override LIBS   :=  libPosix
  override EXE    :=  posix
#  override SHARED :=  libPosix

# define some extra option for TK
# --------------------------------
  MK_DEFINES  = 
  MK_INCLUDES =  
  SH_LIBS     = ${LDLIBS}

# set proto in libPosix.h if any .i changed
# ----------------------------------------
${INCDIR}/libPosix.i: $(LIB_SRCS:%.c=${DEPDIR}/%.i) 
	${protoRule} 

# Set library & subLib name and give source depending files
# ----------------------------------------------------------
${LIBDIR}/libPosix${LIB_SFX}: ${LIB_OBJS}
	${libRule}

${BINDIR}/posix${EXE_SFX}: ${BIN_OBJS} ${LIBDIR}/libPosix${LIB_SFX}
	${binRule} ${LIBPOSIX} ${LDLIBS}

endif
