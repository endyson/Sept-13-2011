#!/usr/bin/perl -w
###########################################################################################
#   Author:         Xiao,Chang
#   Date:           9/22/2011
#   Version:        0.0
#   File:           inst_stage_2_gen.pl
#   Description:    Generate the test instructions and the expected outcome of second stage.
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

my @inst;

###################################################################
# P a t t e r n     I n i t i a l i z a t i o n
###################################################################
my @pattern_1;
$pattern_1[0] = 0xf1400000; #ADC(imm) T1
$pattern_1[1] = 0xf1000000; #ADD(imm) T3
#$pattern_1[2] = 0xf10d0000; #ADD(SP imm) T3

my @inst_name_pattern_1 = (
    "ADC(imm) T1",
    "ADD(imm) T3"
#"ADD(SP imm) T3"
);

my @pattern_2 =(
    0xf2000000, #ADD(imm) T4
#    0xf20d0000, #ADD(SP plus imm) T4
    0xf2af0000 #ADR T2 
#    0xf20f0000, #ADR T3
);

my @inst_name_pattern_2=(
    "ADD(imm) T4",
#"ADD(SP imm) T4",
    "ADR T2"
#"ADR T3"
);

my @pattern_10 = (
    0xf8500800,#LDR(imm) T4
    0xf8100800,#LDRB(imm) T3
#0xf8100e00,#LDRBT
    0xf8300800,#LDRH(imm) T3
    0xf9100800,#LDRSB(imm) T2
    0xf9300800 #LDRSH(imm) T2
);
my @inst_name_pattern_10 = (
    "LDR(imm) T4",
    "LDRB(imm) T3",
    "LDRH(imm) T3",
    "LDRSB(imm) T2",
    "LDRSH(imm) T2"
);

my @pattern_11 = (
    0xe8500000,#LDRD(imm)
    0xe85f0000,#LDRD(literal)
    0xe8500f00,#LDREX
    0xe8d00f4f,#LDREXB
    0xe8d00f5f,#LDREXH
    0xf8300e00,#LDRHT
    0xf9100e00,#LDRSBT
    0xf9300e00,#LDRSHT
    0xf8500e00 #LDRT
);

my @inst_name_pattern_11 = (
    "LDRD(imm)",
    "LDRD(literal)",
    "LDREX",
    "LDREXB",
    "LDREXH",
    "LDRHT",
    "LDRSBT",
    "LDRSHT",
    "LDRT"

);

my @pattern_3 = (
    0xeb400000, #ADC(reg) T2
    0xeb000000 #ADD(reg) T3
#    0xeb0d0000, #ADD(SP reg) T3

);

my @inst_name_pattern_3=(
    "ADR(reg) T2",
    "ADD(reg) T3"
# "ADD(SP reg) T3"
);

my @pattern_12 = (
    0xf8500000,#LDR(reg) T2
    0xf8100000,#LDRB(reg) T2
    0xf8300000,#LDRH(reg) T2
    0xf9100000,#LDRSB(reg) T2
    0xf9300000 #LDRSH(reg) T2
);

my @inst_name_pattern_12 = (
    "LDR(reg) T2",
    "LDRB(reg) T2",
    "LDRH(reg) T2",
    "LDRSB(reg) T2",
    "LDRSH(reg) T2"
);
my @pattern_13 = (
    0xe8900000,#LDM/LDMIA/LDMFD T2
    0xe9100000 #LDMDB/LDMEA
);

my @inst_name_pattern_13 = (
    "LDM/LDMIA/LDMFD",
    "LDMDB/LDMEA"

);

my @pattern_14 = (
    0xf8d00000,#LDR(imm) T3
    0xf85f0000,#LDR(literal) T2
    0xf8900000,#LDRB(imm) T2
    0xf81f0000,#LDRB(literal) T1
    0xf8b00000,#LDRH(imm) T2
    0xf83f0000,#LDRH(literal)
    0xf9900000,#LDRSB(imm) T1
    0xf91f0000,#LDRSB(literal)
    0xf9b00000,#LDRSH(imm) T1
    0xf93f0000 #LDRSH(literal)
);

