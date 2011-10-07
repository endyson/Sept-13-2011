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

my $sim_line;
my $emu_line;

open STAGE_2_OUTPUT_SIM, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";
open STAGE_2_OUTPUT_EMU, $ARGV[1] or die "File $ARGV[1] can not be opened!\n";

my $loop_cnt_sim = 0;
my $loop_cnt_emu = 0;

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
    #    $sim_line =~ /Rn_A=\[([0-9x\s]{1,2})\]\sRm_A=\[([0-9x\s]{1,2})\]\sRd_A=\[([0-9x\s]{1,2})\]\sRn_D=\[([0-9x\s]{1,})\]\sRm_D=\[([0-9x\s]{1,})\]\sRd_D=\[([0-9x\s]{1,})\]\simm_or_reg=\[(.)\]\sshift_or_not=\[(.)\]\sthumb_or_not=\[(.)\]\sop1=\[([0-9x\s]{1,})\]\sop2=\[([0-9x\s]{1,})\]/;

    $sim_line =~ /Rn_A=(.)\sRm_A=(.)\sRd_A=(.)\sRn_D=(........)\sRm_D=(........)\sRd_D=(........)\simm_or_reg=(.)\sshift_or_not=(.)\sthumb_or_not=(.)\sop1=(........)\sop2=(........)/;
my        $rn_addr_sim = $1;
my        $rm_addr_sim = $2;
my        $rd_addr_sim = $3;
my        $rn_data_sim = $4;
my        $rm_data_sim = $5;
my        $rd_data_sim = $6;
my        $imm_or_reg_sim = $7;
my        $shift_or_not_sim = $8;
my        $thumb_or_not_sim = $9;
my        $op1_sim = $10;
my        $op2_sim = $11;
        if (not defined $rn_addr_sim){      
        printf STDERR ("\$rn_addr_sim found uninitilized at line $loop_cnt_sim\n");
        exit;
    }

        $emu_line =~ /emu:rn=\[(.)\]\srm=\[(.)\]\srd=\[(.)\]\sshift_or_not=\[(.)\]\sthumb_or_not=\[(.)\]\simm_or_reg=\[(.)\]\simm32=\[(........)\]/;
my      $rn_addr_emu    = $1;
my      $rm_addr_emu    = $2;
my      $rd_addr_emu    = $3;
my      $shift_or_not_emu   = $4;
my      $thumb_or_not_emu   = $5;
my      $imm_or_reg_emu     = $6;
my      $imm32_emu      = $7;

print "shift_or_not_emu = $shift_or_not_emu","\n";

        if($shift_or_not_emu eq "1"){
           $emu_line = <STAGE_2_OUTPUT_EMU>;
           $emu_line =~ /emu:s_type=(..)\soffset=(.....)/;
           my $s_type_emu = $1;
           my $s_offset_emu = $2;
           if(not defined $s_type_emu){
           printf STDERR("Uninitialized s_type found at line: $loop_cnt_emu!\n");
           exit;
           }
           $loop_cnt_emu++;

        }
if(not defined $rn_addr_emu){
        printf STDERR ("\$rn_addr_emu found not initialized at line $loop_cnt_emu\n");
    }
if($rn_addr_sim ne $rn_addr_emu && $rn_addr_emu ne "X"){
printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
print("*************************************\n");
print("FAILED:$sim_line line:$loop_cnt_sim\n");
print("EMU:$emu_line line:$loop_cnt_emu\n");
print("rn_sim=$rn_addr_sim,rn_emu=$rn_addr_emu\n");

}
elsif($rd_addr_sim ne $rd_addr_emu && $rd_addr_emu ne "X"){
printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
print("************************************\n");
print("FAILED:$sim_line line:$loop_cnt_sim\n");
print("EMU:$emu_line line:$loop_cnt_emu\n");
print("rd_sim=$rd_addr_sim,rd_emu=$rd_addr_emu\n");
}
elsif($rm_addr_sim ne $rm_addr_emu && $rm_addr_emu ne "X"){
printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
print("*************************************\n");
print("FAILED:$sim_line line:$loop_cnt_sim\n");
print("EMU:$emu_line line:$loop_cnt_emu\n");
print("rm_sim=$rm_addr_sim,rm_emu=$rm_addr_emu\n");

}
elsif($shift_or_not_sim ne $shift_or_not_emu || $imm_or_reg_emu ne $imm_or_reg_sim || $thumb_or_not_sim ne $thumb_or_not_emu){
printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
print("*************************************\n");
print("FAILED:$sim_line line:$loop_cnt_sim\n");
print("EMU:$emu_line line:$loop_cnt_emu\n");
print("shift_or_not_sim=$shift_or_not_sim,shift_or_not_emu=$shift_or_not_emu,imm_or_reg_sim=$imm_or_reg_sim,imm_or_reg_emu=$imm_or_reg_emu,thumb_or_not_sim=$thumb_or_not_sim,thumb_or_not_emu=$thumb_or_not_emu\n");
}
elsif($imm_or_reg_sim eq "1" && $imm_or_reg_emu eq "1" && $op2_sim ne $imm32_emu){
printf STDERR ("CHECK FAILED:$sim_line line:$loop_cnt_sim\n");
printf STDERR ("EMU:$emu_line line:$loop_cnt_emu\n");
print("*************************************\n");
print("FAILED:$sim_line line:$loop_cnt_sim\n");
print("EMU:$emu_line line:$loop_cnt_emu\n");
print("imm_or_reg_sim=$imm_or_reg_sim,imm_or_reg_emu=$imm_or_reg_emu,op2_sim=$op2_sim,imm32_emu=$imm32_emu\n");
}
else{
print "$loop_cnt_sim Check Passed!\n";
}
 }
