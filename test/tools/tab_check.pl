#!/usr/bin/perl -w

use strict;
my $it_status;
my $apsr;

my $next_inst_hw;
my $cur_inst;
my $hint_or_exc;
my $inst_valid;
my $valid_inst;
my $cur_cond;
my $cond_base;
my $line;

my $n;
my $z;
my $v;

open FD, $ARGV[0] or die "File $ARGV[0] can not be opened!\n";

foreach $line (<FD>){
    chomp $line;
    if ( $line =~ /IT Status/) {
        $line =~ /IT Status = \[(........)\]\sAPSR = \[(.....)\]/;
        $it_status = $1;
        $apsr      = $2;
    }

    if ($line =~ /Condition is/) {
        $line =~ /Condition is (..)/;
        $cond_base = $1;
    }

    if ($line =~/next_inst_hw/){
        $line =~ /next_inst_hw = \[(....)\]\scur_inst = \[(........)\]\shint_or_exc = \[(.)\]\sinst_valid = (.)\svalid_inst = \[(........)\]\scur_cond = \[(....)\]/;
        $next_inst_hw = $1;
        if(not defined $next_inst_hw) {print "Initialization error. Match Failed!\n";exit}
        $cur_inst = $2;
        if(not defined $cur_inst) {print "Initialization error. Match Failed!\n";exit}
        $hint_or_exc = $3;
        if(not defined $hint_or_exc) {print "Initialization error. Match Failed!\n";exit}
        $inst_valid = $4;
        if(not defined $inst_valid) {print "Initialization error. Match Failed!\n";exit}
        $valid_inst = $5;
        if(not defined $valid_inst) {print "Initialization error. Match Failed!\n";exit}
        $cur_cond = $6;
        if(not defined $cur_cond) {print "Initialization error. Match Failed!\n";exit}
if(not defined $cond_base){
    print "\$cond_base is not defined, Current line is ";
    print $line,"\n";
#    exit;
}     

        if($cond_base eq "EQ"){
            print $line,"\n" if( ($cur_cond eq "0000" && $apsr eq "00000" ||$cur_cond eq "0001" && $apsr =~ /.1.../ ) && ($hint_or_exc eq "0" || $valid_inst ne "00000000")) ;
        }
        elsif($cond_base eq "CS"){
            print $line,"\n"   if( ($cur_cond eq "0000" && $apsr eq "00000" || \
                $cur_cond eq "0001" && $apsr =~ /..1../) && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000"));
}
elsif($cond_base eq "MI"){
    print $line,"\n"       if( ($cur_cond eq "0000" && $apsr eq "00000" || \
        $cur_cond eq "0001" && $apsr =~ /1..../) && \
($hint_or_exc eq 0 || $valid_inst ne "00000000"))
;
        }
        elsif($cond_base eq "VS"){
            print $line,"\n"        if( ($cur_cond eq "0000" && $apsr eq "00000" || \
                $cur_cond eq "0001" && $apsr =~ /...1./) && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000"))
    ;
}
elsif($cond_base eq "HI"){
    print $line,"\n"   if( ($cur_cond eq "0000" && ~($apsr =~ /.01../) || \
        $cur_cond eq "0001" && $apsr =~ /.01../ )&& \
($hint_or_exc eq 0 || $valid_inst ne "00000000"))
       ;
   }
   elsif($cond_base eq "GE"){
       $apsr =~ /(.)..(.)./;
       $n = $1;
       $v = $2;

       print $line,"\n"       if( ($cur_cond eq "0000" && $n ne $z || \
           $cur_cond eq "0001" && $n eq $z ) && \
   ($hint_or_exc eq 0 || $valid_inst ne "00000000"))
;
        }
        elsif($cond_base eq "GT"){
            $apsr =~ /(.)(.).(.)./;
            $n = $1;
            $z = $2;
            $v = $3;

            print $line,"\n"       if( ($cur_cond eq "0000" && ( $n ne $v ||$z ne "0" )  || \
                $cur_cond eq "0001" && ($n eq $v && $z eq "0")) && \
        ($hint_or_exc eq 0 || $valid_inst ne "00000000"))
    ;
}
elsif($cond_base eq "AL"){
    print $line,"\n"if($hint_or_exc eq 1)
    ;
}else {
    print "Uninitialized \$cond_base variable!\n";
}

}
}