my @inst_name_pattern_14 = (
    "LDR(imm) T3",
    "LDR(literal) T2",
    "LDRB(imm) T2",
    "LDRB(literal) T1",
    "LDRH(imm) T2",
    "LDRH(literal)",
    "LDRSB(imm) T1",
    "LDRSB(literal)",
    "LDRSH(imm) T1",
    "LDRSH(literal)"

);
my @pattern_4 = (
    0x4140 #ADC(reg) T1

);

my @inst_name_pattern_4=(
    "ADC(reg) T1"
);


my @pattern_9 = (
    0x4400 #ADD(reg) T2
#    0x4468, #ADD(SP reg) T1
#    0x4485, #ADD(SP reg) T2
);
my @inst_name_pattern_9=(
    "ADD(reg) T2"
#"ADD(SP reg) T1",
#"ADD(SP reg) T2"
);


my @pattern_8 = (
    0x1800,#ADD(reg) T1
    0x5800,#LDR(reg) T1
    0x5c00,#LDRB(reg) T1
    0x5a00,#LDRH(reg)
    0x5600,#LDRSB(reg) T1
    0x5e00 #LDRSH(reg) T1
);
my @inst_name_pattern_8=(
    "ADD(reg) T1",
    "LDR(reg) T1",
    "LDRB(reg) T1",
    "LDRH(reg)",
    "LDRSB(reg) T1",
    "LDRSH(reg) T1"
);


my @pattern_5 = (
    0x1c00 #ADD(imm) T1

);

my @inst_name_pattern_5=(
    "ADD(imm) T1"
);

my @pattern_6 = (
    0x3000, #ADD(imm) T2
    0xa800, #ADD(SP imm) T1
    0xa000, #ADR T1
    0x9800, #LDR(imm) T2
    0x4800 #LDR(literal) T1
);

my @inst_name_pattern_6=(
    "ADD(imm) T2",
    "ADD(SP imm) T1",
    "ADR T1",
    "LDR(imm) T2",
    "LDR(literal) T1"

);

my @pattern_7 = (
    0xb000 #ADD(SP imm) T2
);

my @inst_name_pattern_7=(
    "ADD(SP imm)"
);


my @pattern_15 = (
    0xc800 #LDM/LDMIA/LDMFD T1
);

my @inst_name_pattern_15 = (
    "LDM/LDMIA/LDMFD T1"
);
my @pattern_16 = (
    0x6800,#LDR(imm) T1
    0x7800,#LDRB(imm) T1
    0x8800 #LDRH(imm) T1
);

my @inst_name_pattern_16 = (
    "LDR(imm) T1",
    "LDRB(imm) T1",
    "LDRH(imm) T1"

);

#####################
#Pattern generator
#####################
my $rd;
my $rn;
my $rm;
my $imm3;
my $imm2;
my $imm7;
my $imm8;
my $imm32;
my $i;
my $s_type;
my $s_offset;
my $rdm;
my $rdn;
my $dm;
my $imm5;
my $rt;
my $puw;
my $pu;
my $pm;
my $w;
my $reg_list;
my $imm12;
my $rt2;
my $u;
#####################
#Pattern mask
#####################
my $p_i;
my $p_S;
my $p_Rn;
my $p_imm3;
my $p_Rd;
my $p_imm8;
my $p_Rdm;
my $p_Rdn;
my $p_DM;
my $p_s_type;
my $p_imm2;
my $p_imm7;
my $p_Rm;
my $loop_cnt;
my $p_imm5;
my $p_Rt;
my $p_U;
my $p_PUW;
my $p_PU;
my $p_W;
my $p_PM;
my $p_reg_list;
my $p_imm12;
my $p_Rt2;
###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   1
###################################################################
my $index=0; 

