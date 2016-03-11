/* +++Date last modified: 05-Jul-1997 */
/* Updated comments, 05-Aug-2013 */

/*

SUNRISET.C - computes Sun rise/set times, start/end of twilight, and
             the length of the day at any date and latitude

Written as DAYLEN.C, 1989-08-16

Modified to SUNRISET.C, 1992-12-01

(c) Paul Schlyter, 1989, 1992

Released to the public domain by Paul Schlyter, December 1992

Converted to iterative algorithm (work in progress) by Jean Forget, March 2016

Build with:
  cc sunrisetplus.c -lm -o sunrisetplus
or with:
  cc -DTRACE=1 sunrisetplus.c -lm -o sunrisetplus

*/


#include <stdio.h>
#include <math.h>


/* A macro to compute the number of days elapsed since 2000 Jan 0.0 */
/* (which is equal to 1999 Dec 31, 0h UT)                           */

#define days_since_2000_Jan_0(y,m,d) \
    (367L*(y)-((7*((y)+(((m)+9)/12)))/4)+((275*(m))/9)+(d)-730530L)

/* Some conversion factors between radians and degrees */

#ifndef PI
 #define PI        3.1415926535897932384
#endif

#define RADEG     ( 180.0 / PI )
#define DEGRAD    ( PI / 180.0 )

/* Stopping the iteration after a variation lower than 1e-6 hour, that is 3.6 milliseconds
   overkill, but this allows to show how the algorithm works. */
#define EPSILON 0.000001

/* Failsafe exit from the loop */
#define ITERMAX 10

/* The trigonometric functions in degrees */

#define sind(x)  sin((x)*DEGRAD)
#define cosd(x)  cos((x)*DEGRAD)
#define tand(x)  tan((x)*DEGRAD)

#define atand(x)    (RADEG*atan(x))
#define asind(x)    (RADEG*asin(x))
#define acosd(x)    (RADEG*acos(x))
#define atan2d(y,x) (RADEG*atan2(y,x))


/* Following are some macros around the "workhorse" function __daylen__ */
/* They mainly fill in the desired values for the reference altitude    */
/* below the horizon, and also selects whether this altitude should     */
/* refer to the Sun's center or its upper limb.                         */


/* This macro computes the length of the day, from sunrise to sunset. */
/* Sunrise/set is considered to occur when the Sun's upper limb is    */
/* 35 arc minutes below the horizon (this accounts for the refraction */
/* of the Earth's atmosphere).                                        */
#define day_length(year,month,day,lon,lat)  \
        __daylen__( year, month, day, lon, lat, -35.0/60.0, 1 )

/* This macro computes the length of the day, including civil twilight. */
/* Civil twilight starts/ends when the Sun's center is 6 degrees below  */
/* the horizon.                                                         */
#define day_civil_twilight_length(year,month,day,lon,lat)  \
        __daylen__( year, month, day, lon, lat, -6.0, 0 )

/* This macro computes the length of the day, incl. nautical twilight.  */
/* Nautical twilight starts/ends when the Sun's center is 12 degrees    */
/* below the horizon.                                                   */
#define day_nautical_twilight_length(year,month,day,lon,lat)  \
        __daylen__( year, month, day, lon, lat, -12.0, 0 )

/* This macro computes the length of the day, incl. astronomical twilight. */
/* Astronomical twilight starts/ends when the Sun's center is 18 degrees   */
/* below the horizon.                                                      */
#define day_astronomical_twilight_length(year,month,day,lon,lat)  \
        __daylen__( year, month, day, lon, lat, -18.0, 0 )


/* This macro computes times for sunrise/sunset.                      */
/* Sunrise/set is considered to occur when the Sun's upper limb is    */
/* 35 arc minutes below the horizon (this accounts for the refraction */
/* of the Earth's atmosphere).                                        */
#define sun_rise_set(year,month,day,lon,lat,rise,set)  \
        __sunriset__( year, month, day, lon, lat, -35.0/60.0, 1, rise, set )

