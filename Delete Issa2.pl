# script: DeleteIssa2.pl
# Tasks: Drop Issa's account.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 03-03-2009 nlharrington Initial Release
#


use strict;
use warnings;


open FILEIN, "C:\\DATABASE3.txt";
while (<FILEIN>)
{
	my($line) = $_; 
	chomp($line);

	open FILEOUT, ">dropaccount.cmd";
        print FILEOUT "cd \\";
	print FILEOUT "\n";
	print FILEOUT 'SQLPLUS RMAN_BKUP/RMAN'.chr(64).$line." as sysdba \@dropaccount.sql";
	print FILEOUT "\n";
	print FILEOUT "EXIT";
	
	`cmd /k dropaccount.cmd >> C:\\dropaccount2.log`;
		
}

close FILEIN;
