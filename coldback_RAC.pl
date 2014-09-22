# script: coldback_cluster.pl
# Tasks: Perfoming a RMAN coldback of databases located in the Oracle 3 RAC.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 04-18-2008 nlharrington Initial Release
#


use strict;
use warnings;

`srvctl sTOP service -d FANTEST -s TESTFAN>E:/orascrpt/FAN_SERVICE_STOP.log`;


configure retention policy to recovery window of 3 days;
configure controlfile autobackup off;
configure controlfile autobackup format for device type disk to 'E:\orabkup\rman_bkups\" & dirin & "\CONTROLFILES\" & dirin & "_CTRL_%F.RBK';
backup archivelog from time  " & chr(34) & "sysdate - 7" & chr(34) & " format 'E:\orabkup\rman_bkups\" & dirin & "\archivelogs\" & dirin & "_ARCHIVELOGS_%T_%U.RBK';
backup database format 'E:\orabkup\rman_bkups\" & dirin & "\DATAFILES\" & dirin & "_BACKUP_%T_%U.RBK';
crosscheck backup;
delete obsolete;


`srvctl sTART service -d FANTEST -s TESTFAN>E:/orascrpt/FAN_SERVICE_START.log`;