# script: rman_hot_backup.pl
# Tasks: Perfoming a RMAN hotback of databases located in Plainfield-OD4.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-07-2008 nlharrington Initial Release - completed test run utilizing FANTEST.
# 01-29-2009 cguillaume   Modified to incorporate DELETE INPUT and removed retention policy.


use strict;
use warnings;


open(FILEIN, "E:\\DIST_DB_SCRPT\\DATABASE.txt") || die "Can't find file: $!\n";
while (<FILEIN>)
{
	
	my($database) = $_; 
	chomp($database);

		
	$ENV{ORACLE_SID}=$database;
   	open FILEOUT, ">rmanhot".$database.".rcv";
	print FILEOUT "configure controlfile autobackup on". chr(59);
	print FILEOUT "\n";
	print FILEOUT 'configure controlfile autobackup format for device type disk to ' . chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database. '\\CONTROLFILES\\' . $database.'_CTRL_%F.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck archivelog all ". chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup database format '. chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database .'\\DATAFILES\\' . $database.'_BACKUP_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "SQL". chr(39) . 'alter system switch logfile' . chr(39) .chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup archivelog all format '. chr(39) .'E:\\orabkup\\RMAN_BKUPS\\'.$database . 	'\\archivelogs\\' . $database.'_ARCHIVELOGS_%T_%U.RBK'. chr(39) . ' DELETE INPUT ' . chr(59);
	print FILEOUT "\n";
	print FILEOUT "SQL". chr(39) . 'alter database backup controlfile to trace' . chr(39) .chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";

        my $rmanprmpt;
        if ("$database" eq "SPPID" ) 
  	   {
 	   $rmanprmpt ="C:\\ORACLE\\ORA10010005\\BIN\\rman.exe target rman_bkup/rman catalog rman_bkup/rman".chr(64)."RCAT.WORLD ".chr(64)."E:\\DIST_DB_SCRPT\\rmanhot$database.rcv  >> E:\\DIST_DB_SCRPT\\LOGS\\rmanhot$database.log";
           }
        else
	   { 
 	   $rmanprmpt ="C:\\ORACLE\\ORA92\\BIN\\rman.exe target rman_bkup/rman catalog rman_bkup/rman".chr(64)."RCAT.WORLD ".chr(64)."E:\\DIST_DB_SCRPT\\rmanhot$database.rcv >> E:\\DIST_DB_SCRPT\\LOGS\\rmanhot$database.log";
	   }
         print $rmanprmpt;
	
	`cmd /c call $rmanprmpt >> E:\\DIST_DB_SCRPT\\LOGS\\Hotback.log`;
	
	`cmd /c hotcopy.cmd`;
	
}
	


close FILEIN;