foreach (@pattern_1){
    $rd     = 0b0;
    $rn     = 0b1;
    $imm3   = 0b10;
    $imm8   = 0b11;
    $i      = 0b0;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_i    = $i<<26;
        $p_Rn   = $rn<<16;
        $p_imm3 = $imm3<<12;
        $p_Rd   = $rd<<8;
        $p_imm8 = $imm8;

        $inst[$pc++] = $_ | $p_i | $p_Rn | $p_imm3 | $p_Rd | $p_imm8;

        #Thumb Expand Imm 
        my $imm12 = ($i<<11) | ($imm3<<8) | $imm8;

        my $imm12_11_10 = $imm12 & 0b1100_0000_0000;
        my $imm12_9_8   = $imm12 & 0b0011_0000_0000;
        my $imm12_7_0   = $imm12 & 0b0000_1111_1111;

        my $imm12_6_0   = ($imm12 & 0b0000_0111_1111);

        if( $imm12_11_10 == 0){
            if( $imm12_9_8 == 0 ){
                $imm32 = $imm12_7_0;
                #  print "imm12_9_8 == 00\n";
            }
            elsif($imm12_9_8 == 0b0001_0000_0000 ){
                $imm32 = $imm12_7_0 | ($imm12_7_0<<16);
                # print "imm12_9_8 == 01\n";
            }
            elsif($imm12_9_8 == 0b0010_0000_0000 ){
                $imm32 = ($imm12_7_0<<8) | ($imm12_7_0<<24);
                # print "imm12_9_8 == 10\n";
            }
            elsif($imm12_9_8 == 0b0011_0000_0000 ){
                $imm32 = ($imm12_7_0) | ($imm12_7_0<<8) | ($imm12_7_0<<16) | ($imm12_7_0<<24);
                # print "imm12_9_8 == 11\n";
            }
            else{
                #   printf("Error Pattern found in \$imm12_9_8 = %x\n",$imm12_9_8);
            }
        }
        else{
            $imm32 =(($imm12_6_0 | 0b0000_1000_0000)>>($imm12>>7)) | (($imm12_6_0 | 0b0000_1000_0000)<<(32- ($imm12>>7)));
            #print "imm12_11_10 != 00, ROR_C\n";
        }

        printf  "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rd;
        printf  "shift_or_not=0\tthumb_or_not=1\timm_or_reg=1\t";
        printf  "imm32=%d\timm12=%d\tcur_inst=%x\t",$imm32, $imm12,$inst[$pc-1];
        printf  "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf  "pc=%d\t",$pc-1;

        print $inst_name_pattern_1[$index],"\n";

        $loop_cnt++;
        $i    = xbit_cnt($loop_cnt,1);
        $rn   = xbit_cnt($rn,4);
        $rd   = xbit_cnt($rd,4);
        $imm3   = xbit_cnt($imm3,3);
        $imm8   = xbit_cnt($imm8,8);

    }
    $index++;
}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   2
###################################################################
$index=0;

