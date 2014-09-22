# script: jqpquery.pl
# Tasks: Query for Job_Queue_Processes.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 08-27-2009 nlharrington Initial Release
#


use strict;
use warnings;


open FILEIN, "C:\\DATABASE.txt";
while (<FILEIN>)
{
	my($line) = $_; 
	chomp($line);

	open FILEOUT, ">queryjqp.cmd";
        print FILEOUT "cd \\";
	print FILEOUT "\n";
	print FILEOUT 'SQLPLUS NLHARRINGTON/NVKDIE8'.chr(64).$line."  \@queryjqp.sql";
	print FILEOUT "\n";
	print FILEOUT "EXIT";
	
	`cmd /k queryjqp.cmd >> C:\\queryjqp.log`;
		
}

close FILEIN;
