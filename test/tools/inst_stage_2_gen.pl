#!/usr/bin/perl -w
###########################################################################################
#   Author:         Xiao,Chang
#   Date:           8/15/2011
#   Version:        0.0
#   File:           inst_gen.pl
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
$pattern_1[0] = 0xf1400000; #ADC(imm)
$pattern_1[1] = 0xf1000000; #ADD(imm)
$pattern_1[2] = 0xf10d0000; #ADD(SP plus imm)

my @pattern_2 =(
0xf2000000, #ADD(imm) T4
0xf20d0000, #ADD(SP plus imm) T4
0xf2af0000, #ADR T2
0xf20f0000, #ADR T3

);
my @pattern_3 = (
0xeb400000, #ADC(reg) T2
0xeb000000, #ADD(reg) T3
0xeb0d0000, #ADD(SP plus reg) T3

);
my @pattern_4 = (
0x4140, #ADC(reg) T1

);
my @pattern_5 = (
0x1c00, #ADD(imm) T1

);
my @pattern_6 = (
0x3000, #ADD(imm) T2
0xa800, #ADD(SP plus imm) T1
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
0x4468, #ADD(SP plus reg) T1
0x4485, #ADD(SP plus reg) T2
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


#        printf( "\$p_i    =%b\t\$i      =%b\n",$p_i,$i);
#        printf( "\$p_Rn   =%b\t\$rn     =%b\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%b\t\$imm3   =%b\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%b\t\$rd     =%b\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%b\t\$imm8   =%b\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_i | $p_Rn | $p_imm3 | $p_Rd | $p_imm8;

        printf( "i=%d\n",$i);                      
        printf( "rn=%d\n",$rn);
        printf( "imm3=%d\n",$imm3);
        printf( "rd=%d\n",$rd);         
        printf( "imm8=%d\n",$imm8);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_i | $p_Rn | $p_imm3 | $p_Rd | $p_imm8;

        printf( "i=%d\n",$i);                      
        printf( "rn=%d\n",$rn);
        printf( "imm3=%d\n",$imm3);
        printf( "rd=%d\n",$rd);         
        printf( "imm8=%d\n",$imm8);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_s_type | $p_Rm | $p_Rn | $p_imm3 | $p_Rd | $p_imm2;

        printf( "s_type=%d\n",$s_type);                      
        printf( "rn=%d\n",$rn);
        printf( "imm3=%d\n",$imm3);
        printf( "rd=%d\n",$rd);         
        printf( "imm2=%d\n",$imm2);
        printf( "rm=%d\n",$rm);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_Rm | $p_Rdn;

        printf( "rdn=%d\n",$rdn);
        printf( "rm=%d\n",$rm);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_Rn | $p_imm3 | $p_Rd;

        printf( "rn=%d\n",$rn);
        printf( "imm3=%d\n",$imm3);
        printf( "rd=%d\n",$rd);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_Rdn | $p_imm8;

        printf( "rdn=%d\n",$rdn);
        printf( "imm8=%d\n",$imm8);

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


#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_imm7;

        printf( "imm7=%d\n",$imm7);

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

#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_Rm | $p_Rn | $p_Rd;

        printf( "rm=%d\n",$rm);
        printf( "rn=%d\n",$rn);
        printf( "rd=%d\n",$rd);

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
    $rdm = 0b1;
    $dm = 0b0;

    $loop_cnt = 0;
    while($loop_cnt < (1<<3)){
        $p_Rdm = $rdm;
        $p_DM = $dm<<7;

#        printf( "\$p_i    =%d\t\$i      =%d\n",$p_i,$i);
#        printf( "\$p_Rn   =%d\t\$rn     =%d\n",$p_Rn,$rn);
#        printf( "\$p_imm3 =%d\t\$imm3   =%d\n",$p_imm3,$imm3);
#        printf( "\$p_Rd   =%d\t\$rd     =%d\n", $p_Rd,$rd);
#        printf( "\$p_imm8 =%d\t\$imm8   =%d\n",$p_imm8,$imm8);
#        print "*******************************\n";

        $inst[$pc++] = $_ | $p_Rdm | $p_DM;

        printf( "rdm=%d\n",$rdm);
        printf( "dm=%d\n",$dm);

        $loop_cnt++;

        $rdm   = $rdm < (1<<3) -1  ? $rdm+1 : 0x00000000;
        $dm   = $loop_cnt%2  ? 0b0 : 0b1;

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
foreach (@inst){
my $base = BASE;

    my $len = 1;
    while( ($_/$base)>=1 ){
        $base *=16;
        $len++;
    }
    if($len > 4){
    
    printf( "@%x ",$addr++);
#    $addr++;
    printf("%x\n", $_/(1<<16));
    printf("@%x ",$addr++);
#    $addr++;
    printf("%x\n",$_%(1<<16));
    next;
    }
 
    printf( "@%x ",$addr++);
#    flprint($addr,BASE, ADDR_LEN," ");
#    $addr++;
#    flprint($_,BASE,INST_LEN,"\n");
    printf("%x\n",$_);
}
