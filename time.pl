# script: time.pl
# Tasks: print time
#
#------------------- Revision History -------------------------------------
# Date by Changes
# 06-25-2008 nlharrington Initial Release
#


use strict;
use warnings;

my($time);

$time = localtime();
print $time;