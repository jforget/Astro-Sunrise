#!/usr/bin/perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Utility script for Astro::Sunrise's astronomical documentation
#     Copyright (C) 2017 Jean Forget
#
#     This program is distributed under the same terms as Perl 5.16.3:
#     GNU Public License version 1 or later and Perl Artistic License.
#     More on than in the POD below
#

use v5.10;
use strict;
use warnings;
use Getopt::Long;
use DateTime::Event::Sunrise;

my $year = 2017;
GetOptions( 'year:n' => \$year,
          )
  or die "problem with the options";

my ($long, $lat) = (0, 50);
my $loc = DateTime::Event::Sunrise->new(longitude => $long, latitude => $lat);
my $dt_orig = DateTime->new(year => $year, month => 1, day => 1);

my %result = ( min  => { sec => 86400 },
               max  => { sec =>     0 },
               incr => { delta =>   0 },
               decr => { delta =>   0 },
             );

my $noon_prev;
for (my $day = 0; $day <= 365; $day++) {
  my $date = $dt_orig->clone->add(days => $day);
  my @t = $loc->sunrise_datetime($date)->utc_rd_values;
  my $rise_s = $t[1];
  @t = $loc->sunset_datetime($date)->utc_rd_values;
  my $set_s  = $t[1];
  my $noon_s = int(($rise_s + $set_s) / 2);
  my $noon = $date->clone->add(seconds => $noon_s);
  my $sign = '+';
  my $s    = $noon_s - 43200;
  if ($s < 0) {
    $s = - $s;
    $sign = '-';
  }
  my $m = int($s / 60);
  $s -= $m * 60;
  my $equ = sprintf("%s%02d mn %02d s", $sign, $m, $s);
  say $noon->strftime("%Y-%m-%d %H:%M:%S"), ' ', $equ;

  if ($day == 0) {
    $noon_prev = $noon_s;
  }

  my @keys;
  if ($noon_s < $result{min}{sec}) {
    push @keys, 'min';
  }
  if ($noon_s > $result{max}{sec}) {
    push @keys, 'max';
  }
  if ($noon_s - $noon_prev > $result{incr}{delta}) {
    push @keys, 'incr';
  }
  if ($noon_s - $noon_prev < $result{decr}{delta}) {
    push @keys, 'decr';
  }

  for (@keys) {
    $result{$_}{sec}   = $noon_s;
    $result{$_}{delta} = $noon_s - $noon_prev;
    $result{$_}{date}  = $noon->strftime("%Y-%m-%d %H:%M:%S");
    $result{$_}{equ}   = $equ;
  }
  $noon_prev = $noon_s;
}

for (keys %result) {
  say "$_ $result{$_}{date} $result{$_}{equ} $result{$_}{delta}";
}


__END__

=encoding utf-8

=head1 NAME

equ-time.pl -- utility script to compute the equation of time each day of a year

=head1 SYNOPSIS

  equ-time.pl -year 2017

=head1 DESCRIPTION

This script computes the true solar noon in local mean time. And the difference
between this time and 12h00 gives the equation of time.

=head1 USAGE

=head1 KNOWN BUGS

The program computes the true solar noon for 366 days whatever the year,
leap or normal.

=head1 AUTHOR

Jean Forget (JFORGET at cpan dot org)

=head1 COPYRIGHT and LICENSE

This program is distributed under the same terms as Perl 5.16.3:
GNU Public License version 1 or later and Perl Artistic License

You can find the text of the licenses in the F<LICENSE> file or at
L<http://www.perlfoundation.org/artistic_license_1_0>
and L<https://www.gnu.org/licenses/gpl-1.0.html>.

Here is the summary of GPL:

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., L<https://www.fsf.org/>.

=head1 SEE ALSO

perl(1).

L<Astro::Sunrise>

L<DateTime::Event::Sunrise;>

=cut
