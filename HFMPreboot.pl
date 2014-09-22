# Name: 	PSFT9Sreboot.pl
# Description: 	Sets trigger alert to reboot PSFT9S
# Release Date:	Pending
# Modifiations: 
# FORMAT <user> <date> <change.
# TESTING COMPLETE FOR SCRIPT
# 

#use strict;
#use warnings;

my($time);

my $DayOfMonth = (localtime)[3];
$DayOfMonth = sprintf("%02d", $DayOfMonth); 
my $Month = (localtime)[4] + 1; 
$Month = sprintf("%02d", $Month);
my $Year = (localtime)[5] + 1900; 
my $Today = $Year . "_" . $Month . "_" . $DayOfMonth;
my $HostName="Plainfield-OD1";

open (LOGFILE,">>PSFT9Sreboot.log");
$time = localtime();
print LOGFILE "Starting PSFT9S Reboot at $time\n";

print "Do you want to continue (Y)es or (N)o?";

if (($stmt eq "Y") || ($stmt eq "y")){
	print "I will continue now \n";
	my $str = 'net stop oracleservicePSFT9S';
	$time = localtime();
	open (LOGFILE,">>$ORASCPDIR/LOGS/bounce.log ");
	print LOGFILE "$time: running $str  \n";
	close LOGFILE;
	print "Shutting down PSFT9S. \n";
	print "Please contact the help desk if you experience any problems. \n";
	`cmd /c call $str >> $ORASCPDIR/LOGS/bounce.log`;
	print "PSFT9S shutdown \n";
	my $str2 = 'net start oracleservicePSFT9S';
	`cmd /c call $str2 >> $ORASCPDIR/LOGS/bounce.log`;
	}
else
{
print "Good-bye";
exit;
}

