#!/usr/bin/perl
###########################################################################################
#  Script: para_grid_listener.pl
#  Output: file ./MenuTemp.txt with the result search listener in oracle_home//network/admin/listener.ora 
#  
#  Dinamyc perl to build the services returning by srvctl status listener command. 
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
# PGI5_DYNAMIC  <TAG> MENU STOP LISTENER BY GRID   <TAG> para_grid_listener.pl <TAG>
#
# by static entrys, 
# ==============================================================================
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
my $bas1="";
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
#   SEARCHING FOR GRID INFRAESTRUCTURE
#
###################################################
open(INPUT,"< $ficora") or die "Couldn't open File $ficora  \n";

my $esgrid='no';

while (defined ($linea = <INPUT>)) {
      chomp($linea);
      $linea=auxtrim($linea);
      if (((substr($linea,0,1)) =~ /^[a-zA-Z]/) || ((substr($linea,0,4)) =~ /\+ASM/)) {
                            ($orainst,$bas)=split(':',$linea);
                        if ( $orainst =~ /ASM/)  { 
                                                   $esgrid='si';
                                                  }   
                                    }        
                                   }
close INPUT;

if ( $esgrid eq 'no' ) {             ## there is no grid entry en /etc/oratab
                     open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
                     print FILERES " \n ";
                     close FILERES;
                    exit 0;
                       } 
   



open(FILERES, "> $menuTemp") or die "Couldn't open File $menuTemp   \n";
my @opciones=('1','2','3','4','5','6','7','8','9','a','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r','s','t','u','v','w','x','y','z');
my $Cmd="srvctl status listener";
my $auxiliar="";
   @arrayinst=`$Cmd`;
             foreach $_ (@arrayinst) {
                             ($bas,$orainst,$bas1)=split(':',$linea);             
                             $orainst=auxtrim($_);
                             if ($orainst =~ /$auxiliar/)  { 
                                                   ## listener duplicated. Ignored
                                                  }  
                             else { 
                             $auxiliar=$auxiliar.$orainst;
                             $cont=pop @opciones;
                              print FILERES "$cont <TAG>  STOP LISTENER  $orainst BY GRID (Us. oracle) <TAG> PGM <TAG> oracle_stop_grid_listener.pl $orainst <TAG> \n ";
                             $cont=pop @opciones;
                                  }
                                     } # END foreach
close FILERES;
exit 0

