#!/bin/perl
$fq_dir=$ARGV[0];
$k=$ARGV[1];
$kmer_name="/export/home/yyqiao/QYY/Project/K-mer/kmer/k-mer_";
$vector_file=$ARGV[2];

$heredoc=<<END;
    USAGE:
        perl count_kmer_for_fq.pl fq_dir k vector_file 
END

if(!$fq_dir||!$k||!$vector_file){
  print "$heredoc\n";
}elsif($k<4||$k>8){
  print "Please select k between 4 and 8!\n";
}else{
    #Read the k-mer file to the kmer array @kmer
    $kmer_name=$kmer_name.$k;
    open(KMER,$kmer_name)||die("can not open the k-mer_$k\n");
    my @kmer=<KMER>;
    my $header="index";
    foreach(@kmer){
      chop($_) while ($_ =~ /[\r\n]$/);
      $header=$header."\t".$_;
    }
    close(KMER);

    my $vector_content=$header;

    #Read the metadata's dir
    opendir(FQDIR,$fq_dir)||die("can not open $fq_dir\n");
    my @tmpfq=readdir FQDIR;
    closedir FQDIR;
    if(substr($fq_dir,length($fqdir)-1,1) eq "/"){
       $fq_dir=substr($fq_dir,0,length($fqdir)-1);
    }
    my @metafq=grep(/\.fq/,@tmpfq);
    my $m=0;
    foreach my $fq(@metafq){
      #$vector_content=$vector_content."\t".$fq;
      $fq="$fq_dir/$fq";
      open(FQ,$fq)||die("can not open the $fq!\n");
      while(my $line=<FQ>){
        if($line =~ /^@/){
          my $sequence=<FQ>;chomp $sequence;
          my @kmer_num=(0)x scalar(@kmer);
          $m++;
          print "$m\n";
          <FQ>;<FQ>;
          for(my $i=0;$i<length($sequence)-$k+1;$i++){
            my $c=substr($sequence,$i,$k);
            for(my $i=0;$i<scalar(@kmer);$i++){
              if($kmer[$i] eq $c){
                $kmer_num[$i]++;
                last;
              }
            }
          }
          my $read_vector=$m;
          for(my $i=0;$i<scalar(@kmer_num);$i++){
            $read_vector=$read_vector."\t".$kmer_num[$i];
          }
          $vector_content=$vector_content."\n".$read_vector;
        }
      }
      close(FQ);
    }

    open(VECTOR,">$vector_file")||die("can not open the vector file!\n");
    print VECTOR $vector_content;
    close(VECTOR);

}



