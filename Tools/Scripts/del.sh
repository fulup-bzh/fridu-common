#!/bin/sh
#----------------------------------------------------------------;
#                                                                ;
# AUTEUR : Pierre-Alain Darlet                                   ;
#                                                                ;
# SOCIETE : I.T.R.A.    Tel : 99 63 65 63                        ;
#                                                                ;
# Date : 17/05/90                                                ;
#                                                                ;
# Description : commande shell script effectuant un controle     ;
#               sur le caractere d'expansion '*'.                ;
#               La commande 'del' compare le nombre de           ;
#               fichiers a detruire et celui des fichiers        ;
#               presents dans le repertoire. Si le premier       ;
#               est superieur ou egal au second, c'est que       ;
#               le caractere '*' est isole dans la ligne de      ;
#               commande. On affiche alors un message de         ;
#               demande de confirmation.                         ;
#               Un controle est egalement effectue dans le cas   ;
#               de commande recurrente sur un repertoire.        ;
#----------------------------------------------------------------;
#set -x

PATH=/usr/ucb:$PATH

repertoire_courant=`pwd`

if [ $# -eq 0 ]
then
    cat << DEL_USAGE
        usage : del [-r] noms_de_fichiers
DEL_USAGE
else
   if [ $1 = "-r" ]
   then
      if [ -d $2 ]
      then
         echo "Repertoire courant : $repertoire_courant"
         echo "ATTENTION : commande recurrente sur un repertoire."
         echo "            L'arborescence va etre detruite a partir de $2"
         echo -n "Etes-vous d'accord ? (o/n) : "
         read reponse
         if [ $reponse = o -o $reponse = O ]
         then
            /bin/rm $*
         fi
      else
         echo "del : $2 n'est pas un repertoire..." 
      fi
   else
      if [ $# -le 1 ]
      then
              /bin/rm $1
      else

         # On recupere le repertoire sur lequel s'applique la commande,
         # on en liste le contenu, et on compte le nombre fichiers.

         repertoire=`dirname $1`
            echo "Repertoire courant : $repertoire_courant"
            echo "Vous allez detruire $# fichiers tel que $1, $2 ..."
            echo -n "Tapez le nombre de fichiers pour confirmer : "
            read reponse
            if [ "$reponse" = "$#" ]
            then
               /bin/rm $*
            fi
      fi
   fi
fi

