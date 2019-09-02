#!/usr/bin/perl
#################################################
# MENU PERL 
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
# =============================================================================

use lib './libs/';
use Arquitectura; 
use Menu;
use POSIX;
use Term::Cap;
use Switch;
use Getopt::Std;
use HotKey;
use Term::ANSIColor qw(:constants);
use Cwd;

use strict;
use warnings;




################################################################################
#  MAIN PROGRAM 
################################################################################

#eval "use  Win32::OLE('in')";


## define terminal constants

my $scr_reset="\e[2J";
my $scr_blink="\e[5m";
my $scr_blink_off="\e[25m";
my $bg_black="\e[40m";

cambio_color(ON_BLACK);


## define variables

my $ret_code=0;
my $ejecuto=0;
my $ret_code_pgm=0;
my $ret_code_pnl=0;
my $menuactual='';
my $menutmp='';
my $char='';
my $tcap='';
my $delay='';
my %hash_pnl = ();
my %hash_pgm = ();
my @pila_menu =();  
my $maxrow='';
my $maxcol='';
my %option=();
my @tags=();
my $coord_x=1;
my $coord_y=1;
my %param=();
my %mensajes=();
my $olddir = getcwd;
my $dir = getcwd;
our $option_a;

######################################################################
# Define input options
# 
# -D   Debug mode
# -h   Help
# -a   Normal mode pointing to directory scripts
######################################################################
getopts('Dha:',\%option);

if ($option{D}) {
    my $debug_file = './debug.txt';
    open(OUTDBG, "> $debug_file")
    or die "Couldn't open File  $debug_file  \n";

    print OUTDBG "Modo debug.. \n  ";
                 }


my $username = getpwuid( $< );
my $pnl_dia=get_dia();
my $pnl_hora=get_hora();
my $sist_op=get_ssoo();


######################################################################
#
#  COPY .TERMCAP IF IT DOES NOT EXIST IN HOME DIRECTORY 
#
######################################################################

$sist_op=trim($sist_op);

if ($sist_op eq 'aix' ) {
                          my $home_dir=$ENV{HOME};
                          my $term_cap=$home_dir.'/.termcap';
                          if ( ! -e $term_cap) {
                                                 my $Cmd_copy="cp ./libs/.termcap $term_cap";
                                                 my @Cmd_copyres=`$Cmd_copy`;  
                                                 my $rc=$?;
                                                 if ($rc != 0){
                                                                foreach $_ (@Cmd_copyres) {
                                                                                   print "$_ \n";
                                                                                          } # END foreach
                                                                          $ret_code=salir(25);          
 
                                                    }  # END ERROR IF

                                                } #END term camp
                          }               


########################################################################
#
# READING PARAMETER FILE ( language support ) 
#
########################################################################

  %param=leoparam('');
  if ($option{D}) {
                    print OUTDBG "Parameter read... \n  ";   

                    foreach (sort keys %param) {
                    print OUTDBG "$_ : $param{$_}\n";
                                                }
                   } 


########################################################################
#
# DYNAMIC LOAD OF MESSAGES FILE
#
#########################################################################
my $lang = 'message_'.$param{"LANG"}.'.pm';

eval {
    require $lang;
     };

if ($@) {
      die "Error: Language module not found: $@";
}

my $aux='message_'.$param{"LANG"}.'::carga_msg()';

 %mensajes = eval("$aux");
 if ($@) {
      die "Error: Can't loading dynamic language module : $@";
          }
 
if ($option{D}) {
                    print OUTDBG "Messages loaded.. \n  ";   

                    foreach (sort keys %mensajes) {
                    print OUTDBG "$_ : $mensajes{$_}\n";
                                                }
                   }

##############################################################################
#
# PARAMETER PROCESSING
#
##############################################################################

if ($option{h}) {           # if option -h  then write help 
 
    cambio_color(ON_BLACK);
    cambio_color(WHITE);
    print "$mensajes{'msg50'}  \n";
    print "$mensajes{'msg51'}  \n";
    print "$mensajes{'msg52'}  \n";
    print "$mensajes{'msg53'}  \n";
    print "$mensajes{'msg54'}  \n";
    $ret_code=salir(0);
                 }

