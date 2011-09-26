#!/usr/bin/perl -w
###########################################################################################
#   Author:         Xiao,Chang
#   Date:           9/22/2011
#   Version:        0.0
#   File:           inst_stage_2_gen.pl
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

my @inst;

###################################################################
# P a t t e r n     I n i t i a l i z a t i o n
###################################################################
my @pattern_1;
$pattern_1[0] = 0xf1400000; #ADC(imm) T1
$pattern_1[1] = 0xf1000000; #ADD(imm) T3
$pattern_1[2] = 0xf10d0000; #ADD(SP imm) T3

my @pattern_2 =(
    0xf2000000, #ADD(imm) T4
    0xf20d0000, #ADD(SP plus imm) T4
    0xf2af0000, #ADR T2
    0xf20f0000, #ADR T3

);
my @pattern_3 = (
    0xeb400000, #ADC(reg) T2
    0xeb000000, #ADD(reg) T3
    0xeb0d0000, #ADD(SP reg) T3

);
my @pattern_4 = (
    0x4140, #ADC(reg) T1

);
my @pattern_5 = (
    0x1c00, #ADD(imm) T1

);
my @pattern_6 = (
    0x3000, #ADD(imm) T2
    0xa800, #ADD(SP imm) T1
    0xa000,  #ADR T1
);
my @pattern_7 = (
    0xb000, #ADD(SP plus imm) T2
);
my @pattern_8 = (
    0x1800, #ADD(reg) T1
);
my @pattern_9 = (
    0x4400, #ADD(reg) T2
    0x4468, #ADD(SP reg) T1
    0x4485, #ADD(SP reg) T2
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
my $rdm;
my $rdn;
my $dm;

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

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   1
###################################################################

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
            $imm32 = ($imm12_6_0 | 0b0000_1000_0000)<<(($imm12 & 0b1111_1000_0000)>>7);
            #print "imm12_11_10 != 00, ROR_C\n";
        }

        printf( "emu:rn=[%x]\trm=[X]\trd=[%x]\tshift_or_not=[0]\tthumb_or_not=[1]\timm_or_reg=[1]\t",$rn,$rd);
        printf("imm32=[");
        flprint($imm32, BASE,8,"]");
        printf("imm12=[%x]\tcur_inst=[%x]\n",$imm12,$inst[$pc-1]);

        $loop_cnt++;
        $i    = $loop_cnt%2;
        $rn   = $rn < (1<<4) -1  ? $rn+1 : 0x00000000;
        $rd   = $rd < (1<<4) -1  ? $rd+1 : 0x00000000;
        $imm3   = $imm3 < (1<<3) -1  ? $imm3+1 : 0x00000000;
        $imm8   = $imm8 < (1<<8) -1  ? $imm8+1 : 0x00000000;

    }

}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   2
###################################################################

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

        $inst[$pc++] = $_ | $p_i | $p_Rn | $p_imm3 | $p_Rd | $p_imm8;
        $imm32  = ($i<<11) | ($imm3<<8) | $imm8;
        
        printf( "emu:rn=[%x]\trm=[X]\trd=[%x]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[1]\t",$rn,$rd);
        printf("imm32=[");
        flprint($imm32, BASE,8,"]\n");

        $loop_cnt++;
        $i    = $loop_cnt%2;
        $rn   = $rn < (1<<4) -1  ? $rn+1 : 0x00000000;
        $rd   = $rd < (1<<4) -1  ? $rd+1 : 0x00000000;
        $imm3   = $imm3 < (1<<3) -1  ? $imm3+1 : 0x00000000;
        $imm8   = $imm8 < (1<<8) -1  ? $imm8+1 : 0x00000000;

    }

}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   3
###################################################################
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
my      $offset      = ($imm3<<2) | $imm2;
        printf( "emu:rn=[%x]\trm=[%x]\trd=[%x]\timm32=[xxxxxxxx]\tshift_or_not=[1]\tthumb_or_not=[0]\timm_or_reg=[0]\n",$rn,$rm,$rd);
        printf( "emu:s_type=[%b]\toffset=[%x]\n",$s_type,$offset);

        $loop_cnt++;

        $s_type = $s_type <(1<<2) -1 ? $s_type +1 :0b0;
        $rn   = $rn < (1<<4) -1  ? $rn+1 : 0x00000000;
        $rd   = $rd < (1<<4) -1  ? $rd+1 : 0x00000000;
        $rm   = $rm < (1<<4) -1  ? $rm+1 : 0x00000000;

        $imm3   = $imm3 < (1<<3) -1  ? $imm3+1 : 0x00000000;
        $imm2   = $imm2 < (1<<2) -1  ? $imm2+1 : 0x00000000;

    }

}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   4
###################################################################
foreach (@pattern_4){
    $rdn     = 0b0;
    $rm     = 0b1;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rdn   = $rdn;
        $p_Rm   = $rm<<3;

        $inst[$pc++] = $_ | $p_Rm | $p_Rdn;

        printf( "emu:rn=[%x]\trm=[%x]\trd=[%x]\timm32=[xxxxxxxx]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[0]\n",$rdn,$rm,$rdn);
        
        $loop_cnt++;

        $rdn   = $rdn < (1<<3) -1  ? $rdn+1 : 0x00000000;
        $rm   = $rm < (1<<3) -1  ? $rm+1 : 0x00000000;
    }
}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   5
###################################################################
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

        printf( "emu:rn=[%x]\trm=[X]\trd=[%x]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[1]\t",$rn,$rd);
        printf("imm32=[");
        flprint($imm32, BASE,8,"]\n");
        $loop_cnt++;

        $rn   = $rn < (1<<3) -1  ? $rn+1 : 0x00000000;
        $rd   = $rd < (1<<3) -1  ? $rd+1 : 0x00000000;
        $imm3   = $imm3 < (1<<3) -1  ? $imm3+1 : 0x00000000;
    }

}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   6
###################################################################
foreach (@pattern_6){
    $imm8   = 0b0;
    $rdn     = 0b1;

    $loop_cnt = 0;
    while($loop_cnt < (1<<8)){
        $p_Rdn   = $rdn<<8;
        $p_imm8 = $imm8;

        $inst[$pc++] = $_ | $p_Rdn | $p_imm8;
        $imm32 = $imm8;

        printf( "emu:rn=[%x]\trm=[X]\trd=[%x]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[1]\t",$rdn,$rdn);
        printf("imm32=[");
        flprint($imm32, BASE,8,"]\n");

        $loop_cnt++;

        $rdn   = $rdn < (1<<3) -1  ? $rdn+1 : 0x00000000;
        $imm8   = $imm8 < (1<<8) -1  ? $imm8+1 : 0x00000000;

    }

}


