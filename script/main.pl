#!/bin/perl
$NC_length=$ARGV[0];
$begin=$ARGV[1];
$end=$ARGV[2];
$k_value=$ARGV[3];
$heredoc=<<END;
USAGE:
    perl main.pl NC_length.txt begin end k
END

if(!$NC_length||!$begin||!$end||!$k_value){
  print "$heredoc\n";
}else{
  open(NC_L,$NC_length)||die("can not open the file!\n");
  my @lengths;
  my @file_names;
  my @files;
  my @lines=<NC_L>;
  my $i=0;
  foreach $line(@lines){
    $i++;
    if($i>$end){
      last;
    }elsif($i>=$begin){
      chomp $line;
      my @T=split(/\s+/,$line);
      @lengths=(@lengths,$T[3]);
      @files=(@files,$T[4]);
      my @T1=split(/\//,$T[4]);
      my $name=$T1[2]."_".$T1[3];
      @file_names=(@file_names,$name);
    }
  }
  #count
  $vector_dir="/export/home/yyqiao/QYY/Project/K-mer/count_data";
  for(my $i=0;$i<scalar(@files);$i++){
    $NCname=$files[$i];
    $k=$k_value;
    $vector="$vector_dir/$k/".$file_names[$i]."_".$k;
    $len=$lengths[$i];
    print "$i:$vector\n";
    system("perl count_kmer_new.pl $NCname $k $vector $len");
    #if($i%4 eq 2){
    #  sleep(300);
    #}
  }
}

