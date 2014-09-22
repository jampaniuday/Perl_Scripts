# script: rman_cold_backup.pl
# Tasks: Rman coldback.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 06-03-2008 nlharrington Initial Release
#


use strict;
use warnings;


open(FILEIN, "Z:\\orascrpt\\DATABASE.txt") || die "Can't find file: $!\n";

while (<FILEIN>)
{	
	chomp;
	
	my $databasetest = $_;
	if ($databasetest=~m/:/){
		my ($database,$version) = split/\s*:\s*/;
	
	for($database,$version)
	{
		
	my($database1)=$database.1;
		
	open FILEOUT, ">rmancold.cmd";
	print FILEOUT "cd \\";
	print FILEOUT "\n";
	print FILEOUT "cd C:\\ORA$version\\bin";
	print FILEOUT "\n";
	print FILEOUT 'SQLPLUS RMAN_BKUP/RMAN'.chr(64).$database." as sysdba \@shutdown.sql";
	print FILEOUT "\n";
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
	print FILEOUT 'configure controlfile autobackup format for device type disk to ' . chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\$database' . '\\CONTROLFILES\\' . '$database_CTRL_%F.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup archivelog from time ' .chr(34).'sysdate - 7' .chr(34). ' format '. chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\$database' . '\\archivelogs\\' . '$database_ARCHIVELOGS_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup database format '. chr(39) .'E:\\orabkup\\RMAN_BACKUPS\\$database' .'\\DATAFILES\\' . '$database_BACKUP_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck backup". chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";

	#my $rmanprmpt = 'C:\\ORACLE\\ORA$version\\BIN\\rman.exe'.chr(32).'target'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).$database.chr(32).'catalog'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).'RCAT.WORLD'.chr(32).chr(64).'rmancold.cmd >> E:\\ORABKUP\\RMAN_BACKUPS\\_Coldback_logs\\coldback.log';
	
	print $rmanprmpt;
	
	`cmd /c $rmanprmpt >> E:\\ORABKUP\\RMAN_BACKUPS\\_Coldback_logs\\coldback_cluster.log`;

	}}	
	`cmd /c hotcopy.cmd`;
		
}

close FILEIN;
