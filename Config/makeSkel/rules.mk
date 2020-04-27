#
#	Copyright(c) 96-98 FRIDU a Free Software Company (Fulup Ar Foll)
#
# Projet    : 	Config
# SubModule :   Generic Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/10/24 20:42:01 $
#      Revision    : $Revision: 3.2 $
#      Source      : $Source: /Master/Common/Config/makeSkel/rules.mk,v $
#
# Modification History
# ----------------------
#  1.11 1998/05/20 fulup  cleanup for W95 and NT
#  1.10 1998/04/20 fulup  improved dependency rule moved SRCCS to SRCXX
#  1.9  1998/03/09 fulup  add doc rule with jWrap + javadoc
#  1.8  1998/02/20 fulup  did not include dependency when building proto
#  1.7  1998/02/11 fulup  corrected dependency for c++
#  1.6  1997/06/20 fulup  added Html & docs install
#  1.5  1997/06/01 fulup  added Java rule
#  1.4  1997/05/20 fulup  adapted to build.tcl and update tcl installation
#  1.3  1997/03/09 fulup  Add TGS for Exe private to project dir
#  1.2  1997/02/01 fulup  Updated for multi project 
#  1.2  1996/12/20 fulup  Commit for Master reorganization 
#  1.3  1996/11/18 fulup  extracted from old generic.mk
#  1.2  1996/11/18 fulup  extracted from old generic.mk
#

# set a default values for object file
# -------------------------------------
OBJS   := $(SRCS:%.c=${OBJDIR}/%${OBJ_SFX}) $(SRCXXS:%.cxx=${OBJDIR}/%${OBJ_SFX})
PROTOS := $(SRCS:%.c=${DEPDIR}/%.i) $(SRCXXS:%.cxx=${DEPDIR}/%.i)
DEPS   := $(SRCS:%.c=${DEPDIR}/%.d) $(SRCXXS:%.cxx=${DEPDIR}/%.d)

depend::
	@${CECHO} "-------------------------------------------------------------"
	@${CECHO} "ERROR: Please use [build.tcl -s proto] for dependencies"
	@${CECHO} "-------------------------------------------------------------"
	exit 1

help::
	@${CECHO} "build.tcl -s help" 
	@${CECHO} "-------------------------------------------------------------"
	@${CECHO} "build.tcl -s clean   ;# clean up all tmp dependencies exe,..."
	@${CECHO} "build.tcl -s proto   ;# build *.d dependency & *.i ansi proto"
	@${CECHO} "build.tcl -s         ;# equivalent to build.tcl -s all"
	@${CECHO} "build.tcl -s install ;# intall project in production tree"
	@${CECHO} "-------------------------------------------------------------"
	@${CECHO} "WARNING:"
	@${CECHO} "  0: -s fit for silent should be developper default value"
	@${CECHO} "  1: Fridu Build.mk requirer GNU make and build.tcl wrapper"
	@${CECHO} "  2: Your project should fit Fridu source organization"
	@${CECHO} "  3: Do in order (build.tcl clean; build.tcl proto; build.tcl)"
	@${CECHO} "Check www.fridu.com or ftp.fridu.com for further informations"
	@${CECHO} "-------------------------------------------------------------"
	@${CECHO} ""
	exit 1

