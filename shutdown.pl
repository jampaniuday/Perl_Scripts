# Script: shutdown.pl
# Tasks: Perfoming a shutdown databases located on this server.
#        As long as the settings are correct in the registry and the database is in Database.txt,
#        the databases will shutdown immediate. Once the server is restarted, the databases will startup.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 11-04-2008 nlharrington Initial Release - completed test run utilizing PPLU.
# 11-05-2008 nlharrington Initial Release - completed test run utilizing PPLU, PPLD, PPLDMO88
# 11-05-2008 nlharrington Initial Release - tested shortcut on OD3
# 11-17-2008 nlharrington Updated - added Chris Guillaume's drive detector and script will now prompt user to continue.
# 11-17-2008 nlharrington Updated - tested using TEST instance on AJMAN-OP1

use strict;
use warnings;

my($time);
my $stmt;

my $ORASCPDIR ="E:/ORASCRPT";

if (! -d $ORASCPDIR)  
   { 
   $ORASCPDIR ="Z:/ORASCRPT";
   if (! -d $ORASCPDIR)  
      { 
      $ORASCPDIR ="Y:/ORASCRPT";
      if (! -d $ORASCPDIR)  
         { 
         exit;
         }
      }
   }

print "Do you want to continue (Y)es or (N)o?";
chomp($stmt = <STDIN>);

if (($stmt eq "Y") || ($stmt eq "y")){
	print "I will continue now \n";
	open(FILEIN, "$ORASCPDIR/_Backup/DATABASE.txt") || die "Can't find file: $!\n";
	while (<FILEIN>)
	{
		my($database) = $_; 
		chomp($database);
	
		my $str = 'net stop oracleservice'.$database;
		$time = localtime();
		open (LOGFILE,">>$ORASCPDIR/_Backup/shutdown.log ");
		print LOGFILE "$time: running $str  \n";
		close LOGFILE;
		print "Shutting down all databases on this server. Shutting down $database. \n";
		print "After restarting the server, all databases will startup. \n";
		print "Please contact the help desk if you experience any problems. \n";
		`cmd /c call $str >> $ORASCPDIR/_Backup/shutdown.log`;
	}
	
	close FILEIN;

}
else
{
print "Good-bye";
exit;
}






