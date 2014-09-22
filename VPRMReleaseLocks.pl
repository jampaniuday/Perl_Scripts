# Name: 	KillDevSession.pl
# Description: 	Sets trigger alert to kill locks for a VPRM project
# Release Date:	Pending
# Modifiations: 
# FORMAT <user> <date> <change.
#

#use strict;
#use warnings;
use File::Copy;
use DBI;
use DBD::Oracle;

my($time);

my $DayOfMonth = (localtime)[3];
$DayOfMonth = sprintf("%02d", $DayOfMonth); 
my $Month = (localtime)[4] + 1; 
$Month = sprintf("%02d", $Month);
my $Year = (localtime)[5] + 1900; 
my $Today = $Year . "_" . $Month . "_" . $DayOfMonth;
my $HostName="Plainfield-OD1";

open (LOGFILE,">>VPRMReleaseLocks.log");
$time = localtime();
print LOGFILE "Starting VPRMReleaseLocks at $time\n";

my $DBName = uc(&promptUser("Which database [ PRMPRD | VPRM1D | VPRM1PS | VPRM1TR | VPRM2P ] does the lock exist in:"));
my $dsn="dbi:Oracle:$DBName";
my $dbh = DBI->connect($dsn,'VPRMLOCKFIXUSER',$DBName) || die "Database connection not made: $DBI::errstr";
print LOGFILE "Connected to database $DBName\n";


my $ProjNum = &promptUser("Which project number does the lock exist in:");

my $rv; #holds the return value from Oracle stored procedure
eval { 
    my $func = $dbh->prepare (q { BEGIN :rv := VPRMLOCKFIX.release_locks(:project_number); END; } );
    $func->bind_param(":project_number", $ProjNum);
    $func->bind_param_inout(":rv", \$rv, 6);
    $func->execute;
    $func->finish;
  
    #$dbh->commit;
};

$dbh->disconnect();
print LOGFILE "Released $rv lock(s) for Project $ProjNum\n";

my $Done = &promptUser("You are done!, $rv Locks where released.  Hit ENTER to continue ");


$time = localtime();
print LOGFILE "Ending VPRMReleaseLocks at $time\n";
close LOGFILE;


#----------------------------(  promptUser  )-----------------------------#
#                                                                         #
#  FUNCTION:	promptUser                                                #
#                                                                         #
#  PURPOSE:	Prompt the user for some type of input, and return the    #
#		input back to the calling program.                        #
#                                                                         #
#  ARGS:	$promptString - what you want to prompt the user with     #
#		$defaultValue - (optional) a default value for the prompt #
#                                                                         #
#-------------------------------------------------------------------------#

sub promptUser {

   #-------------------------------------------------------------------#
   #  two possible input arguments - $promptString, and $defaultValue  #
   #  make the input arguments local variables.                        #
   #-------------------------------------------------------------------#

   local($promptString,$defaultValue) = @_;

   #-------------------------------------------------------------------#
   #  if there is a default value, use the first print statement; if   #
   #  no default is provided, print the second string.                 #
   #-------------------------------------------------------------------#

   if ($defaultValue) {
      print $promptString, "[", $defaultValue, "]: ";
   } else {
      print $promptString, " ";
   }

   $| = 1;               # force a flush after our print
   $_ = <STDIN>;         # get the input from STDIN (presumably the keyboard)


   #------------------------------------------------------------------#
   # remove the newline character from the end of the input the user  #
   # gave us.                                                         #
   #------------------------------------------------------------------#

   chomp;

   #-----------------------------------------------------------------#
   #  if we had a $default value, and the user gave us input, then   #
   #  return the input; if we had a default, and they gave us no     #
   #  no input, return the $defaultValue.                            #
   #                                                                 # 
   #  if we did not have a default value, then just return whatever  #
   #  the user gave us.  if they just hit the <enter> key,           #
   #  the calling routine will have to deal with that.               #
   #-----------------------------------------------------------------#

   if ("$defaultValue") {
      return $_ ? $_ : $defaultValue;    # return $_ if it has a value
   } else {
      return $_;
   }
}