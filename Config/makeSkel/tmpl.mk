#
#	Copyright(c) 96-98 FRIDU a Free Software Company (Fulup Ar Foll)
#
# Projet    : 	Config
# SubModule :   Generic Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/03/11 10:46:29 $
#      Revision    : $Revision: 3.7 $
#      Source      : $Source: /Master/Common/Config/makeSkel/tmpl.mk,v $
#
#  Modification History
#  ----------------------
#  1.19  1999/03/10 fulup protected proto lib stamp from jwraping
#  1.18  1999/02/20 fulup adapted shared on Solaris
#  1.17  1998/11/27 fulup added jWrap include
#  1.16  1998/10/24 fulup added jWrap + cpp rule corrected shared install
#  1.15  1998/05/25 fulup some cleanup for NT and W95
#  1.14  1998/03/30 fulup FreeBsd cleanup [cf:Mikhail Teterin] add jWrap rule
#  1.13  1998/03/16 fulup corrected shell installation dir creation
#  1.12  1998/03/09 fulup add doc rule with jWrap + javadoc
#  1.11  1998/02/04 fulup added C++ link update cproto for jWrap
#  1.10  1997/12/03 fulup corrected depend extraction
#  1.9   1997/10/16 fulup exclude vim from valid file list
#  1.8   1997/06/20 fulup added html and docs rules
#  1.7   1997/06/01 fulup added Java Rule
#  1.6   1997/05/20 fulup adapted to build.tcl and update installation
#  1.5   1997/04/29 fulup shorten version Stamp
#  1.3   1997/02/01 fulup Updated for multi project
#  1.2   1996/12/21 fulup Initiale CVS external config module
#  1.2   1996/12/20 fulup Commit for Master reorganization
#  1.2   1996/11/18 fulup mkSkel:: fixed RCS checkin of new files [.bak files trouble not fixed]
#

.PHONY: all depend install rcs proto clean \
                mostlyclean shared unix rcsClean indent

all:: lib shared exe

# General proto rules
# -------------------
define protoRule
	@${CECHO} protoMaking $@
	@${FECHO} $@ +slash +aster ---------------------------------
	@${FADD}  $@ : Ansi prototypes generated automaticaly
	@${FADD}  $@ : file $@
	${FADD}  $@ : from $(notdir $?)
	${FADD}  $@ : by ${LOGNAME} on ${HOSTNAME} the $(DATE)
	${FADD}  $@ : ------------------------------------ +aster +slash
	$(FADD)  $@ +diese ifndef JWRAP_JTCL
	$(FADD)  $@ +diese ifdef __cplusplus
	@$(FADD)  $@ extern +quote +raw C +quote +space {
	@$(FADD)  $@ +diese endif 
	@${FADD}  $@ IMPORT char +aster vStamp_$(basename $(notdir $@)) +semicolon
	@$(FADD)  $@ +diese ifdef __cplusplus +newline } +newline +diese endif
	@$(FADD)  $@ +diese endif 
	@$(FAPPEND) $@ $^
endef

# General lib rule (Warning:: no intermediate variable allows in define)
# ----------------------------------------------------------------------
define libRule
	@${CECHO} libMaking  $@
	$(FECHO)  $(DEPDIR)/Stamp-$(notdir $(basename $@)).c \
        const char +aster vStamp_$(basename $(notdir $@)) = \
        +quote Lib_$(VERSION_TEXT) +quote +semicolon 
	${CC_CMD} ${CFLAGS} $(DEPDIR)/Stamp-$(notdir $(basename $@)).c \
	$(O_FLG)${OBJDIR}/Stamp-$(notdir $(basename $@))${OBJ_SFX}
	${AR_ADD} $@  $? ${OBJDIR}/Stamp-$(basename $(notdir $@))${OBJ_SFX}
	${RANLIB} $@ 
endef

