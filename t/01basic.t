use strict;
use Test;
use Astro::Sunrise;
use DateTime;

BEGIN { plan tests => 10 }

my ($sunrise, $sunset) = sunrise(2000, 6, 20, -118, 33, -8, 1);

# test 1
ok ($sunrise eq '5:44');

# test 2
ok ($sunset eq '20:04');

# tests 3, 4, 5
my $sunrise_1 = sun_rise( -118, 33  );
my $sunrise_2 = sun_rise( -118, 33, -.833 );
my $sunrise_3 = sun_rise( -118, 33, -.833, 0 );
my $sunrise_4 = sun_rise( -118, 33, undef, 0 );

ok( $sunrise_1 eq $sunrise_2 );
ok( $sunrise_2 eq $sunrise_3 );
ok( $sunrise_3 eq $sunrise_4 );

# tests 6, 7, 8
my $sunset_1 = sun_rise( -118, 33  );
my $sunset_2 = sun_rise( -118, 33, -.833 );
my $sunset_3 = sun_rise( -118, 33, -.833, 0 );
my $sunset_4 = sun_rise( -118, 33, undef, 0 );

ok( $sunset_1 eq $sunset_2 );
ok( $sunset_2 eq $sunset_3 );
ok( $sunset_3 eq $sunset_4 );

# test 9
my $then = DateTime->new (
                    year => 2000,
		    month => 6,
		    day => 20,
		    time_zone =>'America/Los_Angeles',
		    );
my $offset = ( ($then->offset) /60 /60);

($sunrise, $sunset) = sunrise($then->year, $then->mon, $then->mday,
                              -118, 33, $offset, 0);
ok ($sunrise eq '5:44');
ok ($sunset eq '20:04');