###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   7
###################################################################
foreach (@pattern_7){
    $imm7   = 0b0;

    $loop_cnt = 0;
    while($loop_cnt < (1<<7)){
        $p_imm7 = $imm7;

        $inst[$pc++] = $_ | $p_imm7;
        $imm32 = $imm7<<2;

        printf( "emu:rn=[X]\trm=[X]\trd=[X]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[1]\t");
        printf("imm32=[");
        flprint($imm32, BASE,8,"]\n");

        $loop_cnt++;

        $imm7   = $imm7 < (1<<7) -1  ? $imm7+1 : 0x00000000;

    }

}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   8
###################################################################
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

        printf( "emu:rn=[%x]\trm=[%x]\trd=[%x]\timm32=[X]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[0]\n",$rn,$rm,$rd);

        $loop_cnt++;

        $rm   = $rm < (1<<3) -1  ? $rm+1 : 0x00000000;
        $rn   = $rn < (1<<3) -1  ? $rn+1 : 0x00000000;
        $rd   = $rd < (1<<3) -1  ? $rd+1 : 0x00000000;

    }

}

###################################################################
#T e s t    I n s t r u c t i o n   F o r   P a t t e r n   9
###################################################################
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
        
        printf( "emu:rn=[%x]\trm=[%x]\trd=[%x]\timm32=[X]\tshift_or_not=[0]\tthumb_or_not=[0]\timm_or_reg=[0]\n",$rn,$rdm,$rdm);

        $loop_cnt++;

        $rdm   = $rdm < (1<<3) -1  ? $rdm+1 : 0x00000000;
        $dm   = $loop_cnt%2  ? 0b0 : 0b1;
        $rn     = $rn <(1<<4)-1 ? $rn+1 : 0;
    }
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