/* This macro computes the start and end times of civil twilight.       */
/* Civil twilight starts/ends when the Sun's center is 6 degrees below  */
/* the horizon.                                                         */
#define civil_twilight(year,month,day,lon,lat,start,end)  \
        __sunriset__( year, month, day, lon, lat, -6.0, 0, start, end )

/* This macro computes the start and end times of nautical twilight.    */
/* Nautical twilight starts/ends when the Sun's center is 12 degrees    */
/* below the horizon.                                                   */
#define nautical_twilight(year,month,day,lon,lat,start,end)  \
        __sunriset__( year, month, day, lon, lat, -12.0, 0, start, end )

/* This macro computes the start and end times of astronomical twilight.   */
/* Astronomical twilight starts/ends when the Sun's center is 18 degrees   */
/* below the horizon.                                                      */
#define astronomical_twilight(year,month,day,lon,lat,start,end)  \
        __sunriset__( year, month, day, lon, lat, -18.0, 0, start, end )


/* Function prototypes */

double __daylen__( int year, int month, int day, double lon, double lat,
                   double altit, int upper_limb );

int __sunriset__( int year, int month, int day, double lon, double lat,
                  double altit, int upper_limb, double *rise, double *set );

void sunpos( double d, double *lon, double *r );

void sun_RA_dec( double d, double *RA, double *dec, double *r );

double revolution( double x );

double rev180( double x );

double GMST0( double d );

void format_hour(double t, char buf[]);


/* A small test program */

main()
{
      int year,month,day;
      double lon, lat;
      double daylen, civlen, nautlen, astrlen;
      double rise, set, civ_start, civ_end, naut_start, naut_end,
             astr_start, astr_end;
      int    rs, civ, naut, astr;
      char buf[80], *rc, bufr[30], bufs[30];

      printf( "Longitude (+ is east) and latitude (+ is north) : " );
      fgets(buf, 80, stdin);
      sscanf(buf, "%lf %lf", &lon, &lat );

      for(;;)
      {
            printf( "Input date ( yyyy mm dd ) (ctrl-D (=EOF) exits): " );
            rc = fgets(buf, 80, stdin);
	    if (rc == 0) {
              printf("\nEnd\n");
	      break;
	    }
            sscanf(buf, "%d %d %d", &year, &month, &day );

            // I am not interested in modifying the xx_length functions.
            //daylen  = day_length(year,month,day,lon,lat);
            //civlen  = day_civil_twilight_length(year,month,day,lon,lat);
            //nautlen = day_nautical_twilight_length(year,month,day,lon,lat);
            //astrlen = day_astronomical_twilight_length(year,month,day,
            //      lon,lat);
	    //
            //printf( "Day length:                 %5.2f hours\n", daylen );
            //printf( "With civil twilight         %5.2f hours\n", civlen );
            //printf( "With nautical twilight      %5.2f hours\n", nautlen );
            //printf( "With astronomical twilight  %5.2f hours\n", astrlen );
            //printf( "Length of twilight: civil   %5.2f hours\n",
            //      (civlen-daylen)/2.0);
            //printf( "                  nautical  %5.2f hours\n",
            //      (nautlen-daylen)/2.0);
            //printf( "              astronomical  %5.2f hours\n",
            //      (astrlen-daylen)/2.0);

#if TRACE
            printf("Computing sunrise and sunset\n");
#endif
            rs   = sun_rise_set         ( year, month, day, lon, lat,
                                          &rise, &set );
            /* using the precise algorithm to compute twilights is overkill, but
               it helps checking this algorithm. */
#if TRACE
            printf("Computing civil twilight\n");
#endif
            civ  = civil_twilight       ( year, month, day, lon, lat,
                                          &civ_start, &civ_end );
#if TRACE
            printf("Computing nautical twilight\n");
#endif
            naut = nautical_twilight    ( year, month, day, lon, lat,
                                          &naut_start, &naut_end );
#if TRACE
            printf("Computing astronomical twilight\n");
#endif
            astr = astronomical_twilight( year, month, day, lon, lat,
                                          &astr_start, &astr_end );

            printf("%4d-%02d-%02d\n", year, month, day);
            format_hour((rise+set)/2.0, buf);
            printf( "Sun at south %s UT\n", buf );

            switch( rs )
            {
                case 0:
		  format_hour(rise, bufr);
		  format_hour(set , bufs);
                    printf( "                   Sun rises %s, sets %s UT\n",
                             bufr, bufs );
                    break;
                case +4:
                    printf( "Sun above horizon\n" );
                    break;
                case -4:
                    printf( "Sun below horizon\n" );
                    break;
		default:
		    printf("Sunrise/sunset: transition case %d\n", rs);
                    break;
            }

            switch( civ )
            {
                case 0:
		  format_hour(civ_start, bufr);
		  format_hour(civ_end  , bufs);
                    printf( "       Civil twilight starts %s, "
                            "ends %s UT\n", bufr, bufs );
                    break;
                case +4:
                    printf( "Never darker than civil twilight\n" );
                    break;
                case -4:
                    printf( "Never as bright as civil twilight\n" );
                    break;
		default:
		    printf("Civil twilight: transition case %d\n", rs);
                    break;
            }

            switch( naut )
            {
                case 0:
		  format_hour(naut_start, bufr);
		  format_hour(naut_end  , bufs);
                    printf( "    Nautical twilight starts %s, "
                            "ends %s UT\n", bufr, bufs );
                    break;
                case +4:
                    printf( "Never darker than nautical twilight\n" );
                    break;
                case -4:
                    printf( "Never as bright as nautical twilight\n" );
                    break;
		default:
		    printf("Nautical twilight: transition case %d\n", rs);
                    break;
            }

            switch( astr )
            {
                case 0:
		  format_hour(astr_start, bufr);
		  format_hour(astr_end  , bufs);
                    printf( "Astronomical twilight starts %s, "
                            "ends %s UT\n", bufr, bufs );
                    break;
                case +4:
                    printf( "Never darker than astronomical twilight\n" );
                    break;
                case -4:
                    printf( "Never as bright as astronomical twilight\n" );
                    break;
		default:
		    printf("Astronomical twilight: transition case %d\n", rs);
                    break;
            }
      }
}


