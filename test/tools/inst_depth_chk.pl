#!/usr/bin/perl -w
# File:             inst_depth_chk.pl
# Author:           Xiao,Chang
# Email:            chngxiao@gmail.com
# Original Date:    9/22/2011
# Last Modified:    9/22/2011
# Description:      A tool used to count the memory depth used by the test instrutions. And the counted instruction depth is used to terminated the simulation
# Copyright:        2011 All right reserved by Xiao,Chang
# Notice: Please do me a favor to NOT remove the content above. 
#         If you have any modification and description on this, please add it anywhere you like!.
#         This is all I need when I do this.
#         Thank you very much for concernning and Welcome to join into my work!
#         Please Feel free to email me by the email address above.
#
use strict;

open INST_DAT, $ARGV[0] or die "Can not open file $ARGV[0]!\n";

my $inst_depth = 0;

foreach(<INST_DAT>){
$inst_depth++;
}
printf "%x", $inst_depth;

