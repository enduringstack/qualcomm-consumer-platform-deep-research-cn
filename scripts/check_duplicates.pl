#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use File::Find;

my $root = shift // '.';
my @files;
find(
  sub {
    return unless -f $_ && $_ =~ /\.md\z/;
    return if $File::Find::name =~ m{/docs/plans/};
    return if $File::Find::name =~ m{/research/sources-qualcomm\.md\z};
    return if $File::Find::name =~ m{/research/references\.md\z};
    return if $File::Find::name =~ m{/QUALCOMM_CONSUMER_PLATFORM_DEEP_RESEARCH\.md\z};
    push @files, $File::Find::name;
  },
  "$root/research"
);

my %seen;
my @duplicates;
for my $file (sort @files) {
  open my $fh, '<:encoding(UTF-8)', $file or die "$file: $!";
  local $/;
  my $text = <$fh>;
  close $fh;
  $text =~ s/```.*?```//sg;
  for my $paragraph (split /\n\s*\n/, $text) {
    my $normalized = $paragraph;
    $normalized =~ s/^#+\s*//mg;
    $normalized =~ s/\[Q\d{3}\]//g;
    $normalized =~ s{https?://\S+}{}g;
    $normalized =~ s/[\s[:punct:]`*_>#|—–“”‘’]+//g;
    next if length($normalized) < 160;
    if (exists $seen{$normalized}) {
      push @duplicates, [$file, $seen{$normalized}, substr($normalized, 0, 60)];
    } else {
      $seen{$normalized} = $file;
    }
  }
}

print "long_paragraphs=" . scalar(keys %seen) . "\n";
print "duplicate_long_paragraphs=" . scalar(@duplicates) . "\n";
for my $item (@duplicates) {
  print "DUPLICATE $item->[0] == $item->[1]: $item->[2]...\n";
}
exit(@duplicates ? 1 : 0);