/* The "workhorse" function for sun rise/set times */

int __sunriset__( int year, int month, int day, double lon, double lat,
                  double altit, int upper_limb, double *trise, double *tset )
/***************************************************************************/
/* Note: year,month,date = calendar date, 1801-2099 only.             */
/*       Eastern longitude positive, Western longitude negative       */
/*       Northern latitude positive, Southern latitude negative       */
/*       The longitude value IS critical in this function!            */
/*       altit = the altitude which the Sun should cross              */
/*               Set to -35/60 degrees for rise/set, -6 degrees       */
/*               for civil, -12 degrees for nautical and -18          */
/*               degrees for astronomical twilight.                   */
/*         upper_limb: non-zero -> upper limb, zero -> center         */
/*               Set to non-zero (e.g. 1) when computing rise/set     */
/*               times, and to zero when computing start/end of       */
/*               twilight.                                            */
/*        *rise = where to store the rise time                        */
/*        *set  = where to store the set  time                        */
/*                Both times are relative to the specified altitude,  */
/*                and thus this function can be used to compute       */
/*                various twilight times, as well as rise/set times   */
/* Return value:  It is a composite value of two return values, one for sunrise
 *                    (or morning twilight) and the other for sunset (or evening twilight).
 *                0, +3, -3 applies to the morning,
 *                0, +1, -1 applies to the evening.
 *                0 = sun rises/sets this day, time stored at         */
