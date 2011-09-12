#!/usr/bin/perl -w
##########################################
#   Author:     Xiao,Chang
#   Date:       8/15/2011
#   Version:    0.0
#   File:       inst_gen.pl
##########################################
$pc=0;
use constant WORD_LEN   =>  4; 
use constant BASE       =>  16;

for($i=0b000_00;$i<=0b111_11;$i++){
    if($i == 0b11101 || $i == 0b11110 || $i == 0b11111){
        $inst[$pc++]=$i<<11;        
        $inst[$pc++]=0x0000;
    }else{
        $inst[$pc++]=$i<<11;
    }
}

sub flprint{
    $digit=$_[0];
    $base=$_[1];
    $flen=$_[2];
    $end=$_[3];
    $len=1;

    while( ($digit/$base)>=1 ){
        $base *=16;
        $len++;
    }
    while($flen - $len){
        print "0"; 
        $len++;
    }
    printf("%x", $digit);
    print $end;
}

$addr=0;
foreach (@inst){
    print "@";
    flprint($addr,BASE,2," ");
    $addr++;
    flprint($_,BASE,WORD_LEN,"\n");
}
