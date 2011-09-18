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

my $it_t           = 0b1011_1111_0000_0000;
my $branch_16_t    = 0b1101_0000_0000_0000;
my $branch_32_t    = 0b1111_0000_0000_0000;
my @inst;
my $i;

#The APSR register value should be 5'b00000 for the following instructions
#Generate 5 16i/32 bits "empty" instruction within IT block
for($i=0x000;$i<0x100;$i++){
    #IT instruction
    $inst[$pc++]=$it_t|$i;

    #Instructions Inside IT block, two 16 bits and two 32 bits instructions.
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0xe800;
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0xf800;
    $inst[$pc++]=0x0000;

    #Instructions Outside IT block, two 16 bits instructions
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0x0000;
}

#pc = 9*256;

#Branch Instruction
for($i=0x00;$i<0x10;$i++){
    $inst[$pc++]=$branch_16_t | ($i<<8);
    $inst[$pc++]=$branch_32_t | ($i<<6);
    $inst[$pc++]=0x0000;
}

#pc = 3*16 + 9*256;

#The APSR register value should be 5'b11111 for the following instructions
#Generate 5 16 bits "empty" instruction within IT block
for($i=0x000;$i<0x100;$i++){
    $inst[$pc++]=$it_t | $i;

    #Inside the IT block, two 16 bits and two 32 bits instructions
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0xe800;
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0x0000;
    $inst[$pc++]=0xf800;
    $inst[$pc++]=0x0000;

    #Outside the IT block, one 32 bits instruction
    $inst[$pc++]=0xf000;
    $inst[$pc++]=0x0000;

}

#pc = 9*256 + 3*16 + 9*256;

#Branch Instruction
for($i=0x00;$i<0x10;$i++){
    $inst[$pc++]=$branch_16_t | ($i<<8);
    $inst[$pc++]=$branch_32_t | ($i<<6);
    $inst[$pc++]=0xe800;
    $inst[$pc++]=0x0000;
}

#pc = 4*16 + 9*256 + 3*16 + 9*256;
#end addr
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
    print "@",$addr," ";
    $addr++;
    printf("%x\n",$_);

#    flprint($addr,BASE, ADDR_LEN," ");
#    flprint($_,BASE,INST_LEN,"\n");
}
