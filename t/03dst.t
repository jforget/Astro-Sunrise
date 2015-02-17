#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#

use strict;
use Test::More;

if (!eval q{ require Time::Fake; 1;}) {
    print "1..0 # skip no Time::Fake module\n";
    exit;
}

my @tests = (
	     [1288545834, 'sun_rise', '07:00'],
	     [1288545834, 'sun_set',  '16:39'],

	     [1269738800, 'sun_rise', '06:49'],
	     [1269738800, 'sun_set',  '19:33'],
	    );

plan tests => scalar @tests;

for my $test (@tests) {
    my($epoch, $func, $expected) = @$test;
    my @cmd = ($^X, "-Mblib", "-MTime::Fake=$epoch", "-MAstro::Sunrise", "-e", "print $func(13.5,52.5)");
    open my $fh, "-|", @cmd or die $!;
    local $/;
    my $res = <$fh>;
    close $fh or die "Failure while running @cmd: $!";
    is $res, $expected, "Check for $func at $epoch";
}

__END__
