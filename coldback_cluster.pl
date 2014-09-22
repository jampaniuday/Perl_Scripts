# script: coldback_cluster.pl
# Tasks: Perfoming a RMAN coldback of databases located in the Oracle 3 RAC.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-06-2008 nlharrington Initial Release - completed test run utilizing FANTEST.
#


use strict;
use warnings;

open FILEIN, "E:\\orascrpt\\_Backup\\coldback_list.txt";
while (<FILEIN>)
{
	my($line) = $_;
	chomp($line);

	my($line1) = $line.1;
	print $line1;

	#srvctl stops database and starts one instance in mount mode

	`srvctl stop database -d $line >> 	E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log`;

	`srvctl start instance -d $line -i $line1 -o mount >> 	E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log`;

	open FILEOUT, ">coldback_RAC.cmd";
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
	print FILEOUT 'configure controlfile autobackup format for device type disk to ' . chr(39) .'E:\\orabkup\\rman_bkups\\$line' . '\\CONTROLFILES\\' . '$line_CTRL_%F.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup archivelog from time ' .chr(34).'sysdate - 7' .chr(34). ' format '. chr(39) .'E:\\orabkup\\rman_bkups\\$line' . '\\archivelogs\\' . '$line_ARCHIVELOGS_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT 'backup database format '. chr(39) .'E:\\orabkup\\rman_bkups\\$line' .'\\DATAFILES\\' . '$line_BACKUP_%T_%U.RBK'. chr(39) . chr(59);
	print FILEOUT "\n";
	print FILEOUT "crosscheck backup". chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";

	my $rmanprmpt = 'C:\\ORACLE\\ORA10020001\\BIN\\rman.exe'.chr(32).'target'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).$line1.chr(32).'catalog'.chr(61).'rman_bkup'.chr(47).'rman'.chr(64).'RCAT.WORLD'.chr(32).chr(64).'coldback_RAC.cmd >> E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log';
print $rmanprmpt;

	`cmd /c $rmanprmpt >> E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log`;

	#srvctl stops the instance in mount mode and starts the database

	`srvctl stop instance -d $line -i $line1 >> E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log`;

	`srvctl start database -d $line >> E:\\ORABKUP\\RMAN_BKUPS\\_Coldback_logs\\coldback_cluster.log`;
}

close FILEIN;

`E:/orascrpt/MONITOR.pl`;