/*                    *trise and *tset.                               */
/*           +3, +1 = sun above the specified "horizon" 24 hours.     */
/*                    *trise set to time when the sun is at south,    */
/*                    minus 12 hours while *tset is set to the south  */
/*                    time plus 12 hours. "Day" length = 24 hours     */
/*           -3, -1 = sun is below the specified "horizon" 24 hours   */
/*                    "Day" length = 0 hours, *trise and *tset are    */
/*                    both set to the time when the sun is at south.
 *                So the composite values are:
 *                0 = the most common day+night situation
 *               -4 = polar night, the sun neither rises nor sets, staying below the horizon
 *               +4 = polar day, the sun neither rises nor sets, staying above the horizon
 *               +3 = transition from day+night to polar day, the sun rises but does not set
 *               +1 = transition from polar day to day+night, the sun does not rise, but sets
 *               For location with a very high latitude:
 *               -2 = transition from polar night to polar day, the day+night period lasting less than 12 hours
 *               +2 = transition from polar day to polar night, the day+night period lasting less than 12 hours
 *               I do not see how these could appear, since we use days centered on noon, with sunrise before sunset:
 *               -3 = transition from polar night to day+night, the sun does not rise (staying below the horizon) but sets
 *               -1 = transition from day+night to polar night, the sun rises but does not sets (staying below the horizon)
 *
 **********************************************************************/
{
      double  d,  /* Days since 2000 Jan 0.0 (negative before) */
      sr,         /* Solar distance, astronomical units */
      sRA,        /* Sun's Right Ascension */
      sdec,       /* Sun's declination */
      sradius,    /* Sun's apparent radius */
      t,          /* Diurnal arc */
      tsouth,     /* Time when Sun is at south */
      sidtime,    /* Local sidereal time */
      delta,      /* Difference of *trise or *tset between an iteration and the next */
      altit1;     /* Altitude of the center of the solar disk */

      int rc_r = 0; /* Return cde from sunrise computation - usually 0 */
      int rc_s = 0; /* Return cde from sunset  computation - usually 0 */
      int nb;       /* Number of iterations */

      char buffer[30], buffersouth[30];

      /**** Computing sunrise time ****/
      /* Compute d of 12h local mean solar time */
      d = days_since_2000_Jan_0(year,month,day) + 0.5 - lon/360.0;
      *trise = 12;
      delta  = 99.0;
      altit1 = altit;

      for (nb = 0; nb < ITERMAX && delta > EPSILON; nb++) {
#if TRACE
        format_hour(tsouth, buffersouth);
        format_hour(*trise, buffer);
        printf("Iteration %2d using altit = %10.7f, tsouth = %s *trise = %s, delta = %10.7f\n", nb, altit1, buffersouth, buffer, delta);
#endif
	/* Compute the local sidereal time of this moment */
	sidtime = revolution( GMST0(d + (*trise - 12) / 24) + 180.0 + lon );

	/* Compute Sun's RA, Decl and distance at this moment */
	sun_RA_dec( d + (*trise - 12) / 24, &sRA, &sdec, &sr );

        /* Compute time when Sun is at south - in hours UT */
        tsouth = 12.0 - (sidtime - sRA)/15.0;

	/* Compute the Sun's apparent radius in degrees */
	sradius = 0.2666 / sr;

        /* Do correction to upper limb, if necessary */
        if ( upper_limb )
          altit1 = altit - sradius;
        else
          altit1 = altit;

	/* Compute the diurnal arc that the Sun traverses to reach */
	/* the specified altitude altit: */
	{
	      double cost;
	      cost = ( sind(altit) - sind(lat) * sind(sdec) ) /
		    ( cosd(lat) * cosd(sdec) );
	      if ( cost >= 1.0 )
		    rc_r = -1, t = 0.0;       /* Sun always below altit */
	      else if ( cost <= -1.0 )
		    rc_r = +1, t = 12.0;      /* Sun always above altit */
	      else
		    t = acosd(cost)/15.04107;   /* The diurnal arc, hours */
	}

        /* How much did we progress? */
        delta  = fabs(tsouth - t - *trise);

	/* Store rise and set times - in hours UT */
	*trise = tsouth - t;

      }
#if TRACE
      format_hour(tsouth, buffersouth);
      format_hour(*trise, buffer);
      printf("Iteration %2d using altit = %10.7f, tsouth = %s *trise = %s, delta = %10.7f\n", nb, altit1, buffersouth, buffer, delta);
#endif
      if (nb >= ITERMAX)
        printf("Not converging\n");

      /**** Computing sunset time ****/
      /* Compute d of 12h local mean solar time */
      d      = days_since_2000_Jan_0(year,month,day) + 0.5 - lon/360.0;
      *tset  = 12;
      delta  = 99.0;
      altit1 = altit;

      for (nb = 0; nb < ITERMAX && delta > EPSILON; nb++) {

#if TRACE
        format_hour(tsouth, buffersouth);
        format_hour(*tset, buffer);
        printf("Iteration %2d using altit = %10.7f, tsouth = %s *tset = %s, delta = %10.7f\n", nb, altit1, buffersouth, buffer, delta);
#endif
	/* Compute the local sidereal time of this moment */
	sidtime = revolution( GMST0(d + (*tset - 12) / 24) + 180.0 + lon );

	/* Compute Sun's RA, Decl and distance at this moment */
	sun_RA_dec( d + (*tset - 12) / 24, &sRA, &sdec, &sr );

        /* Compute time when Sun is at south - in hours UT */
        tsouth = 12.0 - (sidtime - sRA)/15.0;

	/* Compute the Sun's apparent radius in degrees */
	sradius = 0.2666 / sr;

	/* Do correction to upper limb, if necessary */
        if ( upper_limb )
          altit1 = altit - sradius;
        else
          altit1 = altit;

	/* Compute the diurnal arc that the Sun traverses to reach */
	/* the specified altitude altit: */
	{
	      double cost;
	      cost = ( sind(altit) - sind(lat) * sind(sdec) ) /
		    ( cosd(lat) * cosd(sdec) );
	      if ( cost >= 1.0 )
		    rc_s = -1, t = 0.0;       /* Sun always below altit */
	      else if ( cost <= -1.0 )
		    rc_s = +1, t = 12.0;      /* Sun always above altit */
	      else
		    t = acosd(cost)/15.04107;   /* The diurnal arc, hours */
	}

        /* How much did we progress? */
        delta  = fabs(tsouth + t - *tset);

	/* Store rise and set times - in hours UT */
	*tset  = tsouth + t;
      }
#if TRACE
      format_hour(tsouth, buffersouth);
      format_hour(*tset, buffer);
      printf("Iteration %2d using altit = %10.7f, tsouth = %s *tset = %s, delta = %10.7f\n", nb, altit1, buffersouth, buffer, delta);
#endif
      if (nb >= ITERMAX)
        printf("Not converging\n");

      return 3 * rc_r + rc_s;
}  /* __sunriset__ */



