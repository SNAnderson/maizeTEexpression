#convert_sam_to_all_NH1_v2.pl by sna
use strict; use warnings;

#This file will read through a SAM and print out all lines, changing the NH tag to NH:1 for all reads and adding RH tag with the real number of hits

die "usage: <convert_sam_to_all_NH1_v2.pl> <sam> \n" unless @ARGV == 1;

#Read through bedtools intersect file
open(my $file, $ARGV[0]) or die $!;

my @line;
my $newline;
my $segct;
my $hits;
my @hitsplit;

while (my $samline = <$file>){
  chomp $samline;
  if ($samline =~ /^@/) {
    print "$samline\n";
  }
  else{
    @line = split/\t/, $samline;
    $segct = 1;
    foreach my $segs (@line){
      if ($segs =~ m/^NH:/){
	@hitsplit = split/:/,$segs;
	$hits = $hitsplit[2];
	print "NH:i:1\t";
      }
      else{
	print "$segs\t";
      }
      $segct++;
    }
    print "RH:$hits\n";
  }
}
