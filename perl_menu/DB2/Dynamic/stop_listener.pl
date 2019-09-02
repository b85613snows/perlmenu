#!/usr/bin/perl
###########################################################################################
#  Script: stop_listener.pl
#  Output: file ./MenuTemp.txt with the result search listener in oracle_home//network/admin/listener.ora 
#  
#  Dinamyc perl to build the stop listener commands for oracle databases. 
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
# PDL2_DYNAMIC  <TAG> STOP MENU ORACLE LISTENER <TAG>  stop_listener.pl <TAG>
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
my $orahome="";
my $ficora="/etc/oratab";
my $cont=1;
my $menuTemp="./menuTemp.txt";

if  (! -e $ficora ) {             ## its not oracle
                     open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
                     print FILERES " \n ";
                     close FILERES;
                    exit 0;
                    } 
###################################################
#
#   SEARCHING ORAHOME IN ORATAB FILE
#
###################################################
open(INPUT,"< $ficora") or die "Couldn't open File $ficora  \n";



while (defined ($linea = <INPUT>)) {
      chomp($linea);
      $linea=auxtrim($linea);
     if (((substr($linea,0,1)) =~ /^[a-zA-Z]/) || ((substr($linea,0,4)) =~ /\+ASM/))  {                   ## Fix 1.11 Cleaning blanks and comments
                      ($orainst,$orahome,$bas)=split(':',$linea);
                      if ( grep { $_ eq $orahome} @arrayinst )  {
                                                       next ;
                                                                  }
                      else                          {        
                                 push (@arrayinst,$orahome);     ## insert home
                                                    }
                                    }        
                                   }
close INPUT;



my @opciones=('1','2','3','4','5','6','7','8','9','a','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z');
open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
             foreach $_ (@arrayinst) {
########################################################################
#
# SEARCHING LISTENER IN LISTENER.ORA 
# 
########################################################################
                             $orahome=$_;
                             $orahome=auxtrim($orahome);
                             my $bas="";
                             my $fic_listen=$orahome.'/network/admin/listener.ora';

                             if ( -e $fic_listen ) {    ## Parche 1.11

                             open(ENTRA,"< $fic_listen") or die "Couldn't open File $fic_listen  \n";
                             $cont=pop @opciones;

                             while (defined ($linea = <ENTRA>)) {
                                     chomp($linea);
                                     if ($linea =~ /SID_LIST_LISTENER_/)        {
                                                           ($bas,$ora_listener)=split('SID_LIST_LISTENER_',$linea);
                                                            $ora_listener =~ s/=//g;     
                                                                                                              
                                                             if ($fic_listen =~ /grid/) { # Parche 1.11
                                                         print FILERES "$cont <TAG>  STOP  LISTENER  $ora_listener  (Us. grid/oracle) <TAG> PGM <TAG> listener_stop.pl $ora_listener <TAG> \n ";
                                                                                      }
                                                           else {
                                                          print FILERES "$cont <TAG>  STOP  LISTENER  $ora_listener  (User Oracle) <TAG> PGM <TAG> listener_stop.pl $ora_listener <TAG> \n ";
                                                                }
                                                            $cont=pop @opciones;
                                                                         }   # end of listener chain
                                                                  }   # end of input
                               close ENTRA;
                                                 }   ## Fix 1.11
                                     } # END foreach
close FILERES;
exit 0