$option{a}='SAMPLE' unless defined $option{a}; # if option -a use directory script selected. SAMPLE directory as default
    
if (($option{a} ) ne '' ) { 
             $dir=$dir.'/'.$option{a}.'/';
                           }
          else {
             $dir=$dir.'/SAMPLE'.'/';
               }    

 if (! -e $dir )
              {
               $ret_code=salir(30);
              }  
               

 
if ($option{D}) {        # if option -D debug mode
                    print OUTDBG "Directorio .. \n  ";   
                    print OUTDBG "directorio $dir \n";
                   
                   }

#################################################################################
#
# TERMINAL RESET
#
################################################################################# 

init();            # Initialize Term::Cap.



get_ssoo();       #  Getting operating system 


#################################################################################
#
#  COPY MENUMAIN.INI TO MENUMAIN.TXT
#
#################################################################################


$ret_code=copioMenu($dir."MenuMain.ini",$dir."MenuMain.txt");
 if ($option{D}) {
             print OUTDBG "Copy menumain.ini to menumain.txt \n  ";
                  }


#################################################################################
#
# RESOLVING DYNAMIC MENU
#
################################################################################# 

chdir($dir);

my $dinamico = 1;
my $ndynam = "";

do {

    $dinamico = hayDinamic($dir."MenuMain.txt");         # Is there any dynamic menu ?

    if ($option{D}) {
                    print OUTDBG "Return from hayDinamic with code $dinamico \n  ";
                    } 

   

    if ( $dinamico == 1) {                              # Yes.
                            if ($option{D}) {
                                            print OUTDBG "Detecting dynamic menu. Trying to resolve it \n  ";   
                                             } 

                           ($ret_code,$ndynam)=resolDinamic($dir."MenuMain.txt",$dir);
                            if ( $ret_code == 0 )
                                     {
                                      if ($option{D}) {
                                                print OUTDBG "Return from resolDinamic with error code ...$ret_code \n  ";   
                                                       } 
         
                                      $ret_code=salir(20);  # Quit. Error resolving dynamic menu
                                     }
                                else {
                                     if ($option{D}) {
                                                print OUTDBG "Return ok from resolDinamic  ...$ret_code \n  ";
                                                print OUTDBG "Lets try to replace dynamic menu by static contents ....$ndynam...$dir... \n  ";
                                                       }
                             $ret_code=sustDinamic($dir."MenuMain.txt",$ndynam,$dir);
                                     if ( $ret_code == 0 )
                                             {
                                              if ($option{D}) {
                                                print OUTDBG "Return from sustDinamic with error \n  ";
                                                               } 
                                               $ret_code=salir(8);  # Quit 
                                             }
                                      else {
                                               $dinamico = hayDinamic($dir."MenuMain.txt"); 
                                               if ($option{D}) {
                                                print OUTDBG "Testing if there are more dynamic menus \n  ";
                                                       }
                                            } 
                                }
        }  
    }  until ($dinamico == 0); # There is no more dynamic menus     


########################################################################################
# Calling to the first menu ( MAIN )
# Using stack pila_menu to go back to previous menus
########################################################################################

@pila_menu=initpila(@pila_menu);

#############################
# if exist menu MAIN show it
##############################
$ret_code=existSubmenu($dir."MenuMain.txt","MAIN");

 if ( $ret_code == 0 )
              {
                $ret_code=salir(8);
                          
              } 
        else {
               $menuactual="MAIN";
              }   
$ret_code=showmenu($dir."MenuMain.txt","MAIN");

if ( $ret_code == 0 )
              {
                $ret_code=salir(10);
              } 

####################################
# while key pressed not q navigate 
# between menus
####################################

