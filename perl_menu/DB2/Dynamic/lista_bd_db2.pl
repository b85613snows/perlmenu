#!/usr/bin/perl
###########################################################################################
#  Script: lista_bd_db2.pl
#  Output: list of databases for an db2 instance
#  
#  Dinamyc perl to build the list application and status db commands for db2 instances. 
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
# PDI5_DYNAMIC  <TAG>  DATABASES MENU DB2 LUW INSTANCE <TAG> lista_bd_db2.pl
#
# by static entrys, 
sub auxtrim($)
{
 my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
   }

my @opciones=('1','2','3','4','5','6','7','8','9','a','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z');
my $menuTemp="./menuTemp.txt";
open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
my $Cmd="./Dynamic/lista_bd_db2.sh ";
my @CmdResult=`$Cmd`;
    $rc=$?;
    if ($rc eq 0){
             my $cont=1;
             my $bd="";
             $cont=pop @opciones; 
             foreach $_ (@CmdResult) {
                            ($db)=split(" ",$_);
                             $db=auxtrim($db);
                             print FILERES "$cont <TAG>  DB APPLICATIONS  $db   <TAG> PGM <TAG> db2db.pl  $db <TAG> \n ";
                               $cont=pop @opciones;
                             print FILERES "$cont <TAG>  DB STATUS   $db   <TAG> PGM <TAG> db2db_status.pl  $db <TAG> \n ";
                               $cont=pop @opciones;
                                     } # END foreach
                 }
        else {
               print " Error en comando $rc \n";
               foreach $_ (@CmdResult) {
                             print "$_ \n";
                             exit 8 
                                     }
             }
close FILERES;
exit 0

