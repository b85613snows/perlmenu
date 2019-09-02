#!/usr/bin/perl
###########################################################################################
#  Script: db2stop.pl
#   Static menu perl routine to stop a db2 instance 
#
#  
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
#
   my  @processes = `db2stop force`;
    for $process (@processes) {
        chomp $process;
        print "$process \n";
    }


exit 0;
