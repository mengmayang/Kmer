#!/usr/bin/perl
my $tax_simu="true.tax";
my $metadata=$ARGV[0];
my $metadata_tax=$ARGV[1];
my $usage=<<END;
Usage:
    perl get_true_metatax.pl metadata.fq metadata.tax(true.tax)
END
if(!$metadata||!$metadata_tax){
    print $usage."\n";
}else{
    open(TAX,$tax_simu)||die("can not open the tax file!\n");
    my @taxs=<TAX>;chomp @taxs;
    close(TAX);
    open(MTAX,">$metadata_tax")||die("can not open the metadata.tax file!\n");
    close(MTAX);
    open(MTAX,">>$metadata_tax")||die("can not open the tax file!\n");
    open(FQ,$metadata)||die("can not open the fq file!\n");
    my $r=0;
    while(my $line=<FQ>){
        $r++;print "$r\n";
        if($line=~/^@>gi\|(.*)\|ref\|([0-9]+)\|.*\|.*\|/){
            foreach(@taxs){
                my @T=split(/\t/,$_);
                if($1 eq $T[0]){
                    my $tax_line=$2."\t".$_."\n";
                    print  MTAX $tax_line;
                }
            }
        }
    }
    close(FQ);
    close(MTAX);

}
