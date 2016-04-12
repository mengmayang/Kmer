#!/bin/perl
system("rm metadata_tmp.txt");
$predict_file=$ARGV[0];
$metadata_dir=$ARGV[1];
$result=$ARGV[2];

$heredoc=<<END;
USAGE:
    perl cal_right_rate.pl predict_file metadata_dir result_name
END

if(!$predict_file||!$metadata_dir||!$result){
  print "$heredoc\n";
}else{
open(PREDICT,$predict_file)||die("!\n");
my @predicts=<PREDICT>;
close(PREDICT);
shift @predicts;
if($metadata_dir=~/\/$/){
  $metadata_dir=substr($metadata_dir,0,length($metadata_dir)-1);
}
opendir(META,$metadata_dir)||die("!\n");
my @metadata_files=readdir(META);
closedir(META);

my @metadata_reads;
for(my $i=0;$i<scalar(@metadata_files);$i++){
  if($metadata_files[$i]=~/\.fq/){
    my $metadata_file=$metadata_files[$i];
    my $metadata_file="$metadata_dir/$metadata_file";
    my $metadata_tmp="metadata_tmp.txt";
    system("grep \"@>\" $metadata_file >$metadata_tmp");
    open(R,$metadata_tmp)||die("!\n");
    my @reads=<R>;
    close(R);
 #   system("rm $metadata_tmp");
    @metadata_reads=(@metadata_reads,@reads);
  }
}

$count_right=0;
$count_total=scalar(@predicts);
print "$count_total\n";
$result_content="RESULT:";
for(my $i=0;$i<$count_total;$i++){
  my @T=split(/\t/,$predicts[$i]);
  my @T1=split(/\_/,$T[1]);
  my $str=$T1[0]."\s".$T1[1];
  if($metadata_reads[$i]=~/$str/){
    $count_right++;
  }
}
my $rate=$count_right/$count_total;
$result_content=$result_content."\n"."predict:$predict_file"."\n"."metadata_dir:".$metadata_dir."\n"."Right Count:".$count_right."\n"."Total reads:".$count_total."\n"."Right Rate:".$rate;

my $result=$result."\_RightRate.txt";
print $result."\n";
open(RESULT,">$result")||die("\n");
print RESULT $result_content;
close(RESULT);
}





