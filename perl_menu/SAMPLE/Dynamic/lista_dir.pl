#!/usr/bin/perl
###########################################################################################
#  Script: lista_dir.pl
#  Output: file ./MenuTemp.txt with the result of ejecute the command ls -R over the 
#  current directory

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
# 2 <TAG>  OPTION LIST DIRECTORY. EXAMPLE DYNAMIC OPTION <TAG> PNL <TAG> PDI1 <TAG>
# PDI1_DYNAMIC  <TAG>  LIST DIR EXAMPLE MENU <TAG> lista_dir.pl
#
# by static entrys, in this case, the commands to display the files in the current 
# directory. 
#
# z <TAG>  CAT FILE  ./Dynamic/lista_dir.pl   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl <TAG> 
# y <TAG>  CAT FILE  ./Dynamic/lista_dir.pl~   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl~ <TAG> 
# x <TAG>  CAT FILE  ./Dynamic/lista_dir.pl~   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl~ <TAG> 
# w <TAG>  CAT FILE  ./Scripts/cat.sh   <TAG> PGM <TAG> cat.sh  ./Scripts/cat.sh <TAG> 
# v <TAG>  CAT FILE  ./Scripts/cat.sh~   <TAG> PGM <TAG> cat.sh  ./Scripts/cat.sh~ <TAG> 
#
# The output is sended to menuTemp.txt to be resolved by the menu system generating the following valid
# entry in MenuMain.txt file
#
# PDI1_START <TAG>  LIST DIR EXAMPLE MENU <TAG>
# z <TAG>  CAT FILE  ./Dynamic/lista_dir.pl   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl <TAG> 
# y <TAG>  CAT FILE  ./Dynamic/lista_dir.pl~   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl~ <TAG> 
# x <TAG>  CAT FILE  ./Dynamic/lista_dir.pl~   <TAG> PGM <TAG> cat.sh  ./Dynamic/lista_dir.pl~ <TAG> 
# w <TAG>  CAT FILE  ./Scripts/cat.sh   <TAG> PGM <TAG> cat.sh  ./Scripts/cat.sh <TAG> 
# z <TAG>  CAT FILE  ./Scripts/cat.sh~   <TAG> PGM <TAG> cat.sh  ./Scripts/cat.sh~ <TAG> 
# PDI1_END <TAG>
# 
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
my $Cmd="ls -R ";
my @CmdResult=`$Cmd`;
    $rc=$?;
    if ($rc eq 0){
             my $cont=1;
             my $directory="";
             my $fichero="";
             my $esdir=0;
             my $fic="";
             my $linea="";
             $cont=pop @opciones;
             foreach $_ (@CmdResult) {
                             $linea=auxtrim($_);
                          #   print "linea $linea \n";
                             if ($linea ne '') {
                                                 $esdir=index($linea,'/');   # is a directory or a file ?
                                                 if ($esdir > 0 ) {          #  -> directory
                                                                    $directory=$linea;
                                                                    $directory =~ s/://g;
                                                                    $fichero="";
                                                                   # print "find directory $directory \n";
                                                                   }
                                                     else {
                                                                    $fichero=$linea;   # -> file
                                                           }
                              }
                           
                             if (($directory ne '') and ($fichero ne '')) {
                                                                          $fic=$directory.'/'.$fichero;
                                                                           print FILERES "$cont <TAG>  CAT FILE  $fic   <TAG> PGM <TAG> cat.sh  $fic <TAG> \n ";
                                                                           $cont=pop @opciones;
                                                                           }
                        

                            
                                     } # END foreach
                 }
        else {
               print " Command error $rc \n";
               foreach $_ (@CmdResult) {
                             print "$_ \n";
                             exit 8; 
                                     }
             }
close FILERES;
exit 0
