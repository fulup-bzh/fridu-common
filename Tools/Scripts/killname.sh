
#
# killname - kill a process using an alphanumeric key
#
#modification history
#--------------------
# 01c,22Oct96,fulup   adapted to Linux
# 01b,11Jan94,jeymon   multi systems
# 01a,10nov92,laumar   written
#
# set -x

if test $# -lt 1
then
  echo "USAGE: $0 <processName> [SIG]"
  exit 255
fi

echo "Killing $2 all the processes containing the string "$1""

#kill all th processes fitting to the key
#put the number of the processes in a temp file
case $ARCH in
  sun4 )
        ps -ax | grep $1 | cut -f1 -d" " >/tmp/rmProc.$$
        ;;
  rs6000 )
        ps -e | grep $1 | cut -f2 -d" " >/tmp/rmProc.$$
        ;;
  * )
        ps ax | grep $1 | awk '{print $1}' >/tmp/rmProc.$$
        ;;
esac

#kill the processes
if test $# -eq 1
then
  kill -9 `cat /tmp/rmProc.$$` 2>/dev/null
else
  kill $2 `cat /tmp/rmProc.$$` 2>/dev/null
fi

#remove the temp file
rm /tmp/rmProc.$$

exit 0

