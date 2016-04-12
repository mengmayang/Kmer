#!/bin/perl
$NC_name=$ARGV[0];
$k=$ARGV[1];
$kmer_name="/export/home/yyqiao/QYY/Project/K-mer/kmer/k-mer_";
$vector_file=$ARGV[2];
$len=$ARGV[3];
$heredoc=<<END;
    USAGE:
        perl count_kmer.pl NCname k vector_file len
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
    my %kmer_hash=map{$kmer[$_],$kmer_num[$_]}(0..$#kmer);

    #Read the genome file 
    open(NC,$NC_name)||die("can not open the k-mer_$k\n");
    <NC>;
    my $i=0;
    my @l;
    while(my $line=<NC>){
     $i++;chomp $line;
=pod
     if($i<3){
=cut
       if(scalar(@l)>0){
         foreach my $l(@l){
            $c=$l.substr($line,0,$k-length($l));
            #print "$i:$j:$c:$n\n";
            ####count##############
            foreach my $str(keys %kmer_hash){
              if($c eq $str){
                $kmer_hash{$str}++;
                last;
              }
            }
            #######################
         }
       }
       my @l=();
       for($j=0;$j<length($line);$j++){
         $c=substr($line,$j,$k);
         $n=length($c);
         if($n<$k){
           @l=(@l,$c);
         }else{
           #print "$i:$j:$c:$n\n";        
           ####count##############
           foreach my $str(keys %kmer_hash){
             if($c eq $str){
               $kmer_hash{$str}++;
              # print "$c:$str:$kmer_hash{$str}\n";
               last;
             }
           }
           #######################
         }
       }
=pod
     }else{
       last;
     }
=cut
    }
    close(NC);
    my $vector_content="$vector_file:$len";
    foreach my $str(keys %kmer_hash){
      $vector_content=$vector_content."\n".$str."\t".$kmer_hash{$str};
    }
    open(VECTOR,">$vector_file")||die("can not open the vector file!\n");
    print VECTOR $vector_content;
    close(VECTOR);
}



