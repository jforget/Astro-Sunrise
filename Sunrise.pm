package Astro::Sunrise;

=head1 NAME

Astro::Sunrise - Perl extension for computing the sunrise/sunset on a given day

=head1 SYNOPSIS

  use Astro::Sunrise;
  
  ($sunrise, $sunset) = sunrise(YYYY,MM,DD,longitude,latitude,Time Zone,DST);

=head1 DESCRIPTION
  
   This module will return the sunrise/sunset for a given day. 
   
   Eastern longitude is entered as a positive number
   Western longitude is entered as a negative number
   Northern latitude is entered as a positive number
   Southern latitude is entered as a negative number

   There are a number of altitides to chose from, I have chosen
   -0.833 because this is what most countries use. Feel free to 
   change it if you need to. Here is the list:
   h = 0 degrees: Center of Sun's disk touches a mathematical horizon
   h = -0.25 degrees: Sun's upper limb touches a mathematical horizon
   h = -0.583 degrees: Center of Sun's disk touches the horizon; atmospheric refraction accounted for
   h = -0.833 degrees: Sun's supper limb touches the horizon; atmospheric refraction accounted for
   h = -6 degrees: Civil twilight (one can no longer read outside without artificial illumination)
   h = -12 degrees: Nautical twilight (navigation using a sea horizon no longer possible)
   h = -15 degrees: Amateur astronomical twilight (the sky is dark enough for most astronomical observations)
   h = -18 degrees: Astronomical twilight (the sky is completely dark)

=cut

use strict;
#use warnings;

use Math::Trig;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK $RADEG $DEGRAD );

require Exporter;

@ISA       = qw( Exporter );
@EXPORT    = qw( sunrise );
@EXPORT_OK = qw();

$VERSION = '0.04';
$RADEG  = ( 180 / pi );
$DEGRAD = ( pi / 180 );

=head2 sunrise

    ($sunrise, $sunset) = sunrise(YYYY,MM,DD,longitude,latitude,Time Zone,DST);
    ($sunrise, $sunset) = sunrise( 2001, 3, 10, 17.384, 98.625, -5, 0 );

Returns the sunrise and sunset times, in HH:MM format.
(Note: Time Zone is the offset from GMT and DST is daylight
savings time, 1 means DST is in effect and 0 is not.

=cut
sub sunrise {

    my ( $year, $month, $day, $log, $lat, $TZ, $isdst ) = @_;

###############################################################################
    #calculate days since 2000 jan 1
    my $d =
      ( 367 * ($year) -
      int( ( 7 * ( ($year) + ( ( ($month) + 9 ) / 12 ) ) ) / 4 ) +
      int( ( 275 * ($month) ) / 9 ) + ($day) - 730530 );

###############################################################################
    # Orbital elements of the Sun:
    my $N = 0.0;
    my $i = 0.0;
    my $w = 282.9404 + 4.70935E-5 * $d;

    my $a = 1.000000;
    my $e = 0.016709 - 1.151E-9 * $d;

    my $M = 356.0470 + 0.9856002585 * $d;
    $M = rev($M);

    my $ecl = 23.4393 - 3.563E-7 * $d;
    my $L   = $w + $M;
    if ( $L < 0 || $L > 360 ) {
        $L = rev($L);
    }

###############################################################################
    # position of the Sun
    my $E  = $M + $e * ( 180 / pi ) * sind($M) * ( 1.0 + $e * cosd($M) );
    my $xv = cosd($E) - $e;
    my $yv = sqrt( 1.0 - $e * $e ) * sind($E);

    my $v = atan2d( $yv, $xv );
    my $r      = sqrt( $xv * $xv + $yv * $yv );
    my $lonsun = $v + $w;
    if ( $lonsun < 0 || $lonsun > 360 ) {
        $lonsun = rev($lonsun);
    }
    my $xs  = $r * cosd($lonsun);
    my $ys  = $r * sind($lonsun);
    my $xe  = $xs;
    my $ye  = $ys * cosd($ecl);
    my $ze  = $ys * sind($ecl);
    my $RA  = atan2d( $ye, $xe );
    my $Dec = atan2d( $ze, ( sqrt( ( $xe * $xe ) + ( $ye * $ye ) ) ) );
    my $h   = -0.833;

###################################################################################

    my $GMST0 = $L + 180;
    if ( $GMST0 < 0 || $GMST0 > 360 ) {
        $GMST0 = rev($GMST0);
    }

    my $UT_Sun_in_south = ( $RA - $GMST0 - $log ) / 15.0;
    if ( $UT_Sun_in_south < 0 ) {
        $UT_Sun_in_south = $UT_Sun_in_south + 24;
    }

    my $LHA =
      sind($h) - ( sind($lat) * sind($Dec) ) / ( cosd($lat) * cosd($Dec) );
    if ( $LHA > -1 || $LHA < 1 ) {
        $LHA = acosd($LHA) / 15;
      } else {
        return;
    }
    my $hour_rise = $UT_Sun_in_south - $LHA;
    my $hour_set  = $UT_Sun_in_south + $LHA;
    my $min_rise  = abs(int( ( $hour_rise - int($hour_rise) ) * 60 ));
    my $min_set   = abs(int( ( $hour_set - int($hour_set) ) * 60 ));

    $hour_rise = ( int($hour_rise) + ( $TZ + $isdst ) );
    $hour_set  = ( int($hour_set) + ( $TZ + $isdst ) );
    if ( $min_rise < 10 ) {
        $min_rise = sprintf( "%02d", $min_rise );
    }

    if ( $min_set < 10 ) {
        $min_set = sprintf( "%02d", $min_set );
    }

    return ( "$hour_rise:$min_rise", "$hour_set:$min_set" );
}

#########################################################################################################
sub sind {
    sin( ( $_[0] ) * $DEGRAD );
}

sub cosd {
    cos( ( $_[0] ) * $DEGRAD );
}

sub tand {
    tan( ( $_[0] ) * $DEGRAD );
}

sub atand {
    ( $RADEG * atan( $_[0] ) );
}

sub asind {
    ( $RADEG * asin( $_[0] ) );
}

sub acosd {
    ( $RADEG * acos( $_[0] ) );
}

sub atan2d {
    ( $RADEG * atan2( $_[0], $_[1] ) );
}

sub rev {
    my $x = $_[0];
    $x = ( $x - int( $x / 360.0 ) * 360.0 );
    if ( $x <= 0 ) {
        $x = $x + 360;
    }
    return $x;
}

1;

=head1 AUTHOR

Ron Hill
rkhill@pacbell.net

Many thanks also go to Paul Schlyer, Stockholm, Sweden for his excellent
web page on the subject. 

=head1 CREDITS

Thanks very much to:


=item Rich Bowen (rbowen@rbowen.com)

for suggestions

=head1 COPYRIGHT and LICENSE


Here is the copyright information provided by Paul Schlyer:

Written as DAYLEN.C, 1989-08-16

Modified to SUNRISET.C, 1992-12-01

(c) Paul Schlyter, 1989, 1992

Released to the public domain by Paul Schlyter, December 1992

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 SEE ALSO

perl(1).

=cut

