#
#       Copyright(c) 97-98 FRIDU a Free Software Company (Fulup Ar Foll)
#
# File      :   Build.mk Force install and non compling of Test Routines
# Projet    :   Jos jWrap
# Module    :   Test
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1999/02/21 12:29:52 $
#      Revision    : $Revision: 1.2 $
#      Source      : $Source: /Master/Common/Config/Include/Build.mk,v $
#      State       : $State: Exp $
#
#Modification History
#--------------------
#01b,23oct98,fulup,written
#

# do not follow normal installation rules
# ----------------------------------------
  NOT_INSTALL=1

install::
	@echo installation of easyc.h in $(RUNTIME_INCDIR)
	clean.sh
	mkdir -p $(RUNTIME_TCLDIR)
	cp -r $(ARCH_OS_TYPE)  $(RUNTIME_TCLDIR)
