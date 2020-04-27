#  $Header: /Master/Common/Samples/Mk-build/build-complex.mk,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#  Copyright(c) 1997 Wandel & Golterman Cersem Rennes
#  Copyright(c) 96-97 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Build.mk
# Projet    :   Cersem mire DRV
# SubModule :   Bench Benchhrone
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Samples/Mk-build/build-complex.mk,v $
#      State       : $State: Exp $
#
#Modification History 
#--------------------
#01a,26jun97,fulup written from jTcl example
#

# Define init modules
# ------------------------
  LIB_SRCS = utilsBench.c coreBench.c getopt.c \
             getopt1.c initBench.c tclBench.c

  LIB_OBJS = $(LIB_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  BIN_SRCS  = mainBench.c
  BIN_OBJS  = $(BIN_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  DBG_SRCS  = debugBench.c
  DBG_OBJS  = $(DBG_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  SRCS         = ${LIB_SRCS} ${BIN_SRCS}

# define meta rules
# ------------------
  LIB    :=  libBench
  EXE    :=  bench benchDbg
  EXE    :=  benchDbg
  SHARED :=  libBench
  SHLIBS = ${JTCL_LIB} ${TCL_LIB} ${LDLIBS}

# define some extra option 
# ------------------------
ifeq (${ARCH_OS},linuxAxp)
  MK_DEFINES=
else
  MK_DEFINES  = -DUSE_REALTIME_TIMER
endif
  MK_INCLUDES =  

# set proto in libBench.h if any .i changed
# ----------------------------------------
${INCDIR}/libBench.i: $(LIB_SRCS:%.c=${DEPDIR}/%.i) 
	${protoRule} 
	cp $(TOP)/Exe/$(ARCH_OS)/include/libBench.i ../Include

# Set library & subLib name and give source depending files
# ----------------------------------------------------------
${LIBDIR}/libBench${LIB_SFX}: ${LIB_OBJS}
	${libRule}

${BINDIR}/bench${EXE_SFX}: ${BIN_OBJS} ${LIBDIR}/libBench${LIB_SFX}
	${binRule} ${LDLIBS}

${BINDIR}/benchDbg${EXE_SFX}: ${DBG_OBJS} ${LIBDIR}/libBench${LIB_SFX}
	${binRule} ${JTCL_LIB} ${TCL_LIB} ${LDLIBS} 