/* The "workhorse" function */


double __daylen__( int year, int month, int day, double lon, double lat,
                   double altit, int upper_limb )
/**********************************************************************/
/* Note: year,month,date = calendar date, 1801-2099 only.             */
/*       Eastern longitude positive, Western longitude negative       */
/*       Northern latitude positive, Southern latitude negative       */
/*       The longitude value is not critical. Set it to the correct   */
/*       longitude if you're picky, otherwise set to to, say, 0.0     */
/*       The latitude however IS critical - be sure to get it correct */
/*       altit = the altitude which the Sun should cross              */
/*               Set to -35/60 degrees for rise/set, -6 degrees       */
/*               for civil, -12 degrees for nautical and -18          */
/*               degrees for astronomical twilight.                   */
/*         upper_limb: non-zero -> upper limb, zero -> center         */
/*               Set to non-zero (e.g. 1) when computing day length   */
/*               and to zero when computing day+twilight length.      */
/**********************************************************************/
{
      double  d,  /* Days since 2000 Jan 0.0 (negative before) */
      obl_ecl,    /* Obliquity (inclination) of Earth's axis */
      sr,         /* Solar distance, astronomical units */
      slon,       /* True solar longitude */
      sin_sdecl,  /* Sine of Sun's declination */
      cos_sdecl,  /* Cosine of Sun's declination */
      sradius,    /* Sun's apparent radius */
      t;          /* Diurnal arc */

      /* Compute d of 12h local mean solar time */
      d = days_since_2000_Jan_0(year,month,day) + 0.5 - lon/360.0;

      /* Compute obliquity of ecliptic (inclination of Earth's axis) */
      obl_ecl = 23.4393 - 3.563E-7 * d;

      /* Compute Sun's ecliptic longitude and distance */
      sunpos( d, &slon, &sr );

      /* Compute sine and cosine of Sun's declination */
      sin_sdecl = sind(obl_ecl) * sind(slon);
      cos_sdecl = sqrt( 1.0 - sin_sdecl * sin_sdecl );

      /* Compute the Sun's apparent radius, degrees */
      sradius = 0.2666 / sr;

      /* Do correction to upper limb, if necessary */
      if ( upper_limb )
            altit -= sradius;

      /* Compute the diurnal arc that the Sun traverses to reach */
      /* the specified altitude altit: */
      {
            double cost;
            cost = ( sind(altit) - sind(lat) * sin_sdecl ) /
                  ( cosd(lat) * cos_sdecl );
            if ( cost >= 1.0 )
                  t = 0.0;                      /* Sun always below altit */
            else if ( cost <= -1.0 )
                  t = 24.0;                     /* Sun always above altit */
            else  t = (2.0/15.0) * acosd(cost); /* The diurnal arc, hours */
      }
      return t;
}  /* __daylen__ */


