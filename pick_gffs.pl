#!/usr/bin/env perl
use File::Slurp;
use strict;
use warnings;

my ($pairing, @gffs) = @ARGV;
die "Usage: $0 <n-way-pairing> <<n gffs>>" unless @ARGV;

my @gff_lines;
for my $gff (@gffs) {
  my @lines = read_file($gff);
  push @gff_lines, \@lines;
}

my @pairings = read_file($pairing);

for (@pairings) {
  chomp;
  my (@groups) = split "\t";
  for my $i (0..$#groups) {
     my $group = $groups[$i];
     my @genes = split /-|,/, $group;
     for my $line (@{$gff_lines[$i]}){
        for my $gene (@genes){
          print $line if $line =~ /$gene/ ;
        }
     }
  }
  print "\n";
}
