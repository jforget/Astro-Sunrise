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

my $year   = 2017;
my $plot   = 0;
my $file   = 'equ-time.tex';
my $step   = 5;  # plot every <step> days
my $xscale =  1; # 
my $yscale = 10; # 
GetOptions( 'year:n' => \$year,
            'plot'   => \$plot,
            'file:s' => \$file,
            'step:n' => \$step,
            'xscale:n' => \$xscale,
            'yscale:n' => \$yscale,
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

my $fh;
if ($plot) {
  open $fh, '>', $file
    or die "Opening $file $!";
  print $fh <<'EOF';
% -*- encoding: utf-8 -*-
\documentclass[a4paper]{article}
\usepackage{luamplib}
\begin{document}
\begin{mplibcode}
beginfig(1);

EOF
  my $ln = int(366 / $xscale);
  print $fh "draw (0, 0) -- ($ln, 0);\n";
  $ln = int(1200 / $yscale);
  print $fh "drawarrow (0, -$ln) -- (0, $ln);\n";
  for ([-15, "11:45"], [-10, "11:50"], [-5, "11:55"], [0, "12:00"], [5, "12:05"], [10, "12:10"], [15, "12:15"]) {
    my ($delta, $label) = @$_;
    $ln = int($delta * 60 / $yscale);
    print $fh qq<label.lft("$label", (0, $ln));\n>;
  }
  my @month = qw/J F M A M J J A S O N D/;
  for (0..11) {
    $ln = int(($_ * 30 + 15) / $xscale);
    print $fh qq<label.bot("$month[$_]", ($ln, 0));\n>;
  }
}

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
    if ($plot) {
      printf $fh "draw (0, %d)", int(($noon_s - 43200) / $yscale);
    }
  }
  if ($plot && ($day % $step) == 0) {
    printf $fh "  -- (%d, %d)\n", int($day / $xscale), int(($noon_s - 43200) / $yscale);
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

if ($plot) {
  print $fh <<'EOF';
  ;
endfig;
\end{mplibcode}
\end{document}
EOF
  close $fh
    or die "Closing $file $!";
}

__END__

=encoding utf-8

=head1 NAME

equ-time.pl -- utility script to compute the equation of time each day of a year

=head1 SYNOPSIS

Just a List of values on F<stdout>

  equ-time.pl -year 2017

Adding a PNG plot

  equ-time.pl -year 2017 -plot
  lualatex equ-time.tex
  convert -crop '700x300+100+100' equ-time.pdf equ-time.png

=head1 DESCRIPTION

This script computes the true solar noon in local mean time. And the difference
between this time and 12h00 gives the equation of time.

Optionally, the script can generate a LuaLATEX file including a MetaPOST figure
showing the equation of time during one year.

=head1 USAGE

=head2 Parameters

=over 4

=item year

The year for which the equation of time will be computed.

=item plot

Boolean triggering the generation of the LuaLATEX file.

Default: 0, that is, no generation.

=item file

Filename for the generated LuaLATEX file. Useless if C<-plot> is false.

Default F<equ-time.tex>

=item step

When generating the file, not every day will be printed into the file.
This parameter gives the interval between two consecutive days
used in the curve. Useless if C<-plot> is false.

Default value 5.

=item xscale, yscale

Shrinking factors for the generated curve. The higher the value, the narrower
or the shorter the curve will be. Useless if C<-plot> is false.

=back

=head1 PREREQUISITE

In addition to core modules, this script needs L<DateTime::Event::Sunrise>.

If you want the graphical plot as a PDF file, you need C<lualatex>.

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