foreach (@pattern_2){
    $rd     = 0b0;
    $rn     = 0b1;
    $imm3   = 0b10;
    $imm8   = 0b11;
    $i      = 0b0;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_i    = $i<<26;
        $p_Rn   = $rn<<16;
        $p_imm3 = $imm3<<12;
        $p_Rd   = $rd<<8;
        $p_imm8 = $imm8;
        if($index == 1){
            $inst[$pc++] = $_ | $p_i | $p_imm3 | $p_Rd | $p_imm8; 
            $rn = 0xf;
        }
        else{$inst[$pc++] = $_ | $p_i | $p_Rn | $p_imm3 | $p_Rd | $p_imm8;}

        $imm32  = ($i<<11) | ($imm3<<8) | $imm8;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rd;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%d\tcur_int=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_2[$index],"\n";

        $loop_cnt++;
        $i    = xbit_cnt($loop_cnt,1);
        $rn   = xbit_cnt($rn,4);
        $rd   = xbit_cnt($rd,4);
        $imm3   = xbit_cnt($imm3,3);
        $imm8   = xbit_cnt($imm8,8);

    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   3
###################################################################
$index = 0;

foreach (@pattern_3){
    $imm3   = 0b0;
    $imm2   = 0b1;
    $s_type = 0b10;
    $rd     = 0b11;
    $rn     = 0b100;
    $rm     = 0b101;

    $loop_cnt = 0;
    while($loop_cnt < (1<<4)){
        $p_s_type    = $i<<4;
        $p_Rn   = $rn<<16;
        $p_imm3 = $imm3<<12;
        $p_Rd   = $rd<<8;
        $p_imm2 = $imm2<<6;
        $p_Rm   = $rm;

        $inst[$pc++] = $_ | $p_s_type | $p_Rm | $p_Rn | $p_imm3 | $p_Rd | $p_imm2;
        $s_offset      = ($imm3<<2) | $imm2;
        printf "ENU:Rn_addr=%x\tRm_addr=%x\tRd_addr=%x\t",$rn,$rm,$rd;
        printf "shift_or_not=1\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=[XXXXXXXX]\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_3[$index],"\n";

        printf "EMU:s_type=%d\ts_offset=%d\n",$s_type,$s_offset;
        $loop_cnt++;

        $s_type = $s_type <(1<<2) -1 ? $s_type +1 :0b0;
        $rn   = xbit_cnt($rn,4);
        $rd   = xbit_cnt($rd,4);
        $rm   = xbit_cnt($rm,4);

        $imm3   = xbit_cnt($imm3,3);
        $imm2   = xbit_cnt($imm2,2);

    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   4
###################################################################
$index=0;
foreach (@pattern_4){
    $rdn     = 0b0;
    $rm     = 0b1;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rdn   = $rdn;
        $p_Rm   = $rm<<3;

        $inst[$pc++] = $_ | $p_Rm | $p_Rdn;

        printf "EMU:Rn_addr=%x\tRm_addr=%x\tRd_addr=%x\t",$rdn,$rm,$rdn;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=[XXXXXXXX]\tcur_inst=%x\t",$inst[$pc-1];
        printf("PUW=X\tRt2_addr=X\treg_list=X\t");
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_4[$index],"\n";

        $loop_cnt++;

        $rdn   = xbit_cnt($rdn,3);
        $rm   = xbit_cnt($rm,3);
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   5
###################################################################
$index=0;
foreach (@pattern_5){
    $imm3   = 0b0;
    $rd     = 0b1;
    $rn     = 0b10;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rn   = $rn<<3;
        $p_imm3 = $imm3<<6;
        $p_Rd   = $rd;

        $inst[$pc++] = $_ | $p_Rn | $p_imm3 | $p_Rd;
        $imm32 = $imm3;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rd;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%d\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf("PUW=X\tRt2_addr=X\treg_list=X\t");
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_5[$index],"\n";

        $loop_cnt++;

        $rn   = xbit_cnt($rn,3);
        $rd   = xbit_cnt($rd,3);
        $imm3   = xbit_cnt($imm3,3);
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   6
###################################################################
$index=0;

foreach (@pattern_6){
    $imm8   = 0b0;
    $rdn     = 0b1;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_Rdn   = $rdn<<8;
        $p_imm8 = $imm8;

        $inst[$pc++] = $_ | $p_Rdn | $p_imm8;
        $imm32 = $imm8;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rdn,$rdn;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%d\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_6[$index],"\n";

        $loop_cnt++;

        $rdn   = xbit_cnt($rdn,3);
        $imm8   = xbit_cnt($imm8,8);

    }
    $index++;
}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   7
###################################################################
$index=0;

foreach (@pattern_7){
    $imm7   = 0b0;

    $loop_cnt = 0;
    while($loop_cnt < (1<<7)){
        $p_imm7 = $imm7;

        $inst[$pc++] = $_ | $p_imm7;
        $imm32 = $imm7<<2;

        printf "EMU:Rn_addr=X\tRm_addr=X\tRd_addr=X\t";
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%d\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_7[$index],"\n";

        $loop_cnt++;

        $imm7   = xbit_cnt($imm7,7);

    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   8
###################################################################
$index=0;

foreach (@pattern_8){
    $rm = 0b0;
    $rn = 0b1;
    $rd = 0b10;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rm = $rm<<6;
        $p_Rn = $rn<<3;
        $p_Rd = $rd;

        $inst[$pc++] = $_ | $p_Rm | $p_Rn | $p_Rd;

        printf "EMU:Rn_addr=%x\tRm_addr=%x\tRd_addr=%x\t",$rn,$rm,$rd;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=X\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_8[$index],"\n";
        $loop_cnt++;

        $rm   = xbit_cnt($rm,3);
        $rn   = xbit_cnt($rn,3);
        $rd   = xbit_cnt($rd,3);

    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   9
###################################################################
$index=0;

foreach (@pattern_9){
    $rdm = 0b10;
    $dm = 0b01;
    $rn = 0b00;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rdm = $rdm;
        $p_DM = $dm<<7;
        $p_Rn  = $rn<<3;

        $inst[$pc++] = $_ | $p_Rdm | $p_Rn| $p_DM;

        printf "EMU:Rn_addr=%x\tRm_addr=%x\tRd_addr=%x\t",$rn,$rdm,$rdm;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=X\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_9[$index],"\n";

        $loop_cnt++;

        $rdm   = xbit_cnt($rdm,3);
        $dm   = xbit_cnt($loop_cnt,1);
        $rn     = xbit_cnt($rn,4);
    }
    $index++;
}
###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   10
###################################################################
$index=0;

foreach (@pattern_10){
    $rn = 0b0;
    $rt = 0b01;
    $puw = 0b10;
    $imm8 = 0b11;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_Rn = $rn<<16;
        $p_Rt = $rt<<12;
        $p_PUW  = $puw<<8;
        $p_imm8 = $imm8;

        $inst[$pc++] = $_ | $p_Rn | $p_Rt| $p_PUW | $p_imm8;

        $imm32 = $imm8;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rt;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%x\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=%x\tRt2_addr=X\treg_list=X\t",$puw;
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_10[$index],"\n";

        $loop_cnt++;

        $rn     = $rn <(1<<4)-1 ? $rn+1 : 0;
        $rt     = $rt <(1<<4)-1 ? $rt+1 : 0;
        $puw     = $puw <(1<<3)-1 ? $puw+1 : 0;
        $imm8     = $imm8 <(1<<8)-1 ? $imm8+1 : 0;
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   11
###################################################################
$index=0;

foreach (@pattern_11){
    $w = 0b0;
    $pu = 0b01;
    $rn = 0b10;
    $rt = 0b11;
    $rt2 = 0b100;
    $imm8 = 0b101;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_Rn = $rn<<16;
        $p_Rt = $rt<<12;
        $p_Rt2 = $rt2<<8;

        $p_PU  = $pu<<23;
        $p_W = $w<<21;
        $p_imm8 = $imm8;

        $inst[$pc++] = $_ | $p_Rn | $p_Rt| $p_Rt2 | $p_PU | $p_W | $p_imm8;
        $puw = ($pu<<1) | $w;

        printf( "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\timm32=%x\tshift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t",$rn,$rt,$imm8);
        printf "cur_inst=%x\t",$inst[$pc-1];
        printf("PUW=%x\tRt2_addr=%x\treg_list=X\t",$puw,$rt2);
        printf "pc = %d\t",$pc-1;
        print $inst_name_pattern_11[$index],"\n";

        $loop_cnt++;

        $rn = xbit_cnt($rn, 4);
        $rt = xbit_cnt($rt, 4);
        $rt2 = xbit_cnt($rt2,4);
        $imm8 = xbit_cnt($imm8,8);
        $pu = xbit_cnt($pu,2);
        $w = xbit_cnt($w, 1);

    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   12
###################################################################
$index=0;

foreach (@pattern_12){
    $imm2 = 0b0;
    $rn = 0b1;
    $rt = 0b10;
    $rm = 0b11;

    $loop_cnt = 0;
    while($loop_cnt < (1<<4)){
        $p_Rn = $rn<<16;
        $p_Rt = $rt<<12;
        $p_Rm = $rm;
        $p_imm2 = $imm2<<4;

        $inst[$pc++] = $_ | $p_Rn | $p_Rt| $p_Rm | $p_imm2;

        printf "EMU:Rn_addr=%x\tRm_addr=%x\tRd_addr=%x\t",$rn,$rm,$rt;
        printf "shift_or_not=1\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=X\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=X\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_12[$index],"\n";
        $s_offset = $imm2;
        printf( "EMU:s_type=0\toffset=%d\n",$s_offset);

        $loop_cnt++;

        $rn = xbit_cnt($rn, 4);
        $rt = xbit_cnt($rt, 4);
        $rm = xbit_cnt($rm,4);
        $imm2 = xbit_cnt($imm2,2);
    }
    $index++;
}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   13
###################################################################
$index=0;

foreach (@pattern_13){
    $w = 0b0;
    $pm = 0b1;
    $rn = 0b10;
    $reg_list = 0b11;

    $loop_cnt = 0;
    while($loop_cnt < (1<<13)){
        $p_Rn = $rn<<16;
        $p_W = $w<<21;
        $p_PM = $pm<<14;
        $p_reg_list = $reg_list;

        $inst[$pc++] = $_ | $p_Rn | $p_PM| $p_W | $p_reg_list;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=X\t",$rn;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=X\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=1\tRt2_addr=X\treg_list=%x\t",(($pm<<1)<<13) | $reg_list;
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_13[$index],"\n";

        $loop_cnt++;

        $rn = xbit_cnt($rn, 4);
        $w = xbit_cnt($w, 1);
        $pm = xbit_cnt($pm,2);
        $reg_list = xbit_cnt($reg_list,13);
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   14
###################################################################
$index=0;

foreach (@pattern_14){
    $u = 0b0;
    $rt = 0b1;
    $rn = 0b10;
    $imm12= 0b11;

    $loop_cnt = 0;
    while($loop_cnt < (1<<12)){
        $p_Rn = $rn<<16;
        $p_U = $u<<23;
        $p_Rt = $rt<<12;
        $p_imm12 = $imm12;

        $inst[$pc++] = $_ | $p_Rn | $p_U| $p_Rt | $p_imm12;
        $imm32 = $imm12; 
        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rt;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%x\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=%d\tRt2_addr=X\treg_list=X\t", ($u<<1)|(1<<2);
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_14[$index],"\n";

        $loop_cnt++;

        $rn = xbit_cnt($rn, 4);
        $u = xbit_cnt($u, 1);
        $rt = xbit_cnt($rt,4);
        $imm12 = xbit_cnt($imm12,12);
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   15
###################################################################
$index=0;

foreach (@pattern_15){
    $rn = 0b0;
    $reg_list= 0b1;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_Rn = $rn<<24;
        $p_reg_list = $reg_list<<16;

        $inst[$pc++] = $_ | $p_Rn | $p_reg_list;

        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=X\t",$rn;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=0\t";
        printf "imm32=X\tcur_inst=%x\t",$inst[$pc-1];
        printf "PUW=%d\tRt2_addr=X\treg_list=%x\t",is_true($reg_list & (1<<$rn)), $reg_list;
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_15[$index],"\n";

        $loop_cnt++;

        $rn = xbit_cnt($rn, 3);
        $reg_list = xbit_cnt($reg_list,8);
    }
    $index++;
}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   16
###################################################################
$index=0;

foreach (@pattern_16){
    $rn = 0b0;
    $rt = 0b1;
    $imm5= 0b10;

    $loop_cnt = 0;
    while($loop_cnt < (1<<5)){
        $p_Rn = $rn<<19;
        $p_Rt = $rt<<16;
        $p_imm5 = $imm5<<22;

        $inst[$pc++] = $_ | $p_Rn | $p_imm5 | $p_Rt;
        $imm32 = $imm5;
        printf "EMU:Rn_addr=%x\tRm_addr=X\tRd_addr=%x\t",$rn,$rt;
        printf "shift_or_not=0\tthumb_or_not=0\timm_or_reg=1\t";
        printf "imm32=%x\tcur_inst=%x\t",$imm32,$inst[$pc-1];
        printf "PUW=6\tRt2_addr=X\treg_list=X\t";
        printf "pc=%d\t",$pc-1;
        print $inst_name_pattern_16[$index],"\n";

        $loop_cnt++;

        $rn = xbit_cnt($rn, 3);
        $rt = xbit_cnt($rt, 3);
        $imm5 = xbit_cnt($imm5,5);
    }
    $index++;
}

sub is_true {
    my $value= $_[0];
    $value > 0 ? 1: 0;
}

sub xbit_cnt {
    my $cur_cnt = $_[0];
    my $bit_len = $_[1];
    $cur_cnt < (1<<$bit_len)-1 ? $cur_cnt+1: 0b0;
}

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
my $num_of_inst=0;

foreach (@inst){
    $num_of_inst++;

    my $base = BASE;
    my $len = 1;
    while( ($_/$base)>=1 ){
        $base *=16;
        $len++;
    }
    if($len > 4){
        printf( "@%x ",$addr++);
        printf("%x\n", $_/(1<<16));
        printf("@%x ",$addr++);
        printf("%x\n",$_%(1<<16));
        next;
    }
    printf( "@%x ",$addr++);
    printf("%x\n",$_);
}
