# message_SP.pm
package message_SP;
#################################################
# package message_SP 
# Version 2.01 AUGUST 2019 
# AUTHOR: Gustavo Mayordomo (83885613@es.ibm.com)
# GROUP:  Grupo Bases de datos torre 1
# File for Spanish options tranlations 
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
        msg0 => 'SALIENDO ',
        msg1 => 'OPCION NO VALIDA',
        msg8 => 'NO EXISTE MENU INICIAL ',
        msg10 => 'ERROR MOSTRANDO MENU INICIAL ',
        msg12 => 'NO EXISTE MENU PREVIO ',
        msg14 => 'NO EXISTE MENU SIGUIENTE O SCRIPT INEXISTENTE ',
        msg16 => 'ERROR EN EJECUCION DE SCRIPT ',
        msg20 => 'ERROR EN RESOLUCION DE MENU DINAMICO ',
        msg25 => 'NO SE PUEDE COPIAR FICHERO DE TERMCAP. POSIBLE ERROR EN RESOLUCION EN GRAFICOS ',
        msg30 => 'DIRECTORIO DE SCRIPTS NO ENCONTRADO                 ', 
        msg50 => 'Uso menu.pl [switches] [arguments] ',
        msg51 => '-h  ayuda ',
        msg52 => '-a [grupo] Indica el grupo de menu a mostrar. Defecto: Sample ',
        msg53 => '-d  debug. Genera salida a debug.txt',  
        msg54 => 'Eplo.  menu.pl -a DB2',  
        msg99 => 'ERROR DESCONOCIDO ',  
        var01 => 'USUARIO ', 
        var02 => 'DIA     ', 
        var03 => 'HORA    ',   
        var04 => 'SIST.OP.',
        opt01 => 'TECLEE OPCION ',
        opt02 => 'MENU ANTERIOR ',
        opt03 => 'SALIR', 
              
    );

  return %lang_msg;
}



END { }

1;

 
