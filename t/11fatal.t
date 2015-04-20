#!/usr/bin/perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Astro::Sunrise
#     Copyright (C) 2015 Ron Hill and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.16.3:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<http://www.perlfoundation.org/artistic_license_1_0>
#     and L<http://www.gnu.org/licenses/gpl-1.0.html>.
#
#     Here is the summary of GPL:
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 1, or (at your option)
#     any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software Foundation,
#     Inc., <http://www.fsf.org/>.
#
use strict;
use warnings;
use Test::More;

my $datetime_ok;

BEGIN {
  eval "use Test::Fatal;";
  if ($@) {
    plan skip_all => "Test::Fatal needed";
    exit;
  }
  eval "use DateTime;";
  if ($@) {
    $datetime_ok = 0;
  }
  else {
    $datetime_ok = 1;
  }
}
use Astro::Sunrise(qw(:DEFAULT :constants));
plan(tests => 1 + $datetime_ok);

like ( exception { sunrise ( { year => 2003, month => 6, day => 21, tz => 0, lon => 0, lat => 0,
                                          polar => 'whatever' } ) },
                         qr/Wrong value of the 'polar' argument/,
                         "Wrong value of the 'polar' argument");

if ($datetime_ok) {
  like ( exception { sun_rise ( { year => 2003, month => 6, day => 21, tz => 0, lon => 0, lat => 0,
                                          polar => 'whatever' } ) },
                         qr/Wrong value of the 'polar' argument/,
                         "Wrong value of the 'polar' argument");

}
