# Convert file from v3.00 to V3.01

# when called with an argument we come from a find subshell
if test $# -eq 1
then
  cd `dirname $1`
  
  case `basename $1` in
  module.mk)
    mv module.mk Module.mk
    ;;
  project.mk)
    mv project.mk Project.mk
    ;;
  package.jTcl)
    mv package.jTcl Package.jTcl
    ;;
  slave.jTcl)
    mv slave.jTcl Slave.jTcl
    ;;

  *)
    echo ERROR: `basename` unknow conversion
    ;;
  esac 
  
  exit
fi

echo   This will change:
echo   -----------------
echo  ' project.mk   -> Project.mk'
echo  ' module.mk    -> Module.mk'
echo  ' package.jTcl -> Package.jTcl'
echo  ' slave.jTcl   -> Slave.jTcl'

echo Starting
 find . -name project.mk   -exec convert2v3-01.sh {} \;
 find . -name module.mk    -exec convert2v3-01.sh {} \;
 find . -name package.jTcl -exec convert2v3-01.sh {} \;
 find . -name slave.jTcl   -exec convert2v3-01.sh {} \;
echo done
