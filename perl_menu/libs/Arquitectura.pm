package Arquitectura; 
#################################################
# package Arquitectura 
# Version 2.01 AUGUST 2019 
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
#  Package for common routines 
# ###############################################
# =============================================================================
# History of Changes
# =============================================================================
# Version   Person: /Comments
# 20190724  Gustavo Mayordomo : Created from Spanish version 1.17
# 20190814  Gustavo Mayordomo : Modify comments and code to English support
# =============================================================================

  use strict;
  use warnings;

  use POSIX qw(strftime);

    BEGIN {
        require Exporter;

        # Version of the utility
        our $VERSION     = 1.18;

        # Heritage from Exporter to export functions and variables
        our @ISA         = qw(Exporter);

        # Predetermined functions and variables
        our @EXPORT      = qw(get_ssoo trim ltrim rtrim initpila insertpila extraepila $dato $res $string $res_ssoo @pila leoparam %hash_param get_dia $dia 
                            list_environment get_hora $hora);

        # Optional functions and variables exported
        our @EXPORT_OK   = qw($Var1 %Hash1 func3);
    }

    # Global variables to export
    our $Var1    = '';
    our $res_ssoo = '';
    our $res ='';
    our $string = '';
    our %Hash1  = ();
    our $dato = '';
    our $dia='';
    our $hora='';

    
    our @otras    = ();
    our $cosa   = '';
    our @pila = ();
    our %hash_param = ();
    

    # lexical private variables
    my $var_priv    = '';
    my %hash_secreto = ();
   

    # Functions
    # can call using  $func_priv->();
 
   my $func_priv = sub {
        
    };

    

##########################################################################
# Routine: list_environment
# Print environment variables 
##########################################################################
    sub list_environment

            {

             my $key="";  

             foreach $key (sort keys(%ENV)) {
                       print "$key = $ENV{$key}";
                                             }    

            ; 

             }    

##########################################################################
# Routine: get_ssoo
# Output: Operative system detected
# Routine to return the operative system 
##########################################################################
    sub get_ssoo      {

        my ($parametros) = @_;
	
	my $osname = $^O;


        if( $osname eq 'MSWin32' ){{
              eval { require Win32; } or last;
              $osname = Win32::GetOSName();
              # work around for historical reasons
              $osname = 'WinXP' if $osname =~ /^WinXP/;
                                   }}
        $res_ssoo = $osname;         
	
	return ($res_ssoo)
                   }

##########################################################################
# Routine: get_dia
# Output: Return date
# Routine to return the actual date 
##########################################################################
    sub get_dia      {

         $dia = strftime "%a %b %e %Y", localtime;

	return ($dia)
                   }


##########################################################################
# Routine: get_time
# Output: Return time
# Routine to return the actual server time 
##########################################################################
    sub get_hora      {

                  
         $hora = strftime "%H:%M:%S ", localtime;
        
	
	return ($hora)
                   }


##########################################################################
# Routine: initpila
# Input: Menu Stack
# Output: Menu Stack
# Routine to initialize menus stack 
##########################################################################
sub initpila

 {
     my  @pila= @_;
     push @pila,'FIN';
     return @pila;
 }

#########################################################################
# Routine: insertpila
# Input: Menu Stack
# Output: Menu Stack
# Routine to push menus into menus stack 
##########################################################################
sub insertpila
 {
   my  ($dato, @pila) = @_;
   push @pila,$dato;
   return @pila;
 }

#########################################################################
# Routine: extraepila
# Input: Menu Stack
# Output: Menu Stack
# Routine to pop menus from menus stack 
##########################################################################
sub extraepila
 {
   my  @pila= @_;
   $dato= pop @pila ;
   return ($dato,@pila);
 }


#########################################################################
# Routine: trim
# Routine  trim function to remove whitespace from the start and end of the string 
##########################################################################
sub trim($)
{
 my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
   }
###########################################################################
# Routine ltrim
# Left trim function to remove leading whitespace
###########################################################################
sub ltrim($)
 {
  my $string = shift;
  $string =~ s/^\s+//;
  return $string;
 }
###########################################################################
# Routine rtrim
# Right trim function to remove trailing whitespace
###########################################################################
sub rtrim($)
 {
  my $string = shift;
  $string =~ s/\s+$//;
  return $string;
 }

#########################################################################
# Routine: leoparam
# Output: Hash hash_param with values from param.txt file
# Routine to fill hash_param with param.txt options (language options)
#########################################################################
sub leoparam($)
 {
  my $param_string = shift;
  my $linea ="";
  my $variable ="";
  my $valor="";


  if ( $param_string eq '' ) {
                                $param_string="./param.txt";
                              }
 
   open(FILEPAR, "< $param_string")
    or die "Couldn't open File $param_string   \n";

    while (defined ($linea = <FILEPAR>)) {
     
    $linea=trim($linea);
     
    if (( substr $linea, 0, 1)  ne '#' ) {    

     ($variable, $valor) = split('=', $linea);
         $variable =  trim($variable);
         $valor =  trim($valor);
         $hash_param{ $variable } = $valor;
           
                                         }   # if
  
                                      }  # while
   close (FILEPAR); 

   return %hash_param;
   
 }
  
 
    END {  }       # Global terminator


1;
