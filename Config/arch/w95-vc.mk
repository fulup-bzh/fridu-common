#
#       Copyright(c) 98 Fridu a Free Software Company
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz
#          Vannes IUP labo Valoria University of South Britany
#
# Projet    : 	Common
# SubModule :   Config Arch specific values
# Auteur    :   Fulup Ar Foll (fulup@fridu.com)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:19 $
#      Revision    : $Revision: 3.2 $
#      Source      : $Source: /Master/Common/Config/arch/w95-vc.mk,v $
#
# Modification History
# --------------------
# 01c,18may98,fulup adapted to Fridu configuration
# 01b,30jun97,fulup adpated to new config architecture
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH
#
# NOTE: w95-msvc.mk is derivated from ntx86.mk check ntx86 for any info


# For some obscur raison W95 does not find cl !!!
# -----------------------------------------------
  override FRIDU_HOME   := c:/pMaster/Fridu
  override MSVC_MASTER  := c:/pMaster/msvc-4.2
  override TCL_MASTER   := c:/pMaster/Tcl-8.0
  override TORNADO_BASE := c:/pMaster/tornado-1.0

# define OS Name for further use
# ------------------------------
  override ARCH_OS_NAME   := W95

# define pMaster location
# -------------------------
  override  PMASTER       := c:/pMaster

# define everyting else from NT 
# ---------------------------------------
include ${COMMON_CONFIG}/arch/ntx86-vc.mk
