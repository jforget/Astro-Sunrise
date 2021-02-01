#!/usr/bin/perl
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Test script for Astro::Sunrise
#     Copyright (C) 2003, 2013, 2017, 2021 Ron Hill and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.16.3:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<https://dev.perl.org/licenses/artistic.html>
#     and L<https://www.gnu.org/licenses/gpl-1.0.html>.
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
#     Inc., <https://www.fsf.org/>.
#
use strict;
use warnings;
use Test::More;
use Astro::Sunrise qw(:constants);

BEGIN { plan tests => 6 }

is( CIVIL,        -6 );

is( CIVIL,        Astro::Sunrise::CIVIL        );
is( AMATEUR,      Astro::Sunrise::AMATEUR      );
is( ASTRONOMICAL, Astro::Sunrise::ASTRONOMICAL );
is( DEFAULT,      Astro::Sunrise::DEFAULT      );
is( NAUTICAL,     Astro::Sunrise::NAUTICAL     );
