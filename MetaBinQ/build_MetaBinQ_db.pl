#!/usr/bin/perl
my $time1=time();
my $file=$ARGV[0];
my $k=$ARGV[1];
my $dbname=$ARGV[2];

my $doc=<<END;
    Usage:
        ./build_MetaBinQ_db.pl fasta_tax_list k dbname
END
if(scalar(@ARGV)!=3){
    print "$doc\n";

}else{
my $count=0;
open(FILE,$file)||die("!\n");
my $n=0;
while(<FILE>){
    my $time_log=time();
    my $line=$_;
    chomp $line;
    my @T=split(/\t/,$line);
    my $fasta=$T[0];
    my $id=$T[1];
    my $species=$T[8];
    my $genus=$T[7];
    my $family=$T[6];
    my $order=$T[5];
    my $class=$T[4];
    my $phylum=$T[3];
    my $superkingdom=$T[2];

    #$fasta=&replace_space($fasta);
    $species=&replace_space($species);

    $genus=&replace_space($genus);
    $family=&replace_space($family);
    $order=&replace_space($order);
    $class=&replace_space($class);
    $phylum=&replace_space($phylum);
    $superkingdom=&replace_space($superkingdom);

    my $gi_tax=$id."_".$superkingdom."_".$phylum."_".$class."_".$order."_".$family."_".$genus."_".$species;
    my $command="./build_ref_pm.pl $fasta $k \"$gi_tax\" $dbname";
    system("$command");
    $count++;
}
close(FILE);
my $time2=time();
$time=$time2-$time1;
print "Total Time:".$time."\n";
}

sub replace_space{
    my $str=$_[0];
    if($str=~/\s/){
        my @T=split(/\s/,$str);
        $str=$T[0];
        for(my $i=1;$i<scalar(@T);$i++){
            $str=$str."|".$T[$i];
        }
    }
    return $str;
}

