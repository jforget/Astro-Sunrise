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