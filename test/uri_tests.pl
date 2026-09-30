#!/usr/bin/perl
# Runs the cases of src/interfaces/libpq/t/001_uri.pl (without IPC::Run) with
# the libpq_uri_regress binary given as the first argument.
use strict;
use warnings;
my ($bin, $pl) = @ARGV;
my $tmp = "/tmp/uri_tests_$$";
open my $fh, '<', $pl or die $!;
my $src = do { local $/; <$fh> };
$src =~ /(my \@tests = \(.*?\]\);)/s or die "no tests";
my @tests;
my $code = $1; $code =~ s/^my \@tests/\@tests/;
eval $code; die $@ if $@;
my ($pass, $fail) = (0, 0);
for my $t (@tests) {
    my ($uri, $out, $err, %env) = @$t;
    local %ENV = (%ENV, %env);
    my $expect_exit = $err eq '' ? 1 : 0;
    system(sprintf("'%s' %s > $tmp.out 2> $tmp.err", $bin, quotemeta($uri)));
    my $exit = $? == 0 ? 1 : 0;
    open my $o, '<', "$tmp.out"; my $gout = do { local $/; <$o> } // ''; chomp $gout;
    open my $e, '<', "$tmp.err"; my $gerr = do { local $/; <$e> } // ''; chomp $gerr;
    if ($gout eq $out && $gerr eq $err && $exit == $expect_exit) { $pass++ }
    else { $fail++; print "FAIL: $uri\n  got: $gout | $gerr | $exit\n  exp: $out | $err | $expect_exit\n" }
}
unlink "$tmp.out", "$tmp.err";
print "$pass passed, $fail failed\n";
