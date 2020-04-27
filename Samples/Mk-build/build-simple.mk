#  $Header: /Master/Common/Samples/Mk-build/build-simple.mk,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#       Copyright(c) 96-97 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Build.mk
# Projet    :   Fridu Realtime Booster
# SubModule :   ct C to Tcl interface
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Samples/Mk-build/build-simple.mk,v $
#      State       : $State: Exp $
#
#Modification History 
#--------------------
#01b,28feb97,fulup released jTcl
#01a,20sep97,fulup written
#

# Define init modules
# ------------------------
  CT_LIB_SRCS = initCt.c parserCt.c translateCt.c hookCt.c errorCt.c
  CT_LIB_OBJS = $(CT_LIB_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CT_TCL_SRCS  = debugCt.c
  CT_TCL_OBJS  = $(CT_TCL_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  SRCS         = ${CT_LIB_SRCS} ${CT_TCL_SRCS}

# define meta rules
# ------------------
  LIB    :=  libCt
  EXE    :=  ctDbg
  SHARED :=  libCt

# define some extra option for TK
# --------------------------------
  MK_DEFINES  = -DCT_LIBRARY=\"${INSTALL_DIR}/lib\"
  MK_INCLUDES =  
  SH_LIBS     = $(TCL_LIB) ${LDLIBS}


# set proto in libCt.h if any .i changed
# ----------------------------------------
${INCDIR}/libCt.i: $(CT_LIB_SRCS:%.c=${DEPDIR}/%.i) 
	${protoRule} 

# Set library & subLib name and give source depending files
# ----------------------------------------------------------
${LIBDIR}/libCt${LIB_SFX}: ${CT_LIB_OBJS}
	${libRule}

${BINDIR}/ctDbg${EXE_SFX}: ${CT_TCL_OBJS} ${LIBDIR}/libCt${LIB_SFX}
	${binRule} $(TCL_LIB) ${LDLIBS}
