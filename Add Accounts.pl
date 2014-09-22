# script: addaccounts.pl
# Tasks: Adding accounts.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 02-24-2009 nlharrington Initial Release
#


use strict;
use warnings;


open FILEIN, "C:\\DATABASE4.txt";
while (<FILEIN>)
{
	my($line) = $_; 
	chomp($line);

	open FILEOUT, ">addaccounts.cmd";
        print FILEOUT "cd \\";
	print FILEOUT "\n";
	print FILEOUT 'SQLPLUS RMAN_BKUP/RMAN'.chr(64).$line." as sysdba \@addaccounts.sql";
	print FILEOUT "\n";
	print FILEOUT "EXIT";
	
	`cmd /k addaccounts.cmd >> C:\\addaccounts5.log`;
		
}

close FILEIN;
