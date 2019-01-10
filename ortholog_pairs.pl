#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my ($gff_1, $gff_2, $orthologs_tsv) = @ARGV;
die "Usage: $0 gff_1 gff_2 ortholog_matches" unless -f $gff_1 and -f $gff_2 and -f $orthologs_tsv;

my $genes_1 = read_gff($gff_1);
my $genes_2 = read_gff($gff_2);

my $orthologs = read_orthologs($orthologs_tsv);
my @pairs = keys %{$orthologs};

Q:
for my $q (@pairs) {
  P:
  for my $p (@pairs) {
     next Q if $p eq $q;
     my ($p1, $p2) = split "\t", $p;
     my ($q1, $q2) = split "\t", $q;
     my $tmp;
     if ($genes_1->{$p1}{start} > $genes_1->{$q1}{start}){
        # Orient the genes so that $p1 starts before $q1
        $tmp = $p1;
        $p1 = $q1;
        $q1 = $tmp;
        $tmp = $p2;
        $p2 = $q2;
        $q2 = $tmp;
     }
     my ($in_distance_1, $out_distance_1) = in_out_distances($genes_1->{$p1}, $genes_1->{$q1});
     my $distance_measure_1 = ($in_distance_1 eq "Inf" or $out_distance_1 eq "Inf") ? 0 : 1 - $in_distance_1/$out_distance_1;
     next if $distance_measure_1 < 0.5; #Max allowed distance between the genes is the sum of their lengths
     my ($in_distance_2, $out_distance_2) = in_out_distances($genes_2->{$p2}, $genes_2->{$q2});
     my $distance_measure_2 = ($in_distance_2 eq "Inf" or $out_distance_2 eq "Inf") ? 0 : 1 - $in_distance_2/$out_distance_2;
     next if $distance_measure_2 < 0.5; #Max allowed distance between the genes is the sum of their lengths
     my $score_distances = $distance_measure_1 * $distance_measure_2;
     my $strands = join ("", $genes_1->{$p1}{strand}, $genes_1->{$q1}{strand}, $genes_2->{$p2}{strand}, $genes_2->{$q2}{strand});
     my $strands_preserved = grep {$_ eq $strands} qw/---- ++++ -+-+ +-+- --++ ++--/;
     # next unless $strands_preserved;
     my ($p_score1, $p_score2) = @{$orthologs->{$p}};
     my ($q_score1, $q_score2) = @{$orthologs->{$q}};
     
     my $score_all = $score_distances * $p_score1 * $p_score2 * $q_score1 * $q_score2 * ($strands_preserved ? 1 : 0.1);
     next if $score_all eq 0;
     my $score_log_and_shifted = 5 + log($score_all)/log(10);
     next if $score_log_and_shifted < 0.1; # An arbitrary cutoff: leaves ~5k matches in S. mansoni vs E. multilocularis comparison
     say join ("\t",
        $p1, $q1, $p2, $q2,
        $in_distance_1, $out_distance_1, $distance_measure_1,
        $in_distance_2, $out_distance_2, $distance_measure_2,
        $score_distances, 
        $p_score1, $q_score1, $p_score2, $q_score2,
        $strands,
        $score_log_and_shifted,
     );
  }
}

sub read_gff {
  my ($path) = @_;
  my %result;
  open(my $fh, "<", $path) or die "$!: $path";
  while(<$fh>){
    next if /^#/;
    chomp;
    my @F = split "\t";
#SM_V7_2	WormBase_imported	gene	33749861	33773944	.	+	.	ID=gene:Smp_154870;Name=Smp_154870;biotype=protein_coding
    my ($scaffold, $feature, $start, $end, $strand, $misc) = @F[0,2,3,4,6,8];
    next unless $feature eq "gene";
    my ($name) = $misc =~ /Name=(.*?);/;
    die $misc unless $name;
    $result{$name} = {
      scaffold => $scaffold,
      start => $start,
      end => $end,
      strand => $strand,
    };
  }
  close $fh;
  return \%result;
}
sub read_orthologs {
  my ($path) = @_;
  my %result;
  open(my $fh, "<", $path) or die "$!: $path";
  while(<$fh>){
    chomp;
    my ($name_1, $name_2, $score_1, $score_2) = split "\t";
    $result{"$name_1\t$name_2"} = [$score_1 / 100, $score_2 / 100];
  }
  close $fh;
  return \%result;
}

sub in_out_distances {
  my ($g1, $g2) = @_;
  return "Inf", "Inf" unless $g1->{scaffold} eq $g2->{scaffold};
  my @xs = sort { $a <=> $b } map { abs $_ } $g2->{end} - $g1->{start}, $g2->{start} - $g1->{end};
  return @xs;
}
