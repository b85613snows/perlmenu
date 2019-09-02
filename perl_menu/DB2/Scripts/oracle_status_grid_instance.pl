#!/usr/bin/perl
###########################################################################################
#  Script: oracle_status_grid_instnace.pl
#  Input: name of the database
#  
#  Static menu perl routine to list the status of an oracle instance using srvctl command 
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
 my $bd=$ARGV[0];
    my  @processes = `srvctl status database -d $bd -v`;
    print "*********LISTING STATUS***************\n\n";
    for $process (@processes) {
        chomp $process;
        print "$process \n";
    }
     print "*************************************\n\n";

     @processes = `srvctl config database -db $bd`;
    print "*********LISTING CONFIGURATION***************\n\n";
    for $process (@processes) {
        chomp $process;
        print "$process \n";
    }
     print "********************************************\n\n";


exit 0;

