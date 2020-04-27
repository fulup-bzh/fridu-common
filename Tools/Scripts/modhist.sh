#!/bin/sh -f 

#extract Last modificitation list from file

echo "sed $*"
sed  -n '/^[\#, ,/,*]*Modification./s///p' <$1 >history.mod
