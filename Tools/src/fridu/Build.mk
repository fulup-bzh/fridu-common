#
#       Copyright(c) 96-98 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Build.mk
# Projet    :   Common
# SubModule :   Config arch specific
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:53 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Tools/src/fridu/Build.mk,v $
#      State       : $State: Exp $
#
# Modification History
# ---------------------
# 1.3  1998/05/18 fulup adapted to NT without Cygwin
# 1.2  1997/06/02 fulup adapted to new config Etc model
# 1.1  1996/11/18 fulup Written
#

# Define init modules
# ------------------------
  CPROTO_SRCS  = cproto.c
  CPROTO_OBJS  = $(CPROTO_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  SHADOW_SRCS  =  shadow.c
  SHADOW_OBJS  = $(SHADOW_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CDEPEND_SRCS = cdepend.c
  CDEPEND_OBJS = $(CDEPEND_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CECHO_SRCS   = cecho.c
  CECHO_OBJS   = $(CECHO_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CCAT_SRCS    = ccat.c
  CCAT_OBJS    = $(CCAT_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CDEL_SRCS    = cdel.c
  CDEL_OBJS    = $(CDEL_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CTOUCH_SRCS  = ctouch.c
  CTOUCH_OBJS  = $(CTOUCH_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  CLIB_SRCS    = clib.c
  CLIB_OBJS    = $(CLIB_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  DUMP_SRCS    = cDumpExts.c
  DUMP_OBJS    = $(DUMP_SRCS:%.c=${OBJDIR}/%${OBJ_SFX})

  SRCS         = ${CCAT_SRCS}  ${CPROTO_SRCS} ${SHADOW_SRCS} ${CDEPEND_SRCS} \
		 ${CECHO_SRCS} ${CDEL_SRCS}   ${CTOUCH_SRCS} ${CLIB_SRCS} \
		 $(DUMP_SRCS)

# Shadow cannot compile on NT
# ---------------------------
ifeq (${ARCH_OS_TYPE},Unix)
 EXTRA_EXE=shadow
endif
ifeq (${ARCH_OS_TYPE},WinDos)
 EXTRA_EXE=clib cDumpExts
endif

# define meta rules
# ------------------
  EXE := ctouch ccat cproto cdepend cecho cdel $(EXTRA_EXE)

# define some extra option 
# -------------------------
  MK_DEFINES  = 
  MK_INCLUDES = 


# build tools
# -----------
${BINDIR}/cDumpExts${EXE_SFX}: ${DUMP_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/clib${EXE_SFX}: ${CLIB_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/ctouch${EXE_SFX}: ${CTOUCH_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/cdel${EXE_SFX}: ${CDEL_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/ccat${EXE_SFX}: ${CCAT_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/cdepend${EXE_SFX}: ${CDEPEND_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/cproto${EXE_SFX}: ${CPROTO_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/shadow${EXE_SFX}: ${SHADOW_OBJS}
	${binRule} ${LDLIBS} 

${BINDIR}/cecho${EXE_SFX}: ${CECHO_OBJS}
	${binRule} ${LDLIBS} 
