#/bin/sh
###########################################################################################
#  Script: lista_inst_db2.sh
#  Output: list of db2 instances detected in server
#  
#  Dinamyc perl to build the start commands for db2 instances. 
############################################################################################
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
ficls="/usr/local/bin/db2ls"
if [ -e "$ficls" ]
then
    for db2path in `/usr/local/bin/db2ls | cat -n | awk '{if ( $1>3 ) {print $2;}}'`
    do
      $db2path/bin/db2ilist
    done
else
for D in `find /var/db2/ -type d`
do
   cd $D
   if [ -e "profiles.reg" ]
   then
   cat profiles.reg
   fi
done
fi
