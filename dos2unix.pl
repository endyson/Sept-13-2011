#!/usr/bin/perl -w
############################################################################
#Author:        Xiao,Chang
#Date:          8/22/2011
#Version:       0.0
#Describtion:   Recursively implement dos2unix command to every ASCII files
#under current directory.
############################################################################
use strict;

sub recur_op {
    chdir $_[0];
    my $cur_dir = `pwd`;
    chomp $cur_dir;

    my $files  =   `dir`;
    my @f_list =   split '\s', $files;

    foreach (@f_list){
        if ( -d ){
            print $cur_dir,"/",$_ , " is a directory!\n";
            recur_op($_);
        }
        elsif( -T ){
            print $cur_dir,"/",$_, " is a ASCII file!\t";
            print  `dos2unix $_`;
        }
    }
    chdir "../";
}
foreach(@ARGV) {
    recur_op($_);
}
