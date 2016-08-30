#!/usr/bin/perl
my $meta_pre=$ARGV[0];


my $usage=<<END;
Usage:
    perl kraken_analyse.pl metadata.label kraken.species kraken.sensitivity
END

if(scalar(@ARGV)!=3){
    print "$usage\n";
}else{
    my @count=(0,0,0,0,0,0,0);#(1)compute the sensitivity in different taxonomy level   
    my @species;#(3)compute the percentage of every species

#(1)(3)

    open(MPRE,$meta_pre)||die("read error!\n");
    my $i=0;
    while(<MPRE>){
        chomp $_;
        $i++;
        if($_=~/^\>gi\|(.*)\|ref\|([0-9]+)\|\t(.*)/){
            my @T=split(/;/,$3);
            my $index=0;
            foreach my $t(@T){
                #if(($t != "root") and ($t != "cellular organisms") and ($t =~/group/) and  ($index < 6)){
                if(($t ne "root") and ($t ne "cellular organisms") and ($t !~ /group/) and ($index < 7)){
                    $count[$index]++;
                    $index++;
                    if($index eq 7){
                        @species=(@species,$t);
                    }
                }
            }
            #species' index=$index-1
            if($index<7){
                @species=(@species,"unsure");
            }
        }
    }
    close(MPRE);

#output
    #my $species_file="kraken.species";
    my $species_file=$ARGV[1];
    open(SPECIES,">$species_file")||die("write error!\n");
    close(SPECIES);
    open(SPECIES,">>$species_file")||die("write error!\n");
    foreach my $s(@species){
        my $line=$s."\n";
        print SPECIES $line;
    }
    close(SPECIES);
    #my $sensitivity="kraken.sensitivity";
    my $sensitivity=$ARGV[2];
    open(SEN,">>$sensitivity")||die("write error!\n");
    my $sensitivity_count=$count[0];
    for(my $i=1;$i<scalar(@count);$i++){
        $sensitivity_count=$sensitivity_count."\t".$count[$i];
    }
    $sensitivity_count=$meta_pre."\t".$sensitivity_count."\n";
    print SEN $sensitivity_count;
    close(SEN);

#(2)


}
