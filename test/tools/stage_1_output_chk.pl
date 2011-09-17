#!/usr/bin/perl -w
# File:             pipe_stage_1_chk.pl
# Author:           Xiao,Chang
# Email:            chngxiao@gmail.com
# Original Date:    9/14/2011
# Last Modified:    9/14/2011
# Description:      Test tool used to verify that the output signal pattern of stage One in the pipe line are correct.
# Copyright:        All right reserved by Xiao,Chang.
# Notice: Please do me a favor to NOT remove the content above. 
#         If you have any modification and description on this, please add it anywhere you like!.
#         This is all I need when I do this.
#         Thank you very much for concernning and Welcome to join into my work!
#         Please Feel free to email me by the email address above.

use strict;
my $it_status;
my $apsr;

my $next_inst_hw;
my $cur_inst;
my $hint_or_exc;
my $inst_valid;
my $valid_inst;
my $cur_cond;
my $cond_base;
my $line;
my $mask;
my $n;
my $z;
my $v;

open FD, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
my $loop_cnt = 0;
foreach $line (<FD>){
    $loop_cnt++;
#print "The $loop_cnt th Loop\n";
    chomp $line;
    if ( $line =~ /IT Status/) {
        $line =~ /IT Status = \[(........)\]\sAPSR = \[(.....)\]/;
        $it_status = $1;
        $apsr      = $2;
    }

    if ($line =~ /Condition is/) {
        $line =~ /Condition is (..)/;
        $cond_base = $1;
    }


    if ($line =~/next_inst_hw/){
        $line =~ /next_inst_hw = \[(....)\]\scur_inst = \[(........)\]\shint_or_exc = \[(.)\]\sinst_valid = (.)\svalid_inst = \[(........)\]\scur_cond = \[(....)\]\smask = \[(....)\]/;
        $next_inst_hw = $1;
        if(not defined $next_inst_hw) {print "Initialization error. Match Failed!\n";exit}
        $cur_inst = $2;
        if(not defined $cur_inst) {print "Initialization error. Match Failed!\n";exit}
        $hint_or_exc = $3;
        if(not defined $hint_or_exc) {print "Initialization error. Match Failed!\n";exit}
        $inst_valid = $4;
        if(not defined $inst_valid) {print "Initialization error. Match Failed!\n";exit}
        $valid_inst = $5;
        if(not defined $valid_inst) {print "Initialization error. Match Failed!\n";exit}
        $cur_cond = $6;
        if(not defined $cur_cond) {print "Initialization error. Match Failed!\n";exit}
        $mask = $7;
        if(not defined $mask) {print "Initialization error. Match Failed!\n";exit}

        if(not defined $cond_base){
            print "\$cond_base is not defined, Current line is ";
            print $line,"\n";
            next;
        }     

        if($cond_base eq "EQ"){
            if( ($cur_cond eq "0000" && $apsr eq "00000" ||$cur_cond eq "0001" && $apsr =~ /.1.../ ) && $mask ne "0000" && ($hint_or_exc eq "0" || $valid_inst ne "00000000")){print $line,"\n";}
            else {print "Ouput pattern check on line $loop_cnt passed!\n";}
        }
        elsif($cond_base eq "CS"){
            if( ($cur_cond eq "0000" && $apsr eq "00000" || \
                $cur_cond eq "0001" && $apsr =~ /..1../) && $mask ne "0000" && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
    else {print "Ouput pattern check on line $loop_cnt passed!\n";}
}
elsif($cond_base eq "MI"){
    if( ($cur_cond eq "0000" && $apsr eq "00000" || \
        $cur_cond eq "0001" && $apsr =~ /1..../) && $mask ne "0000" && \
($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
            else {print "Ouput pattern check on line $loop_cnt passed!\n";}
        }
        elsif($cond_base eq "VS"){
            if( ($cur_cond eq "0000" && $apsr eq "00000" || \
                $cur_cond eq "0001" && $apsr =~ /...1./) && $mask ne "0000" && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
    else {print "Ouput pattern check on line $loop_cnt passed!\n";}
}
elsif($cond_base eq "HI"){
    if( ($cur_cond eq "0000" && ~($apsr =~ /.01../) || \
        $cur_cond eq "0001" && $apsr =~ /.01../ )&& $mask ne "0000" && \
($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
            else {print "Ouput pattern check on line $loop_cnt passed!\n";}
        }
        elsif($cond_base eq "GE"){
            $apsr =~ /(.)..(.)./;
            $n = $1;
            $v = $2;

            if( ($cur_cond eq "0000" && $n ne $z || \
                $cur_cond eq "0001" && $n eq $z ) && $mask ne "0000" && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
    else {print "Ouput pattern check on line $loop_cnt passed!\n";}
}
elsif($cond_base eq "GT"){
    $apsr =~ /(.)(.).(.)./;
    $n = $1;
    $z = $2;
    $v = $3;

    if( ($cur_cond eq "0000" && ( $n ne $v ||$z ne "0" )  || \
        $cur_cond eq "0001" && ($n eq $v && $z eq "0")) && $mask ne "0000" && \
($hint_or_exc eq 0 || $valid_inst ne "00000000")){print $line,"\n";}
            else {print "Ouput pattern check on line $loop_cnt passed!\n";}
        }
        elsif($cond_base eq "AL"){
            print $line,"\n"if($hint_or_exc eq 1);
        }else {
            print "Uninitialized \$cond_base variable!\n";
        }

    }
}
