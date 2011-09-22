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
my $line;
my $mask;
my $n;
my $z;
my $v;

open FD, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
my $loop_cnt = 0;
foreach $line (<FD>){
    $loop_cnt++;
    chomp $line;

    $line =~ /next_inst_hw=\[(....)\]\scur_inst=\[(........)\]\shint_or_exc=\[(.)\]\sinst_valid=(.)\svalid_inst=\[(........)\]\scur_cond=\[(....)\]\smask=\[(....)\]\sapsr=\[(.....)\]/;
    $next_inst_hw = $1;
    $cur_inst = $2;
    $hint_or_exc = $3;
    $inst_valid = $4;
    $valid_inst = $5;
    $cur_cond = $6;
    $mask = $7;
    $apsr = $8;

    if($cur_cond eq "0000" || $cur_cond eq "0001"){
        if( ($cur_cond eq "0000" && $apsr eq "00000" ||$cur_cond eq "0001" && $apsr =~ /.1.../ ) && $mask ne "0000" && ($hint_or_exc eq "0" || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:", $line,"\t line: $loop_cnt","\n";
        }
        else{print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "0010" || $cur_cond eq "0011"){
        if( ($cur_cond eq "0000" && $apsr eq "00000" || $cur_cond eq "0001" && $apsr =~ /..1../) && $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "0100" || $cur_cond eq "0101"){
        if( ($cur_cond eq "0000" && $apsr eq "00000" || $cur_cond eq "0001" && $apsr =~ /1..../) && $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "0110" || $cur_cond eq "0111"){
        if( ($cur_cond eq "0000" && $apsr eq "00000" || $cur_cond eq "0001" && $apsr =~ /...1./) && $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "1000" || $cur_cond eq "1001"){
        if( ($cur_cond eq "0000" && ~($apsr =~ /.01../) || $cur_cond eq "0001" && $apsr =~ /.01../ )&& $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "1010" || $cur_cond eq "1011"){
        $apsr =~ /(.)..(.)./;
        $n = $1;
        $v = $2;

        if( ($cur_cond eq "0000" && $n ne $z || $cur_cond eq "0001" && $n eq $z ) && $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "1100" || $cur_cond eq "1101"){
        $apsr =~ /(.)(.).(.)./;
        $n = $1;
        $z = $2;
        $v = $3;

        if( ($cur_cond eq "0000" && ( $n ne $v ||$z ne "0" )  || $cur_cond eq "0001" && ($n eq $v && $z eq "0")) && $mask ne "0000" && ($hint_or_exc eq 0 || $valid_inst ne "00000000")){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }
        else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }
    elsif($cur_cond eq "1110" ||$cur_cond eq "1111"){
        if($hint_or_exc eq 1){
            printf STDERR ("CHECK FAILED: $line line $loop_cnt\n");
            print "FAILED:",$line,"\t line: $loop_cnt","\n";
        }else {print "Ouput pattern check on line $loop_cnt passed!\n";}
    }else {
        printf STDERR ("CHECK FAILED: Unknown Current Condition :$cur_cond\t line: $loop_cnt\n");
        print "FAILED:Unknown Current Condition :$cur_cond","\t line: $loop_cnt","\n";
    }

}
