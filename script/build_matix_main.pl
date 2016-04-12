#!/bin/perl
$dir=$ARGV[0];
$matrix=$ARGV[1];

$heredoc=<<END;
USAGE:
  perl build_matix_main.pl countfile_dir matrix_output
END
if(!$dir||!$matrix){
  print "$heredoc\n";
}else{
    if(substr($dir,length($dir)-1,1)=~/\//){
      $dir=substr($dir,0,length($dir)-1);
    }
    
    opendir(THISDIR,$dir) or die "serious dainbramage: $!";
    my @files=readdir THISDIR;
    closedir THISDIR;
    $matrix1=$files[2];
    $matrix1="$dir/$matrix1";
    $col=$files[3];
    $col="$dir/$col";
    system("perl add_marix_new_column.pl $matrix1 $col $matrix");
    for(my $i=4;$i<scalar(@files);$i++){
      if($files[$i]=~/uid/){
        $col=$files[$i];
        $col="$dir/$col";
        #print "$i:$col\n";
        system("perl add_marix_new_column.pl $matrix $col $matrix");
      }
    }
}
