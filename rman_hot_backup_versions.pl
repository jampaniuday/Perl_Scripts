# script: hotback_cluster.pl
# Tasks: Perfoming a RMAN hotback of databases located in the Oracle 3 RAC.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-07-2008 nlharrington Initial Release - completed test run utilizing FANTEST.
#


use strict;
use warnings;


open(FILEIN, "E:\\orascrpt\\DATABASE.txt") || die "Can't find file: $!\n";
while (<FILEIN>)
{
	my $databasetest = $_;
	if ($databasetest=~m/:/){
		my ($database,$version) = split/\s*:\s*/;
	
	for($database,$version)
	{

	open FILEOUT, ">rmanhot.cmd";
	#print FILEOUT "register database".chr(59);
	print FILEOUT "configure retention policy to recovery window of 3 days". chr(59);
	print FILEOUT "\n";
	print FILEOUT "configure controlfile autobackup off". chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck archivelog from time " . chr(34) . "sysdate - 8". chr(34) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "delete obsolete". chr(59);
	print FILEOUT "\n";
	print FILEOUT "configure controlfile autobackup on". chr(59);
	print FILEOUT "\n";
	print FILEOUT 'configure controlfile autobackup format for device type disk to ' . chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\'.$database. '\\CONTROLFILES\\' . $database.'_CTRL_%F.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup archivelog from time ' .chr(34).'sysdate - 7' .chr(34). ' format '. chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\'.$database . 	'\\archivelogs\\' . $database.'_ARCHIVELOGS_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup database format '. chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\'.$database .'\\DATAFILES\\' . $database.'_BACKUP_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck backup". chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";

 	my $rmanprmpt ='C:\\ORACLE\\ORA$version\\BIN\\rman.exe'.chr(32).'target'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).$database.chr(32).'catalog'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).'RCAT.WORLD'.chr(32).chr(64).'rmanhot.cmd >> E:\\ORABKUP\\RMAN_BACKUPS\\_Hotback_logs\\hotback.log';
print $rmanprmpt;

	`cmd /k $rmanprmpt >> E:\\ORABKUP\\RMAN_BACKUPS\\_Hotback_logs\\hotback.log`;
	`cmd /k hotcopy.cmd`;
	#`cmd /c delete.cmd`;
	
}

close FILEIN;