clean:: 
ifeq (${TGS},${CURRENT_DIR}/Exe)
	${CECHO} "Basic Exe TOP clean only"
	-${RM} ${BINDIR}/*
	-${RM} ${OBJDIR}/*
	-${RM} ${LIBDIR}/*
	-${RM} ${DEPDIR}/*
	${CECHO} "Basic clean done force Abort"
	exit 1
else
	-${RM} ${LIBS} ${SHARED} ${EXE}
endif

# Automaticaly include dependency
# --------------------------------
ifeq ($(INCL_DEP),1)

$(DEPDIR)/$(DIR_TAG): $(DEP)
	@${CECHO} "***********************************************************"
	@${CECHO} "Depend missing please build them with [build.tcl -s proto]"
	@${CECHO} "***********************************************************"
	$(TCLSH) $(BUILD) -s help
	exit 1

# Try to include dependency don't fail if not present
-include $(DEPS)
else

$(DEPDIR)/$(DIR_TAG): $(DEPS) $(PROTOS) $(LIBS:%=${INCDIR}/%.i)
	$(FECHO) $(DEPDIR)/$(DIR_TAG) "Dependencies Time Stamp"
#	${CECHO} DEP=$(DEPS)
#	${CECHO} PROTO=$(PROTOS)
#	${CECHO} SRCS=$(SRCS)

endif

# general SUBDIR rules
# --------------------
ifneq ($(strip $(SUBDIRS)),)
indent ::
	@${CECHO} Making indent in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, $(TCLSH) $(BUILD) ${DIR} ${MFLAGS} indent;)
	@${CECHO} proto in ${SUBDIRS} done
proto::
	@${CECHO} Making proto in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} proto;)
	@${CECHO} proto in ${SUBDIRS} done
jDoc::
	@${CECHO} Making jDoc in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} jDoc;)
	@${CECHO} jDoc in ${SUBDIRS} done
test::
	@${CECHO} Making test in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} test;)
	@${CECHO} test in ${SUBDIRS} done
lib::
	@${CECHO} Making lib in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} lib;)
	@${CECHO} lib in ${SUBDIRS} done
shared::
	@${CECHO} Making shared in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} shared;)
	@${CECHO} shared in ${SUBDIRS} done
exe::
	@${CECHO} Making exe in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} exe;)
	@${CECHO} exe in ${SUBDIRS} done
else
clean:: mostlyclean
shared::
exe::
endif

ifneq ($(strip $(ALLDIRS)),)
ifneq ($(NOT_INSTALL),1)
install::
	@${CECHO} Making install in ${ALLDIRS}
	$(foreach DIR,${ALLDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} install;)
	@${CECHO} install in ${ALLDIRS} done 
endif
clean::
	@${CECHO} Making clean in ${ALLDIRS}
	-$(foreach DIR,${ALLDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} clean;)
	@${CECHO} clean in ${ALLDIRS} done
rcs::
	@${CECHO} Making rcs in ${ALLDIRS} 
	$(foreach DIR,${ALLDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} rcs;)
	@${CECHO} rcs in ${ALLDIRS} done
rcsClean ::
	@${CECHO} Making rcsClean in ${ALLDIRS}
	$(foreach DIR,${ALLDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} rcsClean;)
	@${CECHO} rcsClean in ${ALLDIRS} done
unix ::
	@${CECHO} Making Unix end of line in ${ALLDIRS}
	$(foreach DIR,${ALLDIRS}, ${TCLSH} ${BUILD} -D ${DIR} ${MFLAGS} unix;)
	@${CECHO} unix in ${ALLDIRS} done
endif


# General cleanning rules
# ------------------------
mostlyclean:
	-${RM} ${PRK_CLEAN} ${ARCH_OS_CLEAN} ${MK_CLEAN} 
	-${RM} ${OBJS} 
	-${RM} ${DEPS} $(DEPDIR)/$(DIR_TAG)
	-${RM} ${PROTOS}
	-${RM} $(DEFAULT_RM)

indent:: $(SRCS:%.c=${DEPDIR}/%.indent)  $(SRCXXS:%.cxx=${DEPDIR}/%.indent)

# automaticaly build rules from meta list variables
# -------------------------------------------------
lib::    $(LIBS:%=${LIBDIR}/%${LIB_SFX})
proto::  $(DEPDIR)/$(DIR_TAG)

jDoc:: $(JDOC:%=${JDOCDIR}/%.html)

# In some cas you are not insterested by installation
# ---------------------------------------------------
ifneq ($(NOT_INSTALL),1)
install:: $(LIBS:%=${RUNTIME_LIBDIR}/%${LIB_SFX})
install:: $(TCL:%=${RUNTIME_TCLDIR}/%)
install:: $(DOC:%=${RUNTIME_DOCDIR}/%)
install:: $(TK:%=${RUNTIME_TCLDIR}/%)
install:: $(SHL:%=${RUNTIME_SHLDIR}/%)
install:: $(INC:%=${RUNTIME_INCDIR}/%)
install:: $(JAVA_CLASS:%=${RUNTIME_CLASSDIR}/%)
install:: $(EXE:%=${RUNTIME_BINDIR}/%${EXE_SFX})
install::   $(SHARED:%=${RUNTIME_SHDIR}/%${SO_SFX})
else
install::
	@${CECHO} $(CURRENT_DIR) directory NOT_INSTALL flag set
endif

uninstall:: 
	-${RM} $(LIBS:%=${RUNTIME_LIBDIR}/%${LIB_SFX})
uninstall:: 
	-${RM} $(EXE:%=${RUNTIME_BINDIR}/%${EXE_SFX})
uninstall:: 
	-${RM} $(SHARED:%=${RUNTIME_SHDIR}/%${SO_SFX})

clean::     
	-${RM} $(LIBS:%=${LIBDIR}/%${LIB_SFX})
clean::     
	-${RM} $(EXE:%=${BINDIR}/%${EXE_SFX})
clean::
	-${RM} $(SHARED:%=${SHDIR}/%${SO_SFX})

shared::    $(SHARED:%=${SHDIR}/%${SO_SFX})
exe::       $(EXE:%=${BINDIR}/%${EXE_SFX})
test::

