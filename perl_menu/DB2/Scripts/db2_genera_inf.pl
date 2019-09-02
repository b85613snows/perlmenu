#!/usr/bin/perl
###########################################################################################
#  Script: db2_genera_inf.pl
#  Input: Script request by console some information
#         Database to be analyzed
#         Customer ( type TEST )
#         Email to receive report
#
#  Output: Except if the script is customized with valid smtp server the html output file
#          will be generated over /tmp/report.html 
#  
#  Static menu perl routine to generate a html report 
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
#use lib './librerias/lib/perl5/';
use lib '.././DB2/Scripts/librerias/lib/perl5/';
use warnings;
use strict;
use HTML::Template;
use lib '.././libs/';
use Arquitectura; 
use Menu;
use POSIX;
use Term::Cap;
use Switch;
use Getopt::Std;
use HotKey;
use Cwd;
use Term::ANSIColor qw(:constants);
use Term::ReadLine;
use Mail::Sender;


my $db2connectrc="";
my $sql="";
my $rc=0;
my @db2call=();

sub auxtrim($)
{
my $string = shift;
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
}


my $time = localtime;

my $bas1 ="";
my $bas2="";
my $var_servinstance = "";
my $var_licinstall = "";
my $var_release ="";
my $var_tipolic ="";
my $var_producto ="";
my $var_fecha="";
my $var_client="";
my $namehost="";


#my @var_features     = ();
#my @var_macvalors   = ();
my @loop_machine =(); 
my @loop_prod=();
my @loop_instancia=();
my @loop_db=();
my @loop_path=();
my $h='/tmp/report.html';
my $mailto="";
my $DB="";

init ();

# Reading values by console


 my $term = Term::ReadLine->new('User');
    my $prompt="";
    my $OUT="";
    my $esok="N";
    $term->ornaments(0);

  cambio_color(BLUE); 
 

    $prompt = "Type database name:  \n";
    $OUT = $term->OUT || \*STDOUT;
    $_= $term->readline($prompt);
    $DB=$_;
    chomp($DB);

    print "\n";

    $prompt = "Type customer name:  TEST   \n";
    $OUT = $term->OUT || \*STDOUT;
    $_= $term->readline($prompt);
    $var_client=$_;
    chomp($var_client);

    print "\n";

    $prompt = "Type email to send report  \n";
    $OUT = $term->OUT || \*STDOUT;
    $_= $term->readline($prompt);
    $mailto=$_;
    chomp($mailto);

    print "\n";


$namehost=`hostname`;
chomp($namehost);
 

print "Connecting to database $DB  $time \n";
$db2connectrc=`db2 -ec +o "connect to $DB"`;
print "Connect rc = $db2connectrc\n";

if ( $db2connectrc eq 0 ) {


  $time = localtime;
  $var_fecha=localtime;
  print "LISTING TABLE ENV_INST_INFO $time \n\n";

   $sql = "select substr(INST_NAME,1,10), substr(SERVICE_LEVEL,1,20), substr(RELEASE_NUM,1,20), substr(PTF,1,20), substr(FIXPACK_NUM,1,10) FROM sysibmadm.ENV_INST_INFO ";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  ENV_INST_INFO   \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";                                   
                                  } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                   ($var_servinstance,$bas1,$bas2)=split(' ',$_);
                                   $var_servinstance="Instance  :  " . auxtrim($var_servinstance) . "                    Database :" . "  $DB";
                                   ($bas1,$var_producto,$var_licinstall,$var_release,$var_tipolic)=split(' ',$_);
                                    $var_producto=auxtrim($var_producto);
                                    $var_licinstall=auxtrim($var_licinstall);
                                    $var_release=auxtrim($var_release);
                                    $var_tipolic=auxtrim($var_tipolic);
                                   
                                   } # END foreach

            }

  $time = localtime;
  print "LISTING TABLE ENV_PROD_INFO $time \n\n";

   $sql = "select substr(INSTALLED_PROD_FULLNAME,1,40),  INSTALLED_PROD_FULLNAME, LICENSE_INSTALLED, PROD_RELEASE, LICENSE_TYPE FROM sysibmadm.ENV_PROD_INFO ";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  ENV_PROD_INFO \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";
                                   } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                 #   print "$_ \n";
                                 my %row_prod;  
                                    ($row_prod{var_prod},$row_prod{var_nprod},$row_prod{var_nlic},$row_prod{var_tlic})=split(' ',$_);
                                    $row_prod{var_prod}=auxtrim($row_prod{var_prod});
                                    $row_prod{var_nprod}=auxtrim($row_prod{var_nprod});
                                    $row_prod{var_nlic}=auxtrim($row_prod{var_nlic});
                                    $row_prod{var_tlic}=auxtrim($row_prod{var_tlic});
                      
                                     push(@loop_prod, \%row_prod);

                                   } # END foreach

            }

   $time = localtime;
  print "LISTING TABLE DBMCFG $time \n\n";

   $sql = "SELECT NAME,VALUE FROM SYSIBMADM.DBMCFG WHERE NAME IN ('audit_buf_sz','cpuspeed','dft_mon_bufpool','dft_mon_lock','dft_mon_sort','dft_mon_stmt','dft_mon_table','dft_mon_timestamp','dft_mon_uow',',authentication','dftdbpath','diagpath','num_initagents','num_poolagents','ssl_versions','instance_memory','svcename','sysadm_group','sysctrl_group','sysmaint_group','sysmon_group')";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  DBMCFG \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";
                                   } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                #   print "$_ \n";
                                    my %row_instancia;  
                                    ($row_instancia{var_instfeat},$row_instancia{var_instvalor})=split(' ',$_);
                                    $row_instancia{var_instfeat}=auxtrim($row_instancia{var_instfeat});
                                    $row_instancia{var_instvalor}=auxtrim($row_instancia{var_instvalor});
 
                                
                                     push(@loop_instancia, \%row_instancia);
                                   } # END foreach

            }

  $time = localtime;
  print "LISTING TABLE DBMCF $time \n\n";

   $sql = "SELECT NAME,VALUE FROM SYSIBMADM.DBCFG where name in ('applheapsz','auto_maint','auto_db_backup','sortheap','util_heap_sz','auto_runstats','auto_stmt_stats','autorestart','dbheap','locklist','locktimeout','database_memory','logarchmeth1','logarchmeth2','logbufsz','logfilsiz','logprimary','logsecond','mirrorlogpath','self_tuning_mem','codepage','codeset','log_retain_status','logpath','pagesize')";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  DBMCF \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";
                                   } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                 #  print "$_ \n";
                                  my %row_db;  
                                    ($row_db{var_bdfeat},$row_db{var_bdvalor})=split(' ',$_);
                                    $row_db{var_bdfeat}=auxtrim($row_db{var_bdfeat});
                                    $row_db{var_bdvalor}=auxtrim($row_db{var_bdvalor});
 
                                
                                     push(@loop_db, \%row_db);
                                   } # END foreach

            }


