#!/bin/sh -f

# this shell redirecte result from magic filter to bisig NT Box
# 
# Author: fulup 6june96
#

cd /var/spool/tmp

/usr/local/pMaster/misc/magicfilter-1.1/bin/ibm4029-filter.sh > ./smbPrint.$LOGNAME.$$

/usr/local/pMaster/net/samba-1.9.02/bin/smbclient \
	\\\\bisig\\ibm_4029 -E -N -P -U fulup%fridu1  <<!

printmode graphics
print     ./smbPrint.$LOGNAME.$$
!

# remove tempry file
rm -rf ./smbPrint.$LOGNAME.$$

exit 0