# General doc rule
# ----------------
define jDocRule
	@${CECHO} jDocMaking  $(notdir $@)
	@${MKDIR} $(JDOCDIR)/$(basename $(notdir $@))
	${CPP} -dD -nostdinc -C $(LIBINCL)/$(basename $(notdir $@)).h $^ \
        >$(JDOCDIR)/$(basename $(notdir $@)).def 2>$(NULL_DEV) || exit 0
	${JWRAP} --javadoc  $(JDOCDIR)/$(basename $(notdir $@)).def \
        --outdir=$(JDOCDIR)/$(basename $(notdir $@)) --implement=$(notdir $(basename $@))
	${JAVADOC} -sourcepath $(JDOCDIR):$(JDOCDIR)/$(basename $(notdir $@)):$(CLASSPATH) \
	 -d $(JDOCDIR) $(basename $(notdir $@))
endef


# General bin rule (Warning:: no intermediate variable allows in define)
# ----------------------------------------------------------------------
define binRule
	@${CECHO} C binMaking  [$(ARCH_OS)/$(DEBUGLDFLAGS)] $@
	$(FECHO)  $(DEPDIR)/Stamp-$(notdir $(basename $<)).c \
        const char +aster vStampBin_$(basename $(notdir $@)) = \
        +quote Bin_$(VERSION_TEXT) +quote +semicolon 
	${CC_CMD} ${CFLAGS} $(DEPDIR)/Stamp-$(notdir $(basename $<)).c \
	$(O_FLG)${OBJDIR}/Stamp-$(notdir $(basename $<))${OBJ_SFX}
	$(CC_LNK) $(LDFLAGS) $(E_FLG)$@ $^ \
	${OBJDIR}/Stamp-$(notdir $(basename $<))${OBJ_SFX}
endef

# Idem for C++
# -------------
define binPlusRule
	@${CECHO} C++ binMaking  [$(ARCH_OS)/$(DEBUGLDFLAGS)] $@
	$(FECHO)  $(DEPDIR)/Stamp-$(notdir $(basename $<)).c \
        const char +aster vStampBin_$(basename $(notdir $@)) = \
        +quote Bin_$(VERSION_TEXT) +quote +semicolon 
	${CC_CMD} ${CFLAGS} $(DEPDIR)/Stamp-$(notdir $(basename $<)).c \
	$(O_FLG)${OBJDIR}/Stamp-$(notdir $(basename $<))${OBJ_SFX}
	$(CC_PLUS_LNK) $(LDFLAGS) $(E_FLG)$@ $^ \
	${OBJDIR}/Stamp-$(notdir $(basename $<))${OBJ_SFX} 
endef

#
# General share rule WARNING this rule is OS specific 
# ---------------------------------------------------
${SHDIR}/lib%${SO_SFX}:: ${LIBDIR}/lib%${LIB_SFX} 
	@${CECHO} sharedLibMaking  in $@
# --- Build Entry List
ifeq ($(ARCH_OS_TYPE),Unix)
	${AR_LIST} $< | $(CSED) "s#^#$(OBJDIR)/#" \
        | $(GREP) -v SYMDEF >${DEPDIR}/$*.lst
	$(SH_CMD) -L$(SHDIR) $(SH_OUT)$@ $(LIBS:%=${LIBDIR}/%${LIB_SFX}) \
        `$(CCAT)  ${DEPDIR}/$*.lst` $(SH_FLG) ${SHLIBS}
endif
ifeq ($(ARCH_OS_TYPE),WinDos)
	${AR_LIST} $< ${AR_OUT}${DEPDIR}/$*.lst
	${DUMPEXTS} -o${DEPDIR}/$*.def -dlib$*${SO_SFX} -P$(OBJDIR) -- @${DEPDIR}/$*.lst
	$(SH_CMD) $(SH_OUT)$@ $(SH_FLG) $(SH_DEF)${DEPDIR}/$*.def @${OBJDIR}/lib$*${SO_SFX}.lst ${SHLIBS}
endif

