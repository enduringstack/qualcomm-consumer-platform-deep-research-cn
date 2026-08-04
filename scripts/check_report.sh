#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
report="$repo_dir/QUALCOMM_CONSUMER_PLATFORM_DEEP_RESEARCH.md"
minimum_han=50000

if [[ ! -f "$report" ]]; then
  echo "report missing: run scripts/assemble_report.sh" >&2
  exit 1
fi

metrics=$(perl -CSD -Mopen=:std,:encoding\(UTF-8\) -0777 -e '
  my $bytes = -s $ARGV[0];
  my $text = <>;
  my $unicode = length($text);
  $text =~ s/```.*?```//sg;
  $text =~ s/~~~.*?~~~//sg;
  $text =~ s/`[^`]*`//g;
  $text =~ s{https?://[^\s)>]+}{}g;
  my $han = () = $text =~ /\p{Han}/g;
  print "$unicode $bytes $han";
' "$report")

read -r unicode_count byte_count han_count <<< "$metrics"
echo "unicode_characters=$unicode_count"
echo "bytes=$byte_count"
echo "han_characters=$han_count"
echo "minimum_han=$minimum_han"

if (( han_count < minimum_han )); then
  echo "FAIL: Han character count below threshold" >&2
  exit 1
fi

echo "PASS: report length gate"
