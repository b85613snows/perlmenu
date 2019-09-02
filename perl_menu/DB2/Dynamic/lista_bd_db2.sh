#!/bin/bash
###########################################################################################
#  Script: lista_bd_db2.sh
#  Output: list of databases for an db2 instance
#  
#  Return databases of a db2 instance to the calling program
# Version 2.01 AUGUST 2019 
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
# ###############################################
# =============================================================================
# History of Changes
# =============================================================================
# Version   Person: /Comments
# 20190724  Gustavo Mayordomo : Created from Spanish version 1.17
# 20190814  Gustavo Mayordomo : Modify comments and code to English support
# ============================================================================
ficls="$HOME/sqllib/db2profile"
if [ -e "$ficls" ]

 then

. $HOME/sqllib/db2profile

 else
  exit 0
fi



#set -x

rm -f ./aux.tmp >>  /dev/null
rm -f ./basedatos.txt >> /dev/null

db2  "list db directory " | egrep  'Database alias | Directory entry type'  > ./basedatos.txt
rc=$?
if [ $rc -ne "0" ]
   then
         echo 'list db error ' $rc
         exit 8

fi

while read line

  do

    bd=`expr substr "$line" 40 8`

    read tipobd
    local=`expr substr "$tipobd" 40 8`

    if [ $local = "Indirect" ]
      then
         echo $bd  >> ./aux.tmp      
      fi

 done < ./basedatos.txt

cat ./aux.tmp 
