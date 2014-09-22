# script: rman_hot_backup.pl
# Tasks: Perfoming a RMAN hotback of databases located in Plainfield-OD4.
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 05-07-2008 nlharrington Initial Release - completed test run utilizing FANTEST.
#


use strict;
use warnings;
use DBI;
use Win32;
use DBD::Oracle; 

my $NumArgs = $#ARGV + 1;
my($time);
my $OperDB;
my $continue;
my $pass;
my $stmt;
my $result;

#my $DupDate;

my $DayOfMonth = (localtime)[3];
$DayOfMonth = sprintf("%02d", $DayOfMonth); 
my $Month = (localtime)[4] + 1; 
$Month = sprintf("%02d", $Month);
my $Year = (localtime)[5] + 1900; 
my $Today = $Year . "_" . $Month . "_" . $DayOfMonth;


open (LOGFILE,">>C:/OperDB_$Today.log");
$time = localtime();
$stmt = Win32::MsgBox("WARNING: This script will startup all databases on this server at $time.\n\n                                                   Press Yes to Continue\n",48+4,'Startup databases on this server');
(($stmt == 6)? print "I will continue now \n" : exit (0));
#&query_continue;
print "Enter password for startup\n";
&get_password;

open(FILEIN, "E:/ORASCRPT/_Backup/DATABASE.txt") || die "Can't find file: $!\n";
while (<FILEIN>)
{	
	open FILEOUT, ">sqlstart.sql";
	print FILEOUT "STARTUP";
	print FILEOUT "\n";
	print FILEOUT "SELECT TO_CHAR(SYSDATE, 'DD-MON-YY H:MIPM') FROM DUAL".chr(59);
	print FILEOUT "\n";
	print FILEOUT "SELECT NAME FROM V".chr(36)."DATABASE".chr(59);
	print FILEOUT "\n";
	print FILEOUT "exit";
	
	close FILEOUT;
	
	my($database) = $_; 
	chomp($database);
	
	my $dbh = DBI->connect("DBI:Oracle:$database", "RMAN_BKUP", "$pass",{RaiseError =>1, AutoCommit =>0, ora_session_mode => 2})
		or die "Can't connect to Oracle database $DBI::errstr\n";
	
	print "You are connected";
	
	open( SQL, "sqlstart.sql") or die $!;
	while (<SQL>)
	{
	my @statements;
	for my $stmt( @statements ){
	    $dbh->do($_);
	}}
	$dbh->disconnect;
	
	print "You are now disconnected";
}
close FILEIN;

sub query_continue { 
    $continue = substr(<STDIN>, 0, 1);    #take first character only 
    $continue =~ tr/a-z/A-Z/;    #transform to upper case 
    if (( $continue ne "Y" ) && ( $continue ne "N" )) { 
       print "$continue is not a valid answer.\n"; 
       print "Do you wish to continue? (y or n)\n"; 
       &query_continue; 
    } 
    if ( $continue ne "Y" ) { 
       print "Quitting per user request.\n"; 
       exit (0); 
    }
}

sub get_password { 
    chomp($pass = <STDIN>);    #remove "enter" 
}


