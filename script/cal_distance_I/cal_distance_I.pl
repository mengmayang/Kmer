#!/bin/perl
$genome=$ARGV[0];
$metadata=$ARGV[1];
$classify=$ARGV[2];
$readlength=$ARGV[3];


$heredoc=<<END;
USAGE:
    perl cal_distance_I.pl genome_matrix metadata_matrix result read_length(100 for default)
END

my $flag=1;
if(!$genome||!$metadata||!$classify){
  print "$heredoc\n";
  $flag=0;
}elsif(!$readlength){
  $readlength=100;
  $flag=1;
}
if($flag){
open(GENOME,$genome)||die("!\n");
my @genome_content=<GENOME>;
close(GENOME);
my $genome_firstrow=$genome_content[0];
chomp $genome_firstrow;
my @row_names=split(/\t/,$genome_firstrow);
my @classify_names;
my @lengths;
=pod
for(my $i=1;$i<scalar(@row_names);$i++){
  my @T=split(/:/,$row_names[$i]);
  $classify_names[$i-1]=substr($T[0],0,length($T[0])-6);
  $lengths[$i-1]=$T[1];
}
=cut
for(my $i=1;$i<scalar(@genome_content);$i++){
  my $line=$genome_content[$i];chomp $line;
  my @T=split(/\t/,$line);
  my @T0=split(/:/,$T[0]);
  $classify_names[$i-1]=substr($T0[0],0,length($T0[0])-6);
  $lengths[$i-1]=$T0[1];
  
  for(my $j=1;$j<scalar(@T);$j++){
    $counts[$i-1][$j-1]=$T[$j]/$lengths[$i-1];
  }
}
 open(META,$metadata)||die("!\n");
 my @meta_content=<META>;
 close(META);
 #one line one read vector
 #the default readlength is 100bp
 my @reads_vectors;
 for(my $i=1;$i<scalar(@meta_content);$i++){
   chomp $meta_content[$i];
   my @T=split(/\t/,$meta_content[$i]);
   my $n=scalar(@T);
   for(my $j=1;$j<$n;$j++){
     #$reads_vectors[$i-1][$j-1]=$T[$j]/$readlength;
     $reads_vectors[$i-1][$j-1]=$T[$j];
   }
 }
 
 my $g_row=$#counts;
 my $g_col=$#{$counts[0]};
 my $m_row=$#reads_vectors;
 my $m_col=$#{$reads_vectors[0]};

 #print "$g_row\t$g_col\n$m_row\t$m_col\n";
 #point multiplication
 my $result_content="RESULT:";
 for(my $i=0;$i<=$m_row;$i++){
   my $distance;
   my $index=0;
   for(my $j=0;$j<=$g_row;$j++){
     my $cos=0;
     my $x2=0;
     my $y2=0;
     my $sumxy=0;
     for(my $p=0;$p<=$g_col;$p++){
       $sumxy=$sumxy+$counts[$j][$p]*$reads_vectors[$i][$p];
       $x2=$x2+$counts[$j][$p]**2;
       $y2=$y2+$reads_vectors[$i][$p]**2;
     }
     $cos=$sumxy/(sqrt($x2)*sqrt($y2));
     #print $i."-".$j.":".$cos."\n";
     if($j<1){
       $distance=$cos;
     }else{
       if($cos<$distance){
         $distance=$cos;
         $index=$j;
       }
     }
   }
   print "$i:$index:$distance:".$classify_names[$index]."\n";
   $result_content=$result_content."\n".$i."\t".$classify_names[$index];
 }
 
 open(CLASSIFY,">$classify")||die("!\n");
 print CLASSIFY $result_content;
 close(CLASSIFY);

}
