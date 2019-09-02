#!/usr/bin/perl
###########################################################################################
#  Script: start_insts_db2.pl
#  Output: file ./MenuTemp.txt with the result of ejecute the command ./Dynamic/lista_insts_db2.sh 
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
# The target of the script is substitute these dynamic entrys of the MenuMain.ini
#
# PDI3_DYNAMIC  <TAG>  START MENU OF AN INSTANCE DB2 LUW <TAG> start_insts_db2.pl
#
# by static entrys, 
sub auxtrim($)
{
 my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
   }


my $menuTemp="./menuTemp.txt";
open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
my $Cmd="./Dynamic/lista_insts_db2.sh ";
my @CmdResult=`$Cmd`;
    $rc=$?;
    if ($rc eq 0){
             my $cont=1;
             my $instan="";
             foreach $_ (@CmdResult) {
                             ($instan)=split(" ",$_);
                             $instan=auxtrim($instan);
                             print "$_ \n";
                              if  ( getpwuid( $< ) eq 'root') {
                                print FILERES "$cont <TAG>  START INSTANCE  (User/$instan) <TAG> PGM <TAG> db2luw start $instan <TAG> \n ";                              
                                                              }
                                    else                    {
                                print FILERES "$cont <TAG>  START INSTANCE  (User/$instan) <TAG> PGM <TAG>  db2start.pl <TAG> \n ";
                                                            }
                             $cont++;
                                     } # END foreach
               }
               else {
               print " Command error $rc \n";
               foreach $_ (@CmdResult) {
                             print "$_ \n";
                             exit 8 
                                     }
             }
close FILERES;
exit 0

