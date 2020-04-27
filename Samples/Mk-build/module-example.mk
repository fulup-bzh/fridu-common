#  $Header: /Master/Common/Samples/Mk-build/module-example.mk,v 3.0.3.1 1998/05/30 11:25:52 fulup Exp $
#
#	Copyright(c) 97 Fridu a Free Software Company
#
# File      :   module.mk
# Projet    : 	Wandel DVB 
# SubModule :   Bench 
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/05/30 11:25:52 $
#      Revision    : $Revision: 3.0.3.1 $
#      Source      : $Source: /Master/Common/Samples/Mk-build/module-example.mk,v $
#      State       : $State: Exp $
#
# Modification History
# --------------------
# 01a,19oct97, fulup written in order supporting modules
#

  MOD_VERSION   := Bench
  MOD_LIBRARIES =  -lm $(LIBFENCE)
  MOD_INCLUDES  =  $(COMMON_INC) $(JTCL_INC) 

