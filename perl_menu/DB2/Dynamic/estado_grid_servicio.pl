#!/usr/bin/perl
###########################################################################################
#  Script: estado_grid_servicio.pl
#  Output: file ./MenuTemp.txt with the result search listener in oracle_home//network/admin/listener.ora 
#  
#  Dinamyc perl to build the services returning by srvctl config database command. 
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
# PGI6_DYNAMIC  <TAG> MENU DISPLAY SERVICES BY  GRID   <TAG> estado_grid_servicio.pl <TAG>
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
my @array2=();
my @servicio=();
my $orainst="";
my $bas="";
my $linea="";
my $orahome="";
my $ficora="/etc/oratab";
my $cont=1;
my $menuTemp="./menuTemp.txt";

if  (! -e $ficora ) {             ## it is not oracle
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
my $Cmd="srvctl config database";
my $Cmd1="";
   @arrayinst=`$Cmd`;
             foreach $_ (@arrayinst) {
                             $orainst=auxtrim($_);
                              ##########################################
                              # Searching services in db configuration
                              ########################################## 
                             $Cmd1="srvctl config database -db $orainst";
                             @array2=`$Cmd1`;
                             foreach $array2 (@array2) {
                               if ( $array2 =~ /Services:/)  {
                                   $array2 =~ s/Services://;  
                                 (@servicio)=split(' ',$array2);  
                                  foreach $servicio (@servicio) { 
                                    $servicio=auxtrim($servicio);
                                     if ($servicio eq '' )  { 
                                                         print FILERES " \n";
                                                             }
                                      else  {                              
                                           $cont=pop @opciones;
                                          print FILERES "$cont <TAG>  SERVICE STATUS  $servicio  (Us. oracle) <TAG> PGM <TAG> oracle_status_grid_servicio.pl $servicio <TAG> \n ";
                                          $cont=pop @opciones;
                                            }
                                                                }  # end foreach servicio
                                                               }  # end if servicio                                          
                                           } # END foreach array2 
                                     } # END foreach arrayinst
close FILERES;
exit 0

