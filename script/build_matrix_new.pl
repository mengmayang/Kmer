#!/bin/perl
$k=$ARGV[0];
$matrix=$ARGV[1];

$heredoc=<<END;
USAGE:
    perl build_matrix_new.pl k matrix
END
if(!$k||!$matrix){
  print $heredoc."\n";
}else{
  my $matrix_content;
  $header="k-mer";
  my $dir="/export/home/yyqiao/QYY/Project/K-mer/count_data/$k";
  print $dir."\n";
  opendir(DIR,$dir)||die("!\n");
  my @files=readdir(DIR);
  closedir(DIR);
  $kmer_file="/export/home/yyqiao/QYY/Project/K-mer/kmer/k-mer_".$k;
  open(KMER,$kmer_file)||die("!\n");
  my @kmers=<KMER>;chomp @kmers;
  close(KMER);
  #print scalar(@kmers)."\n";
  foreach my $kmer(@kmers){
    $kmer=~s/[\r\n]$//;
    $header=$header."\t".$kmer;
  }
  $matrix_content=$header;
  my $n=0;
  foreach my $name(@files){
    if($name=~/\.fna_$k$/){
      $n++;
      my $file="$dir/$name";
      
      open(FILE,$file)||die("open error!\n");
      my $head=<FILE>;
      my @counts=<FILE>;
      close(FILE);
      my @T=split(/\//,$head);
      my $NAME=$T[scalar(@T)-1];
      $NAME=~s/[\r\n]$//;
      my $line=$NAME;
      for(my $i=0;$i<scalar(@counts);$i++){
        $counts[$i]=~s/[\r\n]$//;
        my @T1=split(/\t/,$counts[$i]);
        $line=$line."\t".$T1[1];
      }
      #print "$n:$line\n";
      $matrix_content=$matrix_content."\n".$line;
    }
  }
  open(MATRIX,">$matrix")||die("open error!\n");
  print MATRIX $matrix_content;
  close(MATRIX);
}
