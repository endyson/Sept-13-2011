#!/usr/bin/perl -w
# File:             pipe_stage_2_chk.pl
# Author:           Xiao,Chang
# Email:            chngxiao@gmail.com
# Original Date:    9/20/2011
# Last Modified:    9/20/2011
# Description:      Test tool used to verify that the output signal pattern of stage Two in the pipe line are correct.
# Copyright:        All right reserved by Xiao,Chang.
# Notice: Please do me a favor to NOT remove the content above. 
#         If you have any modification and description on this, please add it anywhere you like!.
#         This is all I need when I do this.
#         Thank you very much for concernning and Welcome to join into my work!
#         Please Feel free to email me by the email address above.

use strict;

my $line;

open STAGE_2_OUTPUT, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
my $loop_cnt = 0;

foreach $line (<STAGE_2_OUTPUT>){
    $loop_cnt++;
    chomp $line;

        $line =~ /Rn_A=\[([0-9]{1,2})\]\sRm_A=\[([0-9]{1,2})\]\sRd_A=\[([0-9]{1,2})\]\sRn_D=\[([0-9]{1,})\]\sRm_D=\[([0-9]{1,})\]\sRd_D=\[([0-9]{1,})\]\simm_or_reg=\[(.)\]\sshift_or_not=\[(.)\]\sthumb_or_not=\[(.)\]\sop1=\[([0-9]{1,})\]\sop2=\[([0-9]{1,})\]/;

        $rn_addr = $1;
        $rm_addr = $2;
        $rd_addr = $3;
        $rn_data = $4;
        $rm_data = $5;
        $rd_data = $6;
        $imm_or_reg = $7;
        $shift_or_not = $8;
        $thumb_or_not = $9;
        $op1 = $10;
        $op2 = $11;
        
}
