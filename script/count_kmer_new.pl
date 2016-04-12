#!/bin/perl
$NC_name=$ARGV[0];
$k=$ARGV[1];
$kmer_name="/export/home/yyqiao/QYY/Project/K-mer/kmer/k-mer_";
$vector_file=$ARGV[2];
$len=$ARGV[3];
$heredoc=<<END;
    USAGE:
        perl count_kmer_new.pl NCname k vector_file len
END

if(!$NC_name||!$k||!$vector_file||!$len){
  print "$heredoc\n";
}elsif($k<4||$k>8){
  print "Please select k between 4 and 8!\n";
}else{
    #Read the k-mer file to the kmer array @kmer
    $kmer_name=$kmer_name.$k;
    open(KMER,$kmer_name)||die("can not open the k-mer_$k\n");
    my @kmer=<KMER>;
    foreach(@kmer){
      chop($_) while ($_ =~ /[\r\n]$/);
    }
    close(KMER);
    
    my @kmer_num=(0)x scalar(@kmer);

    #Read the genome file 
    open(NC,$NC_name)||die("can not open the k-mer_$k\n");
    <NC>;
    my $sequence=<NC>;
    my @sequence_lines=<NC>;
    chomp $sequence;
    close(NC);

    foreach $line(@sequence_lines){
      chomp $line;
      $sequence=$sequence.$line;
    }

    for(my $i=0;$i<length($sequence)-$k+1;$i++){
      my $c=substr($sequence,$i,$k);
      my $index = &get_index($c);
      $kmer_num[$index]++;
    }
        
    my $vector_content="$vector_file:$len";
    for(my $i=0;$i<scalar(@kmer);$i++){
      $vector_content=$vector_content."\n".$kmer[$i]."\t".$kmer_num[$i];
    }
    open(VECTOR,">$vector_file")||die("can not open the vector file!\n");
    print VECTOR $vector_content;
    close(VECTOR);
}

sub get_index{
  my $c=$_[0];
  my $index=0;
  my $n=length($c);
  for(my $i=0;$i<$n;$i++){
    my $v;
    my $letter=substr($c,$i,1);
    if($letter eq 'A'){
      $v=0;
    }elsif($letter eq 'T'){
      $v=1;
    }elsif($letter eq 'C'){
      $v=2;
    }elsif($letter eq 'G'){
      $v=3;
    }
    $index=$index+$v*(4**($n-$i-1));
  }
 # print "$c:$index\n";
 return $index;
}