/* This function computes the Sun's position at any instant */

void sunpos( double d, double *lon, double *r )
/******************************************************/
/* Computes the Sun's ecliptic longitude and distance */
/* at an instant given in d, number of days since     */
/* 2000 Jan 0.0.  The Sun's ecliptic latitude is not  */
/* computed, since it's always very near 0.           */
/******************************************************/
{
      double M,         /* Mean anomaly of the Sun */
             w,         /* Mean longitude of perihelion */
                        /* Note: Sun's mean longitude = M + w */
             e,         /* Eccentricity of Earth's orbit */
             E,         /* Eccentric anomaly */
             x, y,      /* x, y coordinates in orbit */
             v;         /* True anomaly */

      /* Compute mean elements */
      M = revolution( 356.0470 + 0.9856002585 * d );
      w = 282.9404 + 4.70935E-5 * d;
      e = 0.016709 - 1.151E-9 * d;

      /* Compute true longitude and radius vector */
      E = M + e * RADEG * sind(M) * ( 1.0 + e * cosd(M) );
            x = cosd(E) - e;
      y = sqrt( 1.0 - e*e ) * sind(E);
      *r = sqrt( x*x + y*y );              /* Solar distance */
      v = atan2d( y, x );                  /* True anomaly */
      *lon = v + w;                        /* True solar longitude */
      if ( *lon >= 360.0 )
            *lon -= 360.0;                   /* Make it 0..360 degrees */
}

void sun_RA_dec( double d, double *RA, double *dec, double *r )
/******************************************************/
/* Computes the Sun's equatorial coordinates RA, Decl */
/* and also its distance, at an instant given in d,   */
/* the number of days since 2000 Jan 0.0.             */
/******************************************************/
{
      double lon, obl_ecl, x, y, z;

      /* Compute Sun's ecliptical coordinates */
      sunpos( d, &lon, r );

      /* Compute ecliptic rectangular coordinates (z=0) */
      x = *r * cosd(lon);
      y = *r * sind(lon);

      /* Compute obliquity of ecliptic (inclination of Earth's axis) */
      obl_ecl = 23.4393 - 3.563E-7 * d;

      /* Convert to equatorial rectangular coordinates - x is unchanged */
      z = y * sind(obl_ecl);
      y = y * cosd(obl_ecl);

      /* Convert to spherical coordinates */
      *RA = atan2d( y, x );
      *dec = atan2d( z, sqrt(x*x + y*y) );

}  /* sun_RA_dec */


