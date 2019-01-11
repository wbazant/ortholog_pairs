

result_as_graph_edges() {
  perl -nE 'chomp; my @F = split "\t"; say sprintf("%s-%s\t%s-%s\t%s", @F[0,2,1,3], $F[$#F])' "$@"
}

result_as_pairs(){
  perl -nE 'chomp; my @F = split "\t"; say sprintf("%s-%s\t%s-%s", @F[0,1,2,3])' "$@"
}

result_as_pairs_with_strands(){
  perl -nE 'chomp ;my @F = split "\t"; say sprintf("%s-%s\t%s-%s\t%s", @F[0,1,2,3,15])' "$@"
}

join_pairs_command_1() {
  file=$1
  shift
  if [ "$@" ]; then
    it="$( join_pairs_command "$@" )"
    echo "join -t \$'\\t' -11 -21 <( $it ) <(result_as_pairs $file | sort -k1 ) "
  else 
    echo "result_as_pairs $file | sort -k1 "
  fi
}

join_pairs_command() {
  perl -E '
    sub r {
      my ($x, @xs) = @_;
      if(@xs) {
        my $it = &r(@xs);
        return " join -11 -21 <( $it ) <( result_as_pairs $x | sort -k1 ) " ;
      } else {
        return "result_as_pairs $x | sort -k1 ";
      }
    }
    say r(@ARGV);
  ' "$@"
}

count_pairs () {
   `join_pairs_command "$@"` | wc -l 
}
