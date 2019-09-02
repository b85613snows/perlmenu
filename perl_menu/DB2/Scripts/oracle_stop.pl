#!/usr/bin/perl
###########################################################################################
#  Script: oracle_stop.pl
#  Input: name of the listener#  
#  Static menu perl routine to list the status of an oracle instance 
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
use Cwd;

sub auxtrim($)
{
my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
}

my $bd=$ARGV[0];
my $dir="";

 my $account; # var for returned information

 $ENV{ORACLE_SID}=$bd;

#####################################################################
#@1 looking for the oracle instance to allocate environment variables 
#####################################################################
my $ficora="/etc/oratab";
my $linea="";
my $orainst="";
my $orahome="";

open(INPUT,"< $ficora") or die "Couldn't open File $ficora  \n";

while (defined ($linea = <INPUT>)) {
      chomp($linea);
      $linea=auxtrim($linea);
      if ((substr($linea,0,1)) =~ /^[a-zA-Z]/)  {                   ## cleaning comments and blanks
                       ($orainst,$orahome,$bas)=split(':',$linea);
                       if ($orainst eq $bd) {
                                              $ENV{ORACLE_HOME}=$orahome;
                                              $ENV{PATH}=$orahome."/bin:".$orahome."/OPatch:/usr/bin:/etc:/usr/sbin:/home/oracle/bin:/usr/bin/X11:/sbin:.";
                                              $ENV{LD_LIBRARY_PATH}=$orahome."/lib:/usr/lib:/lib:".$orahome."/network/lib";
                                              } 
                                                 }        
                                   }
close INPUT;

#################################
#@1 end 
#################################


 $dir=cwd();

# print "directorio $dir \n";

print " \n\n";

$account = `sqlplus -s / as sysdba \@./Scripts/stop_oracle.sql`; 

 print $account;

 exit  0;