while ( $char ne 'q' ) {

 while (not defined ($char = readkey(-1))) {
                                           select(undef, undef, undef, 0.50);
                                            }


     if ($ejecuto == 1) {
                        $ejecuto=0;
                        clear_screen();
                        $ret_code=showmenu($dir."MenuMain.txt",$menuactual); 
                        $char='%';
                         }

     
   
     if ($char eq 'b' ) {      # returning to the previous menu from stack 
              
                    $menutmp='';
                   ( $menutmp, @pila_menu ) = extraepila(@pila_menu);
                 
                   if ($option{D}) {
                                     print OUTDBG "Our from stack ...$menutmp \n  ";   
                                    }
                 
                    if ( $menutmp eq 'FIN' ) {   # if new menu is FIN, this is the last one so quit  
                                            $ret_code=salir(8);          
                                              }
                   
                   $ret_code=showmenu($dir."MenuMain.txt",$menutmp);   # otherwise show previous menu
                      if ( $ret_code == 0 )
                          {
                           if ($option{D}) {
                                           print OUTDBG "ERROR. There is no previous menu...$menutmp \n  ";   
                                            }
                           $ret_code=salir(12);          
                          } 
                      else {
                           $menuactual=$menutmp; 
                           }
                    
                        }  # end if char equ b

        else {     # resolve if char typed has a valid option defined     
                 
                $ret_code_pgm=existScript($hash_pgm{ $char },$dir);
                $ret_code_pnl=existSubmenu($dir."MenuMain.txt",$hash_pnl{ $char });

                if ($option{D}) {
                          $hash_pgm{ $char }='NULL' unless defined $hash_pgm{ $char };
                          $hash_pnl{ $char }='NULL' unless defined $hash_pnl{ $char };
                          print OUTDBG "Printing Char choosen...$char \n  ";   
                          print OUTDBG "Printing ret_code_pgm....$ret_code_pgm \n  ";
                          print OUTDBG "Printing hash pgm...  $hash_pgm{ $char }\n  ";
                          print OUTDBG "Printing ret_code_pnl....$ret_code_pnl \n  ";
                          print OUTDBG "Printing  hash pnl...  $hash_pnl{ $char }\n  ";
                          print OUTDBG "Printing actual menu... $menuactual  \n  ";
                                 }

               if (( $ret_code_pgm == 0 ) and  ( $ret_code_pnl == 0 ))    # pgm or panel to execete seems not be ok

                 {
                   my $miopt=0;
                   for my $opcpnl (keys %hash_pnl) {
                                         
                                         if ($char eq $opcpnl ) {  
                                                                     if ($option{D}) {
                                                                                  print OUTDBG "TESTING OPCPNL..$char  $opcpnl \n  ";
                                                                                      }
                                                                     
                                                                              $miopt=1;
                                                                              }
                                                   } 
                   for my $opcpgm (keys %hash_pgm) {
                                         if ($char eq $opcpgm ) {
                                                                     if ($option{D}) {
                                                                                  print OUTDBG "TESTING OPCPGM..$char  $opcpgm \n  ";
                                                                                      }
                                                                              $miopt=1;
                                                                              }
                                                   } 
                   
                  if ($miopt == 1 ) {
                                       $ret_code=salir(14);  
                                     }  
                      else {          
                              gotoxy( $coord_x,$coord_y+2);
                              $hash_pnl{$char} = ' ' unless defined $hash_pnl{$char};
                              imprime_color(RED, "  $mensajes{'msg1'}   $char  $hash_pnl{ $char }  \n");
                                                            
                            }    
                                      
                 }   
               else {                                    # pgm or panel to execute seems to be ok 
                      if ( $ret_code_pnl == 1 ) {               # option selected is a panel
                                               
                                               @pila_menu=insertpila($menuactual,@pila_menu);
                                               if ($option{D}) {
                                                             print OUTDBG "Push into stack actual menu...$menuactual \n  ";   
                                                                }
                                               $menutmp=$hash_pnl{$char};
                                               $ret_code=showmenu($dir."MenuMain.txt",$hash_pnl{$char}); 
                                               if ( $ret_code == 0 )
                                                     {
                                                        if ($option{D}) {
                                                             print OUTDBG "Return from showmenu panel with error \n  ";   
                                                                         }
                                                        $ret_code=salir(14);             
                                                     } 
                                                     else {
                                                       $menuactual=$menutmp;  # point to the menu to show
                                                          }
                                                     }
                       else {                             # option selected is a pgm or script     
                               if ($option{D}) {
                                               print OUTDBG "Executing script...$hash_pgm{ $char } \n  ";   
                                                } 
                               $ret_code=executeScript($hash_pgm{ $char },$dir); 
                               if ($ret_code == 0 ){ 
                                                     if ($option{D}) {
                                                             print OUTDBG "Return from showmenu pgm with error \n  ";   
                                                                         }
                                                        $ret_code=salir(14);   
                                                    $ret_code=salir(16);
                                                    }
                                                    else {
                                                          $ejecuto=1;  # pgm or script executed
                                                          }
                                                 
                             }        
                     }
    
              }   # else if  not b  

             }   # wait loop

 clear_screen();
 $ret_code=salir(0);
 cambio_color(ON_BLACK);
 cambio_color(WHITE);
