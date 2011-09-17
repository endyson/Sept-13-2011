#!/usr/bin/perl -w
###########################################################################################
#   Author:         Xiao,Chang
#   Date:           8/15/2011
#   Version:        0.0
#   File:           inst_it_gen.pl
#   Description:    Test the xPSR register funcition including:
#                   a>  IT mask pattern left shift increment. 
#                   b>  16 to 32 and 32 to 16 bits instruction switch within IT block.
#                   c>  Instruction execution inside and outside IT block.
#                   d>  Branch instrution conditional pass.
#   
##########################################################################################
use strict;

# Use hex format 
use constant BASE       =>  16;

# 1 bit MSB indicating instruction valid and 16 bits instruction length
use constant INST_LEN   =>  4;

# Instruction Memory depth is 1<<(3*4)
use constant ADDR_LEN   =>  4;

my $pc=0;

#ADC(imm)
my $inst_adc_imm    = 0hf1400000;
my $inst_adc_reg_t1 = 0h4140;
my $inst_adc_reg_t2 = 0heb400000;
my $inst_add_imm_t1 = 0h1c00;
my $inst_add_imm_t2 = 0h3000;
my $inst_add_imm_t3 = 0hf1000000;
my $inst_add_imm_t4 = 0hf2000000;
my $inst_add_reg_t1 = 0h1800;
my $inst_add_reg_t2 = 0h4400;
my $inst_add_reg_t3 = 0heb000000;
my $inst_add_sp_imm_t1 = 0ha800;
my $inst_add_sp_imm_t2 = 0hb000;
my $inst_add_sp_imm_t3 = 0hf10d0000;
my $inst_add_sp_imm_t4 = 0hf20d0000;
my $inst_add_sp_reg_t1 = 0h4468;
my $inst_add_sp_reg_t2 = 0h4485;
my $inst_add_sp_reg_t3 = 0heb0d0000;
my $inst_adr_t1 = 0ha000;
my $inst_adr_t2 = 0hf2af0000;
my $inst_adr_t3 = 0hf20f0000;


sub flprint{
my    $digit=$_[0];
my    $base=$_[1];
my    $flen=$_[2];
my    $end=$_[3];
my    $len=1;

    while( ($digit/$base)>=1 ){
        $base *=16;
        $len++;
    }
    while( ($flen - $len) > 0){
        print "0"; 
        $len++;
    }
    printf("%x", $digit);
    print $end;
}

my $addr=0;
foreach (@inst){
    print "@";
    flprint($addr,BASE, ADDR_LEN," ");
    $addr++;
    flprint($_,BASE,INST_LEN,"\n");
}
