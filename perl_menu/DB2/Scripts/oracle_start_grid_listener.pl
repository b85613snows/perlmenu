#!/usr/bin/perl
###########################################################################################
#  Script: oracle_start_grid_listener.pl
#  Input: name of the listener
#  
#  Static menu perl routine to list the status of an oracle instance 
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
 my $listener=$ARGV[0];
    my  @processes = `srvctl start listener -l $listener `;
    print "*********STARTING LISTENER BY GRID**********\n\n";
    for $process (@processes) {
        chomp $process;
        print "$process \n";
    }
     print "*******************************************\n\n";

     

exit 0;

