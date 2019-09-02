#!/usr/bin/perl
###########################################################################################
#  Script: start_listener.pl
#  Output: file ./MenuTemp.txt with the result search instances in /etc/oratab 
#  
#  Dinamyc perl to build the list status for oracle instances for oracle databases. 
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
# PD01_DYNAMIC  <TAG> STATUS MENU ORACLE INSTANCES <TAG>  lista_insts_ora.pl  <TAG>
#
# by static entrys,
# ==============================================================================
# Instances and listener are searching from the differents entrys in /etc/oratab
# Be aware with the ASM entry. If it does not exist probably listeners are not found
#
# +ASM:/u01/app/oracle/product/12.1.0/grid:N
# MISC02PQ1:/u01/app/oracle/product/11.2.0/db_1:N
# RIE01PQ1:/u01/app/oracle/product/12.1.0/db_1:N
# BTOT02PQ1:/u01/app/oracle/product/12.1.0/db_1:N
# BTOT01UQ1:/u01/app/oracle/product/12.1.0/db_1:N         # line added by Agent
#
######################################################################################
sub auxtrim($)
{
my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
}

my @arrayinst=();
my $orainst="";
my $bas="";
my $linea="";
my $ficora="/etc/oratab";
my $cont=1;

if  (! -e $ficora ) {             ## its not oracle
                    exit 0;
                    } 

open(INPUT,"< $ficora") or die "Couldn't open File $ficora  \n";



while (defined ($linea = <INPUT>)) {
      chomp($linea);
      $linea=auxtrim($linea);
      if ((substr($linea,0,1)) =~ /^[a-zA-Z]/)  {                   ## cleaning blanks and comments
                       ($orainst,$bas)=split(':',$linea);
                       push (@arrayinst,$orainst);
                                    }        
                                   }
close INPUT;


my @opciones=('1','2','3','4','5','6','7','8','9','a','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z');
my $menuTemp="./menuTemp.txt";
open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
             $cont=pop @opciones;   
             foreach $_ (@arrayinst) {
                             $orainst=$_;
                             $orainst=auxtrim($orainst);
                        #     print "$_ \n";
                             print FILERES "$cont <TAG>  INSTANCE STATUS  $orainst  (User Oracle) <TAG> PGM <TAG> oracle_status.pl $orainst <TAG> \n ";
                             $cont=pop @opciones;
                                      } # END foreach
close FILERES;
exit 0