exit 0;


sub salir 
##########################################################################
# Routine: Salir
# Input: Exit code linked to the error
# Exit program due to some error. Input value determine the error code 
##########################################################################

  {
  my ($codesal)  = @_;

   if ($option{D}) {
                      print OUTDBG "Come into salir routine with code ...$codesal \n  ";   
                    } 

 #print $scr_reset;

  cambio_color(ON_BLACK);
  cambio_color(WHITE);

  $hash_pnl{$char} = ' ' unless defined $hash_pnl{$char};


  	switch ($codesal) {
           case 0       { print "$mensajes{'msg0'}  \n"; }
           case 8       { print "$mensajes{'msg8'} \n"; }
           case 10	{ print "$mensajes{'msg10'} \n"; }
           case 12	{ print "$mensajes{'msg12'} $menutmp \n"; } 
           case 14      { print "$mensajes{'msg14'} $hash_pnl{$char} \n"; } 
           case 16      { print "$mensajes{'msg16'} \n"; }  
           case 20      { print "$mensajes{'msg20'} \n"; }  
           case 25      { print "$mensajes{'msg25'} \n"; }
           case 30      { print "$mensajes{'msg30'} \n"; } 
           else { print "$mensajes{'msg99'} \n"; }
                           }

  if ($option{D}) { close (OUTDBG); }

  chdir($olddir);
  
  exit $codesal 
  
  }

sub creoventana
################################################################################
# Routine creoventana
# INPUT: x position
#        x size
#        y position
#        y size
# Draw the header and foot window where the different options are included
#################################################################################
 {
   my ($posx,$sizex,$posy,$sizey ) =  @_;
   my $model='***********************                                                                                                                          ';
   my $cab_top='_____________________________________________________________________________________________________________________________________________________';
   my $cab_lat='|';
      $cab_top=substr($cab_top,0,$sizex);
   my $cleaner=substr($model,0,$sizex-2);
   goto($posx,$posy);
   imprime_color(YELLOW, "$cab_top");
   $posy++;       
          for (my $i=1; $i <= $sizey-1; $i++) {
          goto($posx,$posy);
          imprime_color(YELLOW, "$cab_lat");
          goto($posx,$posy+$sizex);
          imprime_color(YELLOW, "$cab_lat");
          goto($posx+1,$posy);
          imprime_color(WHITE "$cleaner");
          $posy++;
                                                }
 gotoxy($posx,$posy);
 imprime_color(YELLOW, "$cab_top");
 cambio_color(ON_BLACK);
 return 1;
 }

