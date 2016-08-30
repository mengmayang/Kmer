#!/usr/bin/perl
my $meta_tax=$ARGV[0];
my $meta_pre=$ARGV[1];


my $usage=<<END;
Usage:
    perl kraken_analyse.pl metadata.tax metadata.label
END

if(scalar(@ARGV)!=2){
    print "$usage\n";
}else{
    my @acc=(0,0,0,0,0,0,0);#(2)compute the accuracy in defferent taxonomy level

#(2)
    open(MTAX,$meta_tax)||die("read error!\n");
    open(MPRE,$meta_pre)||die("read error!\n");
    my @meta_tax_lines=<MTAX>;chomp @meta_tax_lines;
    my $nt=scalar(@meta_tax_lines);
    my $i=0;
    while (my $pre_line=<MPRE>){
        chomp $pre_line;
        $i++;
        #print "$i\n";
        if($pre_line=~/^\>gi\|[0-9]+\|ref\|([0-9]+)\|\t(.*)/){
            for(my $j=0;$j<$nt;$j++){
                my @T=split(/\t/,$meta_tax_lines[$j]);
                my $nT=scalar(@T);
                my $index=$1;
                my $info=$2;
                if($T[0] eq $index){
                    for(my $p=2;$p<$nT;$p++){
                        if($info=~/;$T[$p];/){
                            $acc[$p-2]++;
                        }       
                    }
                    last;
                }
            }
        }
    }
    
    close(MTAX);
    close(MPRE);
    my $acc_line="Input:\ntrue taxonomy\tpredicted taxonomy by kraken\n$meta_tax\t$meta_pre\nRight number in different level:\nKingdom\tphylum\tclass\torder\tfamily\tgenus\tspecies\n".$acc[0]."\t".$acc[1]."\t".$acc[2]."\t".$acc[3]."\t".$acc[4]."\t".$acc[5]."\t".$acc[6]."\n";
    my $accuracy="kraken.accuracy";
    open(ACC,">$accuracy")||die("write error!\n");
    print ACC $acc_line;
    close(ACC);

}









