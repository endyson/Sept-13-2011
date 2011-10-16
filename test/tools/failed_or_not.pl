#/usr/bin/perl -w

$err_num = 0;
while(<ARGV[0]>){
    if( !(/Check Passed/) ){
        $err_num++;
    }
}
if ($err_num){ print "Stage Chekc failed!\n";}
else{printf "Stage Check Passed!\n" ;}
