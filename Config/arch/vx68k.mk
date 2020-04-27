#
#	Copyright(c) 95-96 gant Skol Veur Breizh Kreizteiz (IUP) Gwened
#                      University of South Britany
#
# File   	:   linux86.mk, linux for Intel specific VALUES
# Projet	: 	cTest
# SubModule :   Makefile configuration
# Auteur    :   Fulup Ar Foll (fulup@iu-vannes.fr)
#
# Last
#      Author      : $Author: fulup $
#      Date        : $Date: 1998/07/15 12:48:18 $
#      Revision    : $Revision: 3.1 $
#      Source      : $Source: /Master/Common/Config/arch/vx68k.mk,v $
#
# Modification History
# -------------------------

#  Revision 1.1.1.1  1997/10/19 15:05:56  fulup
#  New project/module tree
#
#  Revision 1.1.1.1  1996/12/20 09:05:26  fulup
#  First Splited Master version
#
#  Revision 1.1.1.1  1996/12/08 13:47:10  fulup
#  Initiale cvs Version
#
#  Revision 1.3  1996/06/21 17:32:38  fulup
#   Cleaned for multi ARCH 2.1 release
#
#  Revision 1.2  1996/04/18 23:15:43  fulup
#   Cleaned for multi ARCH 2.1 release
#
# 01a,26mar95,fulup writen from old cTest Imake.prj.$ARCH

export WIND_BASE           :=/erdre1/tornadoSolaris
export WIND_HOST_BIN       :=${WIND_BASE}/host/${WIND_HOST_TYPE}
export GCC_EXEC_PREFIX     :=${WIND_HOST_BIN}/lib/gcc-lib/
export VX_CPU_FAMILY       :=68k

override OS_NAME           :=vxWorks
override ARCH              :=m${VX_CPU_FAMILY} 
override UNTOUCH           := touch -t 01010000

override CC                :=${WIND_HOST_BIN}/bin/cc68k
override LD                :=${WIND_HOST_BIN}/bin/ld68k 
override SH_CMD            := ${LD} -r

override MK_LOAD_FLAGS     := -r
override ARCH_OS_INCLUDES  := -I${WIND_BASE}/target/h
override ARCH_OS_DEFINES   := -DCPU=MC68030
