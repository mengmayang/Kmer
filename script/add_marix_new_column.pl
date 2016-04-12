#!/bin/perl
$matrix=$ARGV[0];
$new_count_file=$ARGV[1];
$new_matrix=$ARGV[2];

$heredoc=<<END;
USAGE:
    perl add_marix_new_column.pl matrix new_col new_matrix
END

if(!$matrix||!$new_count_file||!$new_matrix){
  print "$heredoc\n";
}else{
open(MATRIX,$matrix)||die("open file error!\n");
open(COL,$new_count_file)||die("open file error!\n");

my $header="k-mer";

my $matrix_header=<MATRIX>;chomp $matrix_header;
my $col_header=<COL>;chomp $col_header;
my @T=split(/\//,$col_header);my $col_name=$T[scalar(@T)-1];

my %h_col;
while(my $line=<COL>){
  chomp $line;
  my @T=split(/\t/,$line);
  $h_col{$T[0]}=$T[1];
}
my $flag_header=0;
if($matrix_header=~/^k-mer/){
  $header=$matrix_header."\t".$col_name;
  $flag_header=1;
}
my %h_matrix;

if(!$flag_header){
  my @T=split(/\//,$matrix_header);
  my $name=$T[scalar(@T)-1];
  $header=$header."\t".$name."\t".$col_name;
}

while(my $line=<MATRIX>){
  chomp $line;
  my @T=split(/\t/,$line);
  $h_matrix{$T[0]}=$line;
}
my $content=$header;

my @order;

  @order=sort{$a cmp $b} keys %h_matrix;

foreach my $kmer(@order){
  $content=$content."\n".$h_matrix{$kmer}."\t".$h_col{$kmer};
}
close(MATRIX);
close(COL);

open(NEWM,">$new_matrix")||die("open file error!\n");
print NEWM $content;
close(NEWM);
}
