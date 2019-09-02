# message_EN.pm
package message_EN;
#################################################
# package message_EN 
# Version 2.01 AUGUST 2019 
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
# File for English options tranlations 
# ###############################################
# =============================================================================
# History of Changes
# =============================================================================
# Version   Person: /Comments
# 20190724  Gustavo Mayordomo : Created from Spanish version 1.17
# 20190814  Gustavo Mayordomo : Modify comments and code to English support
# =============================================================================

@ISA = qw(Exporter);
@EXPORT = qw(%lang_msg carga_msg);

use strict;

our %lang_msg=();


sub carga_msg {
    

      %lang_msg = (
        msg0 => 'LEAVING.. ',
        msg1 => 'NOT VALID OPTION',
        msg8 => 'NO INITIAL MENU DETECTEDL ',
        msg10 => 'ERROR IN INITIAL MENU ',
        msg12 => 'NO PREVIOUS MENU ',
        msg14 => 'NO NEXT MENU OR UNAVAILABLE SCRIPT ',
        msg16 => 'SCRIPT EXECUTION ERROR ',
        msg20 => 'ERROR RESOLVING DYNAMIC MENU ',
        msg25 => 'TERMCAP FILE CANT BE COPIED. POTENTIAL GRAPHIC ERROR ',
        msg30 => 'SCRIPTS DIRECTORY NOT FOUND ',
        msg50 => 'Use menu.pl [switches] [arguments] ',
        msg51 => '-h  ayuda ',
        msg52 => '-a [group] Pointed to the menu desired. Default: Sample ',
        msg53 => '-d  debug. Exit redirected to  debug.txt',  
        msg54 => 'Eplo.  menu.pl -a DB2',  
        msg99 => 'UNKNOWN ERROR ',  
        var01 => 'USER     ', 
        var02 => 'DATE     ', 
        var03 => 'HOUR     ',   
        var04 => 'OP.SYST.',
        opt01 => 'TYPE OPTION  ', 
        opt02 => 'PREVIOUS MENU ',
        opt03 => 'QUIT ', 

              
    );

  return %lang_msg;
}



END { }

1;

 
