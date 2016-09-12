#!/usr/bin/perl
my $usage=<<END;
    USAGE:
        perl build_ref_pm.pl NCname k gi_tax dbname
END
if(@ARGV!=4){
  print STDERR "$usage\n";
}elsif($ARGV[1]<4||$ARGV[1]>8){
  print STDERR "Please select k between 4 and 8!\n";
}else{
    my $time1=time();
    my $NC_name=$ARGV[0];
    my $k=$ARGV[1];
    my $gi_tax=$ARGV[2];
    my $dbname=$ARGV[3];
    print "";
    #Read the genome file 
    open(NC,$NC_name)||die("can not open the NC_name\n");
    <NC>;
    my $sequence=<NC>;
    $sequence=&char2num($sequence);
    my @sequence_lines=<NC>;
    chomp $sequence;
    close(NC);

    foreach $line(@sequence_lines){
      chomp $line;
      $line=&char2num($line);
      $sequence=$sequence.$line;
    }
#########################################
    $vector_content="$NC_name-$gi_tax:";
    compuvector($sequence,$vector_content,$k,$dbname);
    $seqt=rev($sequence);
    compuvector($seqt,$vector_content,$k,$dbname);
    my $time2=time();
    my $time=$time2-$time1;
    print "running time is:$time"."s\n";
}
sub compuvector{
    my $sequence=$_[0];
    my $len=length($sequence);
    my $vector_content=$_[1].$len;
    my $k=$_[2];
    my $dbname=$_[3];
    my $col_num=4**$k;
    my @kmer_num=(0)x $col_num;

    for(my $i=0;$i<$len-$k+1;$i++){
        my $c=substr($sequence,$i,$k);
        my $index = 0;
        for(my $p=0;$p<length($c);$p++){
            $index=$index*4+substr($c,$p,1);
        }
        $kmer_num[$index]++;
    }
    my @kmer_freq;
    my $sqfreq2sum=0;
    for(my $i=0;$i<$col_num;$i++){
        $kmer_freq[$i]=$kmer_num[$i]/($len-$k+1);#TFi
        $sqfreq2sum=$sqfreq2sum+$kmer_freq[$i]**2;
    }
    $sqfreq2sum=sqrt($sqfreq2sum);
    for(my $i=0;$i<$col_num;$i++){
        $kmer_freq[$i]=$kmer_freq[$i]/$sqfreq2sum;
        $vector_content=$vector_content."\t".$kmer_freq[$i];
    }
    $vector_content=$vector_content."\n";
    open(REF,">>$dbname")||die("can not open the ref file!\n");
    print REF $vector_content;
    close(REF);
}
sub char2num{
  my $chars=$_[0];
  my $nums;
  for(my $i=0;$i<length($chars);$i++){
    my $c=substr($chars,$i,1);
    if($c eq 'A' || $c eq 'a'){
      $nums=$nums.'0';
    }elsif($c eq 'T' || $c eq 't'){
      $nums=$nums.'1';
    }elsif($c eq 'C' || $c eq 'c'){
      $nums=$nums.'2';
    }elsif($c eq 'G' || $c eq 'g'){
      $nums=$nums.'3';
    }
  }
  return $nums;
}
sub rev {
    my ($seqt)=@_;
    $seqt = reverse $seqt;
    $seqt =~ tr/0123/1032/;
    return $seqt;
}