/******************************************************************/
/* This function reduces any angle to within the first revolution */
/* by subtracting or adding even multiples of 360.0 until the     */
/* result is >= 0.0 and < 360.0                                   */
/******************************************************************/

#define INV360    ( 1.0 / 360.0 )

double revolution( double x )
/*****************************************/
/* Reduce angle to within 0..360 degrees */
/*****************************************/
{
      return( x - 360.0 * floor( x * INV360 ) );
}  /* revolution */

double rev180( double x )
/*********************************************/
/* Reduce angle to within +180..+180 degrees */
/*********************************************/
{
      return( x - 360.0 * floor( x * INV360 + 0.5 ) );
}  /* revolution */


/*******************************************************************/
/* This function computes GMST0, the Greenwich Mean Sidereal Time  */
/* at 0h UT (i.e. the sidereal time at the Greenwhich meridian at  */
/* 0h UT).  GMST is then the sidereal time at Greenwich at any     */
/* time of the day.  I've generalized GMST0 as well, and define it */
/* as:  GMST0 = GMST - UT  --  this allows GMST0 to be computed at */
/* other times than 0h UT as well.  While this sounds somewhat     */
/* contradictory, it is very practical:  instead of computing      */
/* GMST like:                                                      */
/*                                                                 */
/*  GMST = (GMST0) + UT * (366.2422/365.2422)                      */
/*                                                                 */
/* where (GMST0) is the GMST last time UT was 0 hours, one simply  */
/* computes:                                                       */
/*                                                                 */
/*  GMST = GMST0 + UT                                              */
/*                                                                 */
/* where GMST0 is the GMST "at 0h UT" but at the current moment!   */
/* Defined in this way, GMST0 will increase with about 4 min a     */
/* day.  It also happens that GMST0 (in degrees, 1 hr = 15 degr)   */
/* is equal to the Sun's mean longitude plus/minus 180 degrees!    */
/* (if we neglect aberration, which amounts to 20 seconds of arc   */
/* or 1.33 seconds of time)                                        */
/*                                                                 */
/*******************************************************************/

double GMST0( double d )
{
      double sidtim0;
      /* Sidtime at 0h UT = L (Sun's mean longitude) + 180.0 degr  */
      /* L = M + w, as defined in sunpos().  Since I'm too lazy to */
      /* add these numbers, I'll let the C compiler do it for me.  */
      /* Any decent C compiler will add the constants at compile   */
      /* time, imposing no runtime or code overhead.               */
      sidtim0 = revolution( ( 180.0 + 356.0470 + 282.9404 ) +
                          ( 0.9856002585 + 4.70935E-5 ) * d );
      return sidtim0;
}  /* GMST0 */

/*
 * Format an hour value to show both its value as decimal hours and its value as hours:minutes:seconds
 * The input buffer should be large enough: 10 chars for the decimal value, 1 space, 8 chars for the hh:mm:ss value.
 * and 1 for the end null byte. But in case the value is negative, add 1 chars for the minus signs, so we arrive at 22
 * So with 25 chars, it should be enough.
 */
void format_hour(double t, char buf[])
{
  double t1 = t;
  int hh, mm, ss;
  hh  = floor(t1);
  t1 -= hh;
  t1 *= 60.0;
  mm  = floor(t1);
  t1 -= mm;
  t1 *= 60.0;
  ss  = floor(t1);

  if (fabs(t) > 100) {
    sprintf(buf, "*********");
  }
  else {
    sprintf(buf, "%10.7f %02d:%02d:%02d", t, hh, mm, ss);
  }
}
