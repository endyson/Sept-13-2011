#!/usr/bin/perl -w
# File:             pipe_stage_2_chk.pl
# Author:           Xiao,Chang
# Email:            chngxiao@gmail.com
# Original Date:    9/20/2011
# Description:      Test tool used to verify that the output signal pattern of stage Two in the pipe line are correct.
# Copyright:        All right reserved by Xiao,Chang.
# Notice: Please do me a favor to NOT remove the content above. 
#         If you have any modification and description on this, please add it anywhere you like!.
#         This is all I need when I do this.
#         Thank you very much for concernning and Welcome to join into my work!
#         Please Feel free to email me by the email address above.

use strict;
use constant MAX_ERR => 10;
my $sim_line;
my $emu_line;
my @emu_signals;
my @sim_signals;
my @pair;

my $err_num = 0;

open STAGE_2_OUTPUT_SIM, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
open STAGE_2_OUTPUT_EMU, $ARGV[1] or die "File $ARGV[1] can not be opened!\n";

my $loop_cnt_sim = 0;
my $loop_cnt_emu = 0;

my %sim_hash;
my %emu_hash;

foreach $sim_line (<STAGE_2_OUTPUT_SIM>){
    $loop_cnt_sim++;
    $loop_cnt_emu++;

    chomp $sim_line;
    $emu_line = <STAGE_2_OUTPUT_EMU>;
    chomp $emu_line;

    if(not defined $emu_line){
        printf STDERR ("\$emu_line found uninitialized!\n");
        exit;
    } 
    @sim_signals = split "\s", $sim_line;
    foreach(@sim_signals){
        @pair = split "=";
        $sim_hash{$pair[0]} = $pair[1];
    }


    @emu_signals = split "\s", $emu_line;
    foreach(@emu_signals){
        @pair = split "=";
        $emu_hash{$pair[0]}=$pair[1];
    }
    if($emu_hash{"shift_or_not"} eq "1"){
        $emu_line = <STAGE_2_OUTPUT_EMU>;
        @emu_signals = split "\s", $emu_line;
        foreach(@emu_signals){
            @pair = split "=";
            $emu_hash{$pair[0]}=$pair[1];
        }
        $loop_cnt_emu++;
    }

#    if(not defined $rn_addr_emu){
#        printf STDERR ("\$rn_addr_emu found not initialized at line $loop_cnt_emu\n");
#    }

    if($sim_hash{"rn_addr"} ne $emu_hash{"rn_addr"} && $emu_hash{"rn_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "rn_sim=",$sim_hash{"rn_addr"},"\t","rn_emu=",$emu_hash{"rn_addr"},"\n";
        $err_num++;
    }
    elsif($sim_hash{"rd_addr"} ne $emu_hash{"rd_addr"} && $emu_hash{"rd_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "rd_sim=",$sim_hash{"rd_addr"},"\t","rd_emu=",$emu_hash{"rd_addr"},"\n";
        $err_num++;
    }
    elsif($sim_hash{"rm_addr"} ne $emu_hash{"rm_addr"} && $emu_hash{"rm_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }

        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print"rm_sim=",$sim_hash{"rm_addr"},"\t","rm_emu=",$emu_hash{"rm_addr"},"\n";

        $err_num++;
    }
    elsif($sim_hash{"shift_or_not"} ne $emu_hash{"shift_or_not"} || $emu_hash{"imm_or_reg"} ne $sim_hash{"imm_or_reg"} || $sim_hash{"thumb_or_not"} ne $emu_hash{"thumb_or_not"}){
        if($err_num<MAX_ERR){printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");}
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "shift_or_not_sim=",$sim_hash{"shift_or_not"},"\t","shift_or_not_emu=",$emu_hash{"shift_or_not"},"\t","imm_or_reg_sim=",$sim_hash{"imm_or_reg"},"\t","imm_or_reg_emu=",$emu_hash{"imm_or_reg"},"\t","thumb_or_not_sim=",$sim_hash{"thumb_or_not"},"\t","thumb_or_not_emu=",$emu_hash{"thumb_or_not"},"\n";
        $err_num++;
    }
    elsif($sim_hash{"imm_or_reg"} == 1  && $emu_hash{"imm_or_reg"} == 1 && $sim_hash{"op2"} !=  $emu_hash{"imm32"}){
        if($err_num<MAX_ERR){printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");}
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "imm_or_reg_sim=",$sim_hash{"imm_or_reg"},"\t","imm_or_reg_emu=",$emu_hash{"imm_or_reg"},"\t","op2_sim=",$sim_hash{"op2"},"\t","imm32_emu=",$emu_hash{"imm32"},"\n";
        $err_num++;
    }
    else{
        print "$loop_cnt_sim Check Passed!\n";
    }
}
