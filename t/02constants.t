#
#     Test script for Astro::Sunrise
#     Copyright (C) 2003, 2013 Ron Hill and Jean Forget
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
#     Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
#
use strict;
use Test;
use Astro::Sunrise qw(:constants);

BEGIN { plan tests => 6 }

ok( CIVIL,        -6 );

ok( CIVIL,        Astro::Sunrise::CIVIL        );
ok( AMATEUR,      Astro::Sunrise::AMATEUR      );
ok( ASTRONOMICAL, Astro::Sunrise::ASTRONOMICAL );
ok( DEFAULT,      Astro::Sunrise::DEFAULT      );
ok( NAUTICAL,     Astro::Sunrise::NAUTICAL     );
