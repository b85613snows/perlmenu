#!/bin/bash
###########################################################################################
#  Script: cat.sh
#  Input:  file to cat
#  Output: file content
#
#  Very simple example of a static script in menu tool. This script only execute a cat over
#  a file passed as parameter 
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
# =============================================================================

sub existScript
cat $1
exit

