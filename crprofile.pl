# script: crprofile.pl
# Tasks: Updating profiles.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-29-2008 nlharrington Initial Release
#


use strict;
use warnings;


open FILEIN, "C:\\DATABASE.txt";
while (<FILEIN>)
{
	my($line) = $_; 
	chomp($line);

	open FILEOUT, ">crprofile.cmd";
        print FILEOUT "cd \\";
	print FILEOUT "\n";
	print FILEOUT 'SQLPLUS RMAN_BKUP/RMAN'.chr(64).$line." as sysdba \@profile_updater.sql";
	print FILEOUT "\n";
	print FILEOUT "EXIT";
	
	`cmd /k crprofile.cmd >> C:\\crprofile3.log`;
		
}

close FILEIN;
