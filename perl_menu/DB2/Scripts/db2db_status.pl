#! /usr/bin/perl 
###########################################################################################
#  Script: db2db_status.pl
#  Input: name of the database
#  
#  Static menu perl routine to connect a database and get information connection 
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
################################################################################
#### Perl trim function to remove whitespace from the start and end of the string
##################################################################################
sub trim($)
{
 my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
   }
#################################################
# Left trim function to remove leading whitespace
#################################################
sub ltrim($)
 {
  my $string = shift;
  $string =~ s/^\s+//;
  return $string;
 }
##################################################
# Right trim function to remove trailing whitespace
##################################################
sub rtrim($)
 {
  my $string = shift;
  $string =~ s/\s+$//;
  return $string;
 }


#####################################################
# Rutina principal
#####################################################


    my $bd=$ARGV[0];

    my $db2lis="db2 connect to $bd  ";
    my @db2lis=`$db2lis`;
     foreach $_ (@db2lis) {
                                print $_ ;
                       } # END foreach

exit 0

                    
