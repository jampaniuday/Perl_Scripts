# script: rman_hot_backup.pl
# Tasks: Perfoming a RMAN hotback of databases located in Plainfield-OD4.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-07-2008 nlharrington Initial Release - completed test run utilizing FANTEST.
#


use strict;
use warnings;


open(FILEIN, "Z:\\ORASCRPT\\_Backup\\DATABASE.txt") || die "Can't find file: $!\n";
while (<FILEIN>)
{
	
	my($database) = $_; 
	chomp($database);

		
	open FILEOUT, ">rmanhot.cmd";
	#print FILEOUT "register database".chr(59);
	print FILEOUT "configure retention policy to recovery window of 1 days". chr(59);
	print FILEOUT "\n";
	print FILEOUT "configure controlfile autobackup off". chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck archivelog from time " . chr(34) . "sysdate - 8". chr(34) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "delete obsolete". chr(59);
	print FILEOUT "\n";
	print FILEOUT "configure controlfile autobackup on". chr(59);
	print FILEOUT "\n";
	print FILEOUT 'configure controlfile autobackup format for device type disk to ' . chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database. '\\CONTROLFILES\\' . $database.'_CTRL_%F.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup archivelog from time ' .chr(34).'sysdate - 7' .chr(34). ' format '. chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database . 	'\\archivelogs\\' . $database.'_ARCHIVELOGS_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup database format '. chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database .'\\DATAFILES\\' . $database.'_BACKUP_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck backup". chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";

 	my $rmanprmpt ="C:\\ORACLE\\ORA10020001\\BIN\\rman.exe target rman_bkup/rman".chr(64)."$database.world catalog rman_bkup/rman".chr(64)."RCAT.WORLD ".chr(64)."Z:\\ORASCRPT\\_Backup\\rmanhot.cmd >> E:\\ORABKUP\\RMAN_BKUPS\\_Hotback_logs\\hotback.log";
	print $rmanprmpt;
	
	`cmd /c call $rmanprmpt >> E:\\ORABKUP\\RMAN_BKUPS\\_Hotback_logs\\hotback.log`;
	
	`cmd /c hotcopy.cmd`;
	
}
	


close FILEIN;