# define jWrap and CPP generic rule
# ---------------------------------
define jWrapRule
	@echo jWrap CPP preprocessing $< file in $(notdir $<).cpp
	$(CPP) -D__STDC__ -DJWRAP -DJWRAP_JTCL -dD -nostdinc -C \
        $(JWRAP_CPP_INCL) -I$(INCDIR) $< >$(DEPDIR)/$(notdir $<).cpp || exit 0
	@echo jWrap cc2jTcl from $(DEPDIR)/$(notdir $<).cpp
	$(JWRAP) $(JWRAP_TARGET) $(JWRAP_SOURCE) --include=$< \
	--output=$@ $(DEPDIR)/$(notdir $<).cpp
endef


# General compilation rule for C
# -------------------------------
${OBJDIR}/%${OBJ_SFX}: %.cxx $(DEPDIR)/$(DIR_TAG)
	@${CECHO} compiling++ $<  [$(ARCH_OS),$(PRJ_CCOPTIONS) $(DEBUGCCFLAGS)]
	${CC_PLUS_CMD} ${CPLUSFLAGS} $< $(O_FLG)$@

${OBJDIR}/%${OBJ_SFX}: %.c $(DEPDIR)/$(DIR_TAG)
	@${CECHO} compiling $<  [$(ARCH_OS),$(PRJ_CCOPTIONS) $(DEBUGCCFLAGS)]
	${CC_CMD}  ${CFLAGS} $< $(O_FLG)$@

# General Java Class compilation rule
# -----------------------------------
${CLASSDIR}/%.class: %.java
	@${CECHO} Java compiling $<
	javac -d ${CLASSDIR} $<


# General rcs rule
# ------------------------

# uncomment following for auto checkout rcs regeneration

# invalid quto mqke restoration
%:: RCS/%,v

# get file list and exract ordinary file for rcs saving
  LS_ALL  := $(wildcard *)
  LS_FILES:= $(filter-out ${SUBDIRS} ${MK_SUBDIRS} CVS RCS Exe sav old,$(LS_ALL))
  ALLDIRS := $(filter-out CVS RCS Exe sav old ~ swp,${SUBDIRS} ${EXTDIRS})

# how to store rcs version
RCS/%,v: %
# 	store all file in curent dir except Directory
	${CECHO} ${CI} ${CIFLAGS} $*
	@mkdir -p RCS
	@${RCS} ${RCS_LOCK_FLG} $* 2>${NULL_DEV} ; test 1 -eq 1
	@${CI} ${CIFLAGS} $*        <${NULL_DEV} 2>${NULL_DEV}; test 1 -eq 1

# general rcs rule in itself
rcs:: mostlyclean  $(LS_FILES:%=RCS/%,v)
# 	set symbolic flag for all files
	@${RCS} ${RCS_SYM_FLG} $^ 2>${NULL_DEV} ; test 1 -eq 1

# general rcsClean rule
rcsClean:: 
	$(foreach FILE,${LS_FILES}, (rcs -q -o${BRANCH} ${FILE}; touch ${FILE});)

# change from Dos end of Line of File
# ------------------------------------
unix::
	@${CECHO} cleaning dos CR 
	$(foreach FILE,${LS_FILES}, (tr -d '\r' <${FILE} >${FILE}.new; mv -f ${FILE}.new ${FILE});)
ifdef SUBDIRS
	@${CECHO} cleaning dos CR in ${SUBDIRS}
	$(foreach DIR,${SUBDIRS}, (tr -d '\r' <${DIR}/Makefile >${DIR}/Makefile.new; mv -f ${DIR}/Makefile.new ${DIR}/Makefile);)
endif

# General installation rules
# -------------------------
${RUNTIME_LIBDIR}/%${LIB_SFX}: ${LIBDIR}/%${LIB_SFX}
	@${CECHO} lib installing $< in ${RUNTIME_LIBDIR}
	@mkdir -p  ${RUNTIME_LIBDIR}
	@mkdir -p  ${RUNTIME_INCDIR}
	@${RM}     ${RUNTIME_LIBDIR}/$*${LIB_SFX}
	-${CP}	  $< ${RUNTIME_LIBDIR}/.
	-${CP}	${LIBINCL}/$(basename $(notdir $<)).h ${RUNTIME_INCDIR}/.
	-${CP}	${INCDIR}/$(basename $(notdir $<)).i ${RUNTIME_INCDIR}/.

