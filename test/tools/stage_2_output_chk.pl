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

if(defined $ARGV[0]){
open STAGE_2_OUTPUT_SIM, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
}else{
print "Stage 2 output simulation log file missing!\n";
exit;
}
if(defined $ARGV[1]){
    open STAGE_2_OUTPUT_EMU, $ARGV[1] or die "File $ARGV[1] can not be opened!\n";
}else{
print "Stage 2 output emulation log file missing!\n";
exit;
}

my $loop_cnt_sim = 0;
my $loop_cnt_emu = 0;

my %sim_hash;
my %emu_hash;

foreach $sim_line (<STAGE_2_OUTPUT_SIM>){
    $loop_cnt_sim++;
    $loop_cnt_emu++;
    %emu_hash = ();
    %sim_hash = ();

    chomp $sim_line;
    $emu_line = <STAGE_2_OUTPUT_EMU>;
    chomp $emu_line;

    if(not defined $emu_line){
        printf STDERR ("\$emu_line found uninitialized!\n");
        exit;
    } 
    @sim_signals = split '\s', $sim_line;
    foreach(@sim_signals){
        @pair = split "=";
        $sim_hash{$pair[0]} = $pair[1];
    }

    @emu_signals = split '\s', $emu_line;
    foreach(@emu_signals){
        @pair = split "=";
        $emu_hash{$pair[0]}=$pair[1];
    }

    if($emu_hash{"shift_or_not"} eq "1"){
        $emu_line = <STAGE_2_OUTPUT_EMU>;
        @emu_signals = split '\s', $emu_line;
        foreach(@emu_signals){
            @pair = split "=";
            $emu_hash{$pair[0]}=$pair[1];
        }
        $loop_cnt_emu++;
    }
    ################Rn address mismatch detection################
    #Only if emu Rn address is X that mismatch is allowed
    #Otherwise, an mismatch error occur!
    #############################################################
    if($sim_hash{"Rn_addr"} != $emu_hash{"Rn_addr"} && $emu_hash{"Rn_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "rn_sim=",$sim_hash{"Rn_addr"},"\t","rn_emu=",$emu_hash{"Rn_addr"},"\n";
        $err_num++;
    }
    ################Rd address mismatch detection################
    #Only if emu Rd address is X that mismatch is allowed
    #Otherwise, an mismatch error occur!
    #############################################################
    elsif($sim_hash{"Rd_addr"} ne $emu_hash{"Rd_addr"} && $emu_hash{"Rd_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "rd_sim=",$sim_hash{"Rd_addr"},"\t","rd_emu=",$emu_hash{"Rd_addr"},"\n";
        $err_num++;
    }
    ################Rm address mismatch detection################
    #Only if emu Rm address is X that mismatch is allowed
    #Otherwise, an mismatch error occur!
    #############################################################
    elsif($sim_hash{"Rm_addr"} ne $emu_hash{"Rm_addr"} && $emu_hash{"Rm_addr"} ne "X"){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print"rm_sim=",$sim_hash{"Rm_addr"},"\t","rm_emu=",$emu_hash{"Rm_addr"},"\n";

        $err_num++;
    }
    ################shift_or_not   imm_or_reg   thumb_or_not   mismatch detection################
    #shift_or_not, imm_or_reg & thumb_or_not from emu & sim should always equal
    #Otherwise, an mismatch error occur!
    #############################################################################################
    elsif($sim_hash{"shift_or_not"} ne $emu_hash{"shift_or_not"} || $emu_hash{"imm_or_reg"} ne $sim_hash{"imm_or_reg"} || $sim_hash{"thumb_or_not"} ne $emu_hash{"thumb_or_not"}){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "shift_or_not_sim=",$sim_hash{"shift_or_not"},"\t","shift_or_not_emu=",$emu_hash{"shift_or_not"},"\t","imm_or_reg_sim=",$sim_hash{"imm_or_reg"},"\t","imm_or_reg_emu=",$emu_hash{"imm_or_reg"},"\t","thumb_or_not_sim=",$sim_hash{"thumb_or_not"},"\t","thumb_or_not_emu=",$emu_hash{"thumb_or_not"},"\n";
        $err_num++;
    }
    ################Operand 2 mismatch detection################
    #When imm_or_reg equals to 1, which means the second operand
    #of ALU is the immediate num imm32,
    #the operand 2 from sim should equal to the imm32 from emu
    #Otherwise, a mismatch error occur!
    #############################################################
    elsif($sim_hash{"imm_or_reg"} == 1  && $emu_hash{"imm_or_reg"} == 1 && $sim_hash{"op2"} !=  $emu_hash{"imm32"}){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "imm_or_reg_sim=",$sim_hash{"imm_or_reg"},"\t","imm_or_reg_emu=",$emu_hash{"imm_or_reg"},"\t","op2_sim=",$sim_hash{"op2"},"\t","imm32_emu=",$emu_hash{"imm32"},"\n";
        $err_num++;
    }
    ################shift_or_not   imm_or_reg   thumb_or_not   mismatch detection################
    #A mismatch error occur, WHEN imm_or_reg  or  thumb_or_not from sim equals to 1
    #WHILE shift_or_not from sim equals to 1.
    #############################################################################################
    elsif($sim_hash{"shift_or_not"} == 1 && ($sim_hash{"imm_or_reg"} == 1 || $sim_hash{"thumb_or_not"}  == 1)){
        if($err_num<MAX_ERR){
            printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
            printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
        }
        print("*************************************\n");
        print("FAILED:$sim_line line:$loop_cnt_sim\n");
        print("EMU:$emu_line line:$loop_cnt_emu\n");
        print "shift_or_not_sim=",$sim_hash{"shift_or_not"},"\t","shift_or_not_emu=",$emu_hash{"shift_or_not"},"\t","imm_or_reg_sim=",$sim_hash{"imm_or_reg"},"\t","imm_or_reg_emu=",$emu_hash{"imm_or_reg"},"\t","thumb_or_not_sim=",$sim_hash{"thumb_or_not"},"\t","thumb_or_not_emu=",$emu_hash{"thumb_or_not"},"\n";
        $err_num++;
    }
    else{
        print "$loop_cnt_sim Check Passed!\n";
    }
}
