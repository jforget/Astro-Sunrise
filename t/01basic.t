use strict;
use Test;
use Astro::Sunrise;

BEGIN { plan tests => 2 }

my ($sunrise, $sunset) = sunrise(2000, 6, 20, -118, 33, -8, 1);

# test 1
ok ($sunrise eq '5:44');

# test 2
ok ($sunset eq '20:02');