${RUNTIME_BINDIR}/%${EXE_SFX}: ${BINDIR}/%${EXE_SFX}
	@${CECHO} exe installing $< into ${RUNTIME_BINDIR}
	@mkdir -p ${RUNTIME_BINDIR}
	@${RM}    ${RUNTIME_BINDIR}/$*${EXE_SFX}
	-${CP}	  $< ${RUNTIME_BINDIR}/.

${RUNTIME_SHDIR}/%${SO_SFX}: ${SHDIR}/%${SO_SFX}
	@${CECHO} shared installing $< into ${RUNTIME_SHDIR}
	@mkdir -p ${RUNTIME_SHDIR}
	@${RM} ${RUNTIME_SHDIR}/$*${SO_SFX}  ${RUNTIME_SHDIR}/$*${SA_SFX}
	-${CP}	$< ${SHDIR}/$*${SA_SFX}      ${RUNTIME_SHDIR}/. 2>${NULL_DEV}

${RUNTIME_SHLDIR}/%: %
	@${CECHO} shell installing $< into ${RUNTIME_SHLDIR}
	@mkdir -p ${RUNTIME_SHLDIR}
	@${RM} ${RUNTIME_SHLDIR}/$<
	-${CP}	$< ${RUNTIME_SHLDIR}/. 2>${NULL_DEV}

${RUNTIME_DOCDIR}/%: %
	@${CECHO} Docs installing $< into ${RUNTIME_DOCDIR}
	@mkdir -p ${RUNTIME_DOCDIR}
	@${RM} ${RUNTIME_DOCDIR}/$<
	-${CP}	$< ${RUNTIME_DOCDIR}/. 2>${NULL_DEV}

${RUNTIME_TCLDIR}/%: %
	@${CECHO} Tcl-Tk installing $< into ${RUNTIME_TCLDIR}
	@mkdir -p ${RUNTIME_TCLDIR}
	@${RM} ${RUNTIME_TCLDIR}/$<
	-${CP}	$< ${RUNTIME_TCLDIR}/. 2>${NULL_DEV}

${RUNTIME_INCDIR}/%: %
	@${CECHO} include installing $< into ${RUNTIME_INCDIR}
	@mkdir -p ${RUNTIME_INCDIR}
	@${RM} ${RUNTIME_INCDIR}/$<
	-${CP}	$< ${RUNTIME_INCDIR}/. 2>${NULL_DEV}

${RUNTIME_CLASSDIR}/%: %
	@${CECHO} Java Class installing $< into ${RUNTIME_CLASSDIR}
	@mkdir -p ${RUNTIME_CLASSDIR}
	@${RM} ${RUNTIME_CLASSDIR}/$<
	-${CP}	$< ${RUNTIME_CLASSDIR}/. 2>${NULL_DEV}

# General automatique dependency generation
# -----------------------------------------

ifeq ($(findstring proto,${RULE}),proto)
${DEPDIR}/%.d: %.cxx
	@${CECHO} extracting depend from $<
	${CDEPEND} $@ $< ${ALLINCLUDES} 

${DEPDIR}/%.d: %.c
	@${CECHO} extracting depend from $<
	${CDEPEND} $@ $< ${ALLINCLUDES} 

# proto extracting
# ----------------
${DEPDIR}/%.i: %.cxx
	@${CECHO} extracting cc proto from $<
	${CPROTO} $@ $<

${DEPDIR}/%.i: %.c
	@${CECHO} extracting c proto from $<
	${CPROTO} $@ $< 
endif

# rule for sources indentation
# ---------------------------------
${DEPDIR}/%.indent: %.cxx
	@${CECHO} indenting cc file $<
	@mv $< ${DEPDIR}/$<.${LOGNAME}
	-$(INDENT) ${DEPDIR}/$<.${LOGNAME} -o $<
	@touch $@

${DEPDIR}/%.indent: %.c
	@${CECHO} indenting c file $<
	@mv $< ${DEPDIR}/$<.${LOGNAME}
	-$(INDENT) ${DEPDIR}/$<.${LOGNAME} -o $<
	@touch $@