sub showmenu
########################################################################################
# Routine showmenu
# Input:  nameMenu    -> File with menus
#         nameSubmenu -> Menu to show
#
# Output: result 0 (not good), 1 ( ok )
#          build hash_pnl, hash_pgm if 1 with the opcion and pnl/pgm to show
#######################################################################################

 {
  my ($nameMenu, $nameSubmenu)  = @_;

   if ($option{D}) {
                      print OUTDBG "Get in routine showmenu ...$nameMenu, $nameSubmenu \n  ";   
                    }
    
  my  $nameSubmenustart=$nameSubmenu.'_START';

  my  $nameSubmenuend=$nameSubmenu.'_END'; 
  my  $menu_find=0;

    $coord_x=5;
    $coord_y=5;
    @tags=();
    
    
    open(INPUT, "< $nameMenu")
    or die "Couldn't open File $nameMenu   \n";

  my  $result=0;
  my  $line='';
 
    
    while (defined ($line = <INPUT>)) {
    @tags= split('<TAG>', $line);
    my ($dato0, $dato1, $dato2, $dato3) = @tags;
    $dato0 = '' unless defined $dato0;
    $dato1 = '' unless defined $dato1;
    $dato2 = '' unless defined $dato2;
    $dato3 = '' unless defined $dato3; 
    if ($option{D}) {
                      print OUTDBG "Data showmenu routine....$menu_find $dato0, $dato1, $dato2, $dato3 \n  ";   
                    }
        
         $dato0=trim($dato0);  
         if ($dato0 eq $nameSubmenuend) {  # we reach end of menu to show
                                     $menu_find=0;
                                     $coord_x=$coord_x+10;$coord_y=$coord_y+2; 
                                     gotoxy($coord_x,$coord_y);
                                     imprime_color(WHITE, " $mensajes{'opt01'} <n> $mensajes{'opt02'}  <b> $mensajes{'opt03'} <q>  \n");
                                    
                                     }  
         if ($menu_find == 1 )     {  # we build hash of panels and pgms from the menu to show 
                             
                                   $dato1=trim($dato1);
                                   gotoxy($coord_x+5,$coord_y);
                                   imprime_color(GREEN, "$dato0. ");
                                   imprime_color(YELLOW, "$dato1  "); 
                                   $coord_y++; 
                     
                                      # build suboptions arrays
                                  
                                   $dato2=trim($dato2);

                                   if ($dato2 eq 'PNL') {
                                                            $dato3=trim($dato3);
                                                            $hash_pnl{ $dato0 } = $dato3; 
                                                           }
                                    
                                   if ($dato2 eq 'PGM') {
                                                            $dato3=trim($dato3);
                                                            $hash_pgm{ $dato0 } = $dato3; 
                                                           }                                 
  

                                                                                                      
                                     }  
         if ($dato0 eq $nameSubmenustart) {   # we find menu to show
                                     $menu_find=1;
                                     $result =1;
                                     print $scr_reset;
                                     $dato1=trim($dato1); 
                                     gotoxy($coord_x+14,$coord_y+1); 
                                     imprime_color(BLUE, "$dato1 ");
                                     gotoxy($coord_x+60,$coord_y-3); 
                                     imprime_color(GREEN, "$mensajes{'var01'} :  ");
                                     imprime_color(WHITE, "$username");
                                     gotoxy($coord_x+95,$coord_y-3); 
                                     imprime_color(GREEN, "$mensajes{'var04'} :  ");
                                     imprime_color(WHITE, "$sist_op"); 
                                     gotoxy($coord_x+60,$coord_y-2); 
                                     imprime_color(GREEN, "$mensajes{'var02'} :  ");
                                     imprime_color(WHITE, "$pnl_dia");
                                     gotoxy($coord_x+60,$coord_y-1); 
                                     imprime_color(GREEN, "$mensajes{'var03'} :  ");
                                     $pnl_hora=get_hora();
                                     imprime_color(WHITE, "$pnl_hora");

                                     $coord_x=$coord_x+3;$coord_y=$coord_y+3;
                                      
                                     

                                     %hash_pnl = ();
                                     %hash_pgm = ();
                                          }    
  
                                      }  # while
 
   close (INPUT); 
   return $result;

   }


