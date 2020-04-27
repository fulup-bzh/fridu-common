#	Copyright(c) 96 FRIDU a Free Software Company (Fulup Ar Foll)
#
# Projet    : 	Config
# SubModule :   Generic Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/11/09 17:02:12 $
#      Revision    : $Revision: 3.2 $
#      Source      : $Source: /Master/Common/Config/makeSkel/generic.mk,v $
#
# Modification History
# --------------------
#  1.7  09jan98 fulup moved to FRIDU_CONFIG env name
#  1.6  06jan98 fulup adpated to run in production tree
#  1.5  19oct97 fulup added module definition.mk file
#  1.4  07apr97 fulup move to new History and change projet.mk location
#  1.3  1997/02/06 21:18:33  fulup  Adapted to multi project TOP var
#  1.2  1997/02/01 17:29:30  fulup  Updated for multi project
#  1.2  1996/11/24 14:41:06  fulup  prise en compte des defaults ARCH
#  1.1  1996/11/18 13:55:57  fulup  extracted only include file from generic.mk
#

# include projet 
# ---------------
include ${TOP}/${PROJECT}/Etc/Project.mk
include ${TOP}/${PROJECT}/${MODULE}/Etc/Module.mk

# include specific to architecture values
# ----------------------------------------
include ${FRIDU_CONFIG}/arch/${ARCH_OS}.mk

# include specific to directory build rules
# -----------------------------------------
include ${FRIDU_CONFIG}/makeSkel/default.mk

# include generic rules
# ---------------------
include ${FRIDU_CONFIG}/makeSkel/tmpl.mk

ifdef BUILD_MK
  include ${BUILD_MK}
endif

# include generic rules
# ---------------------
include ${FRIDU_CONFIG}/makeSkel/rules.mk