$time = localtime;
  print "LISTING TABLE  DBPATHS $time \n\n";

   $sql = "SELECT type, substr(path,1,100) FROM SYSIBMADM.DBpaths ";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  DBMCF \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";
                                   } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                #   print "$_ \n";
                                     my %row_path;  
                                    ($row_path{var_tippath},$row_path{var_path})=split(' ',$_);
                                    $row_path{var_tippath}=auxtrim($row_path{var_tippath});
                                    $row_path{var_path}=auxtrim($row_path{var_path});
 
                                    push(@loop_path, \%row_path);

                                   } # END foreach

            }

  $time = localtime;
  print "LISTING TABLE  SYS_RESOURCES $time \n\n";

   $sql = "SELECT substr(NAME,1,40),substr(VALUE,1,40) FROM SYSIBMADM.ENV_SYS_RESOURCES ";
    @db2call = `db2 -x "$sql"`;
    $rc=$?;
    print "Select result rc = $rc \n";
    if (( $rc != 0) && ( $rc != 256 )) {
           print "\n Error listing table  SYS_RESOURCES \n";
           foreach $_ (@db2call) {
                                   print "$_ \n";
                                   } # END foreach
                  exit 8
                  }
       else {
             foreach $_ (@db2call) {
                                    my %row_machine;  
                                    ($row_machine{var_feature},$row_machine{var_macvalor})=split(' ',$_);
                                    $row_machine{var_feature}=auxtrim($row_machine{var_feature});
                                    $row_machine{var_macvalor}=auxtrim($row_machine{var_macvalor});
 
                                
                                     push(@loop_machine, \%row_machine);
                                #   print "$_ \n";
                                   } # END foreach

            }



}   # fin connect


#generating html report

my $template = HTML::Template->new(filename => '.././libs/db2.tmpl');
 $template->param(var_servinstance => $var_servinstance); 
 $template->param(var_producto => $var_producto);
 $template->param(var_licinstall => $var_licinstall);
 $template->param(var_release => $var_release);
 $template->param(var_tipolic => $var_tipolic);   
 $template->param(var_fecha => $var_fecha);   
 $template->param(var_client => $var_client);         

 $template->param(machine_info => \@loop_machine); 
 $template->param(producto_info => \@loop_prod); 
 $template->param(instancia_info => \@loop_instancia); 
 $template->param(db_info => \@loop_db);
 $template->param(db_path => \@loop_path); 

 open(FILE,">$h") ||    die "Failed opening  file: $!";
 print FILE $template->output;
  close FILE;

# Sending mail 


my $smtphost="";
my $mailfrom="";
my $sender="";
my $sender1="";
my $asunto="";
my $cuerpo="";
my @filelst =("/tmp/report.html");

$asunto="Report Database $DB Server $namehost ";
$cuerpo="Report doc Database. Html file attached  \n";




print "-----Sending mail to user  \n";

if ( $var_client eq "TEST") {
        $smtphost="127.0.0.1";
        $mailfrom="DBA_LUW\@es.ibm.com";
                        }


$sender = new Mail::Sender( {from =>$mailfrom,smtp =>$smtphost});
           if( (ref $sender) !~ /Sender/i) {
                                      print "GLITCH: do_EMAIL() problem with Mail::Sender..."
                                      ."...$Mail::Sender::Error\nfrom: $mailfrom,smtp: $smtphost";
                                            }  


    $sender->OpenMultipart({
        to => "$mailto",
        subject => "$asunto"
    });
    $sender->Body;
    $sender->SendLine( "$cuerpo" );
    $sender->SendFile({
        description => 'Raw Data File',
        encoding => '7BIT',
        file => \@filelst,
    });
   
    if( $sender->{'error'} && ( $sender->{'error'} ) < 0 ) {
                                                          print "GLITCH: do_EMAIL() problem with Mail::Sender...\n"."...$Mail::Sender::Error\n";
                                                            } else {
                                                                 print "Msg Sent OK to $mailto\n";
                                                                 print "+++++Mail sended ok  \n\n";
                                                                   }


    $sender->Close;

exit 0
