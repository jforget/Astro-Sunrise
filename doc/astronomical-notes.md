# Document Status

This text is published under the _Creative Commons_ license
CC-BY-ND.

Copyright (c) 2017-2023 Jean Forget. All rights reserved.

I must precise that I am not a professional astronomer. The text
below may contain errors, be aware of this. I will not be held
responsible for any consequences of your reading of this text.
The "NO WARRANTY" paragraphs from the GPL and the Artistic License
apply not only to Perl code, but also to English (and French)
texts.

The text is often (but irregularly) updated on Github. There are
a French version and an English version. Since I am more at ease
discussing astronomical subjects in French, the English version
will lag behind the French one.

This text is an integral part of the module's distribution package.
So you can read it on web pages generated from CPAN
(for example [https://metacpan.org](https://metacpan.org)).
But it is not used during the module installation process.
So, I guess it will not appear in `.deb` or `.rpm` packages.

Although this text  is stored in the  [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise) repository, it
also  documents the  [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise) module,  which has  a
very  similar core  (astronomical computations)  and a  different API.
Since both  modules move at different  speeds, it may happen  that the
text you  are reading is  not synchronised with  the [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise)
module.

During spring  2022, there  has been some  problems with  Github's POD
converter. So I have decided to convert this text to Markdown. Now POD
version is  no longer maintained,  even if Github's POD  converter has
been fixed. So, please refer to the Markdown version.

# Why This Text? For Whom?

The main purpose of this text is to explain how the sunrises
and sunsets are computed. These explanations are much too long
to be included into the module's POD section.

## For Whom? For My Teddy Bear

Have you read
[brian's Guide to Solving Any Perl Problem](http://www252.pair.com/~comdog/brian&#x27;s_guide.pod)?
While most advices deal with debugging Perl code, a few advices have
a broader scope and apply to any intellectual problem.
One of these advices consists in "talking to the teddy-bear".
And do not pretend to talk while just forming sentences in your
mind. You must really talk in a clear voice in front of your
teddy-bear, with syntactically correct sentences.
Actually, in the present case, the topic is so big that I skipped to the next level and
I prefer writing (on GitHub) for my teddy-bear.

I write this text to tell my teddy-bear which problems I have
encountered while maintaining this module and how I fixed them.
But mainly, I write this to give him a detailed description of the
precise iterative algorithm, because
[Paul Schlyter's explanations](https://www.stjarnhimlen.se/comp/riset.html#3)
are not detailed enough for my taste and there is no
compilable source available to check this algorithm (unlike the
[simple version without iteration](https://www.stjarnhimlen.se/comp/sunriset.c)).

## For Whom? For The Next Module Maintainer

Actually, my teddy-bear understands French, so the present
English version is not for him.
The second person for whom I write is the next module maintainer. I have read
[Neil Bowers' message](http://codeverge.com/perl.module-authors/the-module-authors-pledge/744969)
about _the module authors pledge_. I agree with him and I declare that
should I stop maintaining my modules for whatever reason, I accept that
any volunteer can take charge of them.

What Neil did not explain, is that the new maintainer must obey a few
criteria and must have three available resources to take over a module maintenance:
be competent in Perl programming, have enough available time to work on
the module and be enthusiastic enough to get around to it.

In the case of astronomical module, the competence in Perl programming is
not enough, you must also be competent in astronomy. So, if you think you might
maintain this module, first read the present text. If you understand why I bother
about such and such question, if you can follow my train of thought without being
lost, then you are competent enough. If you think I am playing
[Captain Obvious](https://tvtropes.org/pmwiki/pmwiki.php/Main/CaptainObvious)
and if you have instant answers to my questions, then you are the ideal
person that could maintain this module. If you do not understand what all
this is about, and if sines and cosines put you off, do not consider
working on this module's innards.

## For Whom? For Bug Reporters

This text is also for those who think they have found a bug
in the module or who want to offer an idea to improve the module.
Maybe the bug is already known and is waiting for a fix.
Maybe the bug was found and the fix is not successful. Maybe
the proposed improvement contradicts some other functionality
of the module.

## For Whom? For Curious Users

Lastly, this text is aimed at any person curious enough to learn
a few astronomical facts. I tried to steer away from overly complicated
computations. Their place is in the Perl source, not in this text.
Yet, you will find here simple computations and mathematical reasoning.

## Remarks About The Style

Some chunks of this text appear as a series of questions and answers.
This is not a FAQ. Rather, this is a elegant way to give a progressive
explanation of some subject. This method has already been used by
many other writers, especially Plato, Galileo and Douglas Hofstadter.

## Other Remarks

In my explanations, I usually take the point of view of a person living
in the Northern hemisphere, between the Tropic of Cancer and the Arctic Circle.
For example, I will write that at noon, the sun is located exactly southward,
although any schoolboy from Australia, New Zealand, South Africa, Argentina
and similar countries perfectly knows that at noon, the sun is northward.

In a similar way, 21st of March is called the _vernal equinox_ or the
_spring equinox_, even if it pinpoints the beginning of autumn in the Southern
hemisphere.

But using politically correct sentences would yield convoluted phrases,
which hinders the pedagogical purpose of the text and the understanding
of the described phenomena.

About minutes and seconds: the problem is that minutes and seconds are both
angular units (for longitudes and latitudes) and time units (for instants
and for durations). I have adopted three different formats to help distinguish
between these cases: `12:28:35` for time instants, `2 h 28 mn 35 s` for
time durations and `59° 28' 35"` for angles (latitudes, longitudes and others).
So, even if the hour-part or the degree-part is missing, you will be able
to distinguish between a `28' 35"` angle and a `28 mn 35 s` duration.

# Sources

I will give here only the sources that provide lists of numerical values.
Books and articles with only a literary description of the subject are too
many to be listed here.

## Unused Sources

Some sources provide a list of sunsets and sunrises, but I did not use
them because they do not explain which algorithm they use or because
I cannot control the parameters.

- The _Almanach Du Facteur_

    In France, it is (or rather it was) customary to buy almanachs from the postman
    each year. In each almanach, you find a page giving the sunrise and sunset times
    for all the days of the year. Unfortunately, the times are given in HH:MM syntax, not
    including the seconds. In addition, even if you buy a provincial edition, the
    sunrise and sunset times are given for Paris. Lastly, the algorithm is not
    specified.

- The _Institut de Mécanique Céleste et de Calcul des Éphémérides_ (IMCCE, Institute of Celestial Mechanics and Ephemerides Computation)

    This [website](https://www.imcce.fr/)
    (also available in English)
    used to give an HTML form to generate a table giving the sunrise and sunset times
    for a location and a time span  of your choosing. Unfortunately, this webpage
    disappeared.

    There is an available
    [webservice](http://vo.imcce.fr/webservices/miriade/?rts)
    to give the same functionality, but I did not try it.

## Used Sources

- Paul Schlyter's Website

    This [site](https://www.stjarnhimlen.se/english.html)
    provides a
    [C program](https://stjarnhimlen.se/comp/sunriset.c)
    ready to compile and use, giving the
    [sunrise and sunset](https://stjarnhimlen.se/comp/riset.html)
    times. This is the basis of the simple algorithm used in
    [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise). Its precision, as stated by the author,
    is one or two minutes, but it can be much less precise depending
    on the location and date, especially when we are close to the
    beginning or the end of the period when the midnight sun is visible.

    Paul Schlyter's website includes also
    [many informations](https://stjarnhimlen.se/comp/ppcomp.html)
    about computing the position of various celestial bodies.
    This website is very interesting, but I preferred writing
    my own version, describing the computation of only the sun
    and not bothering with other celestial bodies.

- The U.S Naval Observatory

    [The US Naval Observatory](http://aa.usno.navy.mil/faq/index.php)
    gives a
    [HTML form](http://aa.usno.navy.mil/data/docs/RS_OneYear.php)
    to compute the sunrise and sunset times. These times are given
    in HH:MM format. I would have preferred HH:MM:SS, but I will have
    to deal with just HH:MM.

    This website gives also
    [very interesting informations](http://aa.usno.navy.mil/faq/index.php)
    about celestial computations, but without restricting itself to the sun,
    like I am doing here.

- The NOAA solar calculator

    [The NOAA's Earth System Research Laboratories](https://www.esrl.noaa.gov/)
    provide a
    [solar calculator](https://www.esrl.noaa.gov/gmd/grad/solcalc/)
    similar to the USNO.

- Stellarium

    Stellarium is a PC app to simulate a night sky. If you do not bother with
    the main view giving a real time sky simulation, you can use it to obtain
    the coordinates of a given celestial body at a given time when seen from
    a given Earth location. Here is how you can determine the time
    of sunrise, sunset or true solar noon (version 0.18.0).

    - Choose an approximate value for the requested time: 12:00 for
    the true solar noon or use [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise) (basic mode) for
    sunrise or sunset.
    - Choose the search criterion: azimuth equal to 180° for true
    solar noon or real altitude equal to 0 degrees and _xx_
    minutes below the horizon. _xx_ must be compatible with the
    `altitude` parameter of [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise)'s functions.

        Note: we do not use the _apparent_ altitude given by Stellarium.
        For the deviation angle of sun rays near the horizon, we use
        [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise)'s value, which is 35' or 0.583 degree and
        we aim at this value in Stellarium. And if we want to take into
        account the radius of the sun's disk, we will use the average value 15'
        instead of recomputing the precise value depending on the
        Earth-Sun distance. In this case, we will aim at a 50' altitude
        below the horizon, that is, 0.833 degree.

    - In Stellarium, freeze the time with `7` unless already frozen.
    - Look for the Sun. The search window is activated by `<F3>`.
    - You may prefer a display without the ground and without the atmosphere.
    Use the flip-flops `g` and `a`. And `e` or `z` to display or
    to hide the equatorial and azimutal grids, acording to
    your current taste.

        By the way, when the atmosphere is deactivated, Stellarium no longer
        displays the apparent coordinates of the Sun. So the choice above, using
        the _real_ Sun altitude and not its _apparent_ altitude is justified.

    - Press `<F6>` to specify the observation location. With a location
    on the Greenwich meridian, the UTC time will coincide with the
    mean solar time. Do not forget to tick the personalised time zone check
    box and to select UTC.

        In version 0.18.0, use "Royal Observatory (Greenwich)". In the
        previous version, I entered a location at 51° 28' 40" N, 5" E and
        a height of 27 m. The longitude and latitude are the values given by
        Wikipedia for the Greenwich Observatory and the height is nothing more
        than the previously entered height. This has no relation with the
        observatory's real height, or this is a lucky coincidence.

    - Press `<F5>` to specify date and time.
    - While keeping the date-time windows opened, try several
    time values until you get the best approximation of the
    target azimut or of the target altitude.

    Note: on the previous version I used before 0.18.0, the timezone was
    not a property of the observation location, it was a global
    application configuration parameter. I had to hit `<F2>` to open
    the configuration menu. In this menu, I selected the `Plugins` tab,
    then `Time zone`. With this, I selected a UTC display instead of a
    display using the computer's local timezone.

# Heliocentrism Or Geocentrism?

Here are two assertions. Are they true of false?

- A

    The Sun goes around the Earth.

- B

    The Earth goes around the Sun.

Assertion A is false, everyone agrees. But assertion B is false too.

Oh yes indeed, will you answer, it should read actually:

- C

    The Earth runs along an elliptic orbit with the Sun located on
    one focus of the ellipse.

This assertion is false too. Each one of the following assertions
is nearer to the truth than assertions B and C (and A).

- D

    The center of mass of the Earth-Moon binary system runs along an
    elliptic orbit with the center of mass of the Solar System located
    on a focus of the ellipse.

    And I will point that the center of mass of the Sun is not the same
    as the center of mass of the Solar System. There are even times when
    the center of mass of the Solar System is _outside_ the surface of the Sun.
    The [webpage](http://hp41programs.yolasite.com/solar-sys-bary.php)
    about an HP-41 program states that on 15th March 1983, the distance between
    both centers of mass was nearly 2.1 Sun radii.

- E

    The Earth runs along an orbit around the Sun, with noticeable perturbations
    caused by the Moon, Jupiter, Saturn, etc.

    Which is a formulation equivalent to assertion D.

- F

    The movement of the Earth with the Solar System is a _n_-body problem,
    with _n_ ≥ 3. Therefore, there is no analytical solution.

- G

    The Solar System is a chaotic system. Even if we can predict with a reasonable
    accuracy what the various orbits will look like within the next hundred million
    years, this prediction is no longer possible for an interval of one milliard years
    (one billion years for US).

- H

    The Earth corkscrews in the general direction of the Hercules constellation
    with a approximate speed of 220 km/s.

- I

    The Earth runs along an orbit around the center of the Milky Way, with noticeable
    perturbations caused by the Sun, the Moon, Jupiter, Saturn, etc.

Assertions B and C are what Terry Pratchett, Jack Cohen and Ian Stewart call
_lies to children_ (_Science of Discworld_, chapter 4, pages 38 and 39). These
are false assertions, but simple enough to be understood by a child and which, even
if false, lead children to a better understanding of the described phenomena and bring
them closer to truth. You cannot tell assertion C to a child and expect him to understand
it without telling him first assertion B. And it is worse with assertions D and next.

Moreover, these are what I would call _lies to adults_. In the beginning, people would consider that
the aim of Physics was to build a mathematical representation of the real world,
getting closer and closer to the ultimate truth. Then, there was quantum physics
including especially de Broglie's work
with the duality of wave and particle and the Copenhagen interpretation. Is the ultimate
nature of the electron (for example) a wave? No. Is it a particle? No. So what? We do not
care about the ultimate nature of the electron. The aim of Physics is to no longer
to provide a mathematical _representation_ of the real world, but to build
several mathematical _models_ of the real world. We know that intrinsically all
models are false, but each one has its usefulness to make computations about
the real world.

Please note that I was talking about scientific methods. I was not dealing with
electoral campaigns and advertisements. Every sane adult knows for
sure that these are ridden with lies.

Other lies to adults, also known as "simplifying
hypotheses", you will find in the following:

- the light propagates instantly from one place to another,
- the celestial bodies outside the Solar System are motionless,
- they are located on a sphere call the _Celestial Sphere_,
- UTC time is equal to GMT time
- the Earth's surface is a perfect sphere, without any polar flattening and without any equatorial bulge,
- the Earth's surface is a perfect sphere, without any mountains, valleys or molehills,
- there is even a place in this text where I imply that the duration of
an astronomical year is an integer number of days (365, of course),
- and, as I have already stated, all interesting locations
on Earth are between the Tropic of Cancer and the Arctic Circle.

In some paragraphs, I will temporarily set aside some of these lies. But in most
paragraphs most of these lies will be in effect.

## Intermediate Conclusion

All this to explain that in the following text, I will not refrain from using
the geocentric model where the Sun turns around the Earth in 24 hours or the
geocentric model where the Sun turns around the Earth in 365.25 days.

"It is not necessary that the following hypothesis be true or even
resemble the truth. One thing is for sure that they provide calculations
in accordance with the actual observations"

Excerpt from Osiander's preface to Copernic's book. This excerpt was reused
by Jean-Pierre Petit as a foreword to
[Cosmic Story](https://www.savoir-sans-frontieres.com/JPP/telechargeables/English/cosmic_story_anglo_indien/cosmic_story_en.html).
In Copernic's time, Osiander wanted to have heliocentrism accepted
by people who were certain that geocentrism was the one and only truth.
It is ironical that I use the same quotation to have geocentrism accepted
by people who believe that heliocentrism is the one and only truth.

# Earth / Sun Movements

## Basic Movements

In an heliocentric system pointing at fixed stars, Earth orbits around
the Sun in one  year. In other words, in a  geocentric system, the Sun
orbits around the  Earth in one year, with an  average speed of 0.9856
degrees per day or 0.04107 degrees per hour.

Also, the Earth  spins around itself, making one turn  in 23h 56mn 4s,
with a speed of 4.178e-3 degrees per second, that is, 360.9856 degrees
per day or 15.04107 degrees per hour.

Q: I thought that the Earth was spinning in 24h!

A: While the Earth spins, the Sun orbits around it. And what we see is
the combination of both movements, which gives a combined speed of 360 degrees per day on average.
What the commoner is interested in is to find the Sun at the same place in the
sky at regular times day after day.  Only after this is achieved, the commoner
becomes a learned person and is interested in knowing and understanding the
positions of the Moon, the stars and the planets.

Q: And why did you say "average" two or three times?

A: Because the angular speed of the Sun is not constant.  We will get back
to this question later.

## Coordinates

The ecliptic is the plane where the Earth's orbit around the Sun is located (when
using an heliocentric model) or where the Sun's orbit around the Earth is
located (when using a geocentric model). We define also the equatorial plane,
the plane which contains the Earth's equator. These two planes intersect with
a 23° 26' angle. The intersection is a line, named _line of nodes_.
In some cases, it is more convenient to use a half-line than a line.
In this case, the line of nodes is a half line starting at the Earth center
and aiming at the Pisces constellation.
The point where the line of nodes meets the celestial sphere is called
_vernal point_ (which is politically incorrect, this is the beginning of
autumn in the southern hemisphere).

For a point on Earth, we generally use longitude and latitude. We start from
an origin in the Gulf of Guinea, where the Greenwich meridian meets the equator.
Then  we move along the equator in a first arc and along a meridian in a second arc
to reach the point. The angle of the first arc is the longitude, the angle of the
second arc is the latitude for a point on the ground. But when we consider a celestial body, the
first angle is counted from the line of nodes instead of the Gulf
of Guinea and is called _right ascension_; the second angle is called _declination_.
Because of tradition, an old charter or something,
the right ascension is usually expressed as hours, minutes and seconds instead of
degrees. The declination still uses degrees. And Paul Schlyter's program uses
decimal degrees for the right ascension, like any other angle.

_Ecliptic coordinates_ follow the same principle, but the first arc is drawn
along the ecliptic instead of the equator. Likewise, the second arc is perpendicular
to the ecliptic. These angles are named _ecliptic longitude_ and _ecliptic latitude_
respectively. The ecliptic longitude is counted from the same origin as the
right ascension: the line of nodes. That simplifies a little bit the conversions
between the two systems of coordinates. On the other hand, the use of hours, minutes
and seconds for the right ascension and of degrees for all other angles
is an unnecessary complication in the conversions.

Because of the definition of the ecliptic plane, the ecliptic latitude of the
sun is always zero.

Lastly, there is the local coordinate system. For a given celestial body, we
project its location to the ground, or rather to the plane that is tangent to
the ground. The angle between the North and this location on the tangent plane
is called _azimuth_ and the angle between the tangent plane and the line to the
celestial body is called _altitude_.

### Sidereal Time

The sidereal time is an ambivalent notion.
People are divided into two categories, those
who describe it as an angle,
and those who describe it as a time. Strangely,
there is no flame war about these diverging
attitudes, each category of people seeming to ignore
"the other side".

In the first category, people consider that despite its name, the
sidereal time is an angle. See these French webpages:
[https://fr.wikipedia.org/wiki/Temps\_sid%C3%A9ral](https://fr.wikipedia.org/wiki/Temps_sid%C3%A9ral)
[https://www.futura-sciences.com/sciences/definitions/univers-temps-sideral-960/](https://www.futura-sciences.com/sciences/definitions/univers-temps-sideral-960/)
[http://users.skynet.be/zmn/docs/temps/TempsSideral2.html](http://users.skynet.be/zmn/docs/temps/TempsSideral2.html)
[https://astrochinon.fr/index.php/documents/nos-dossiers/95-le-temps-sideral-de-greenwich](https://astrochinon.fr/index.php/documents/nos-dossiers/95-le-temps-sideral-de-greenwich).
Even if this notion is measured with hours, minutes
and seconds, this is an angle. After all, the right ascension
also is measured with hours, minutes and seconds and it is
still an angle.

Paul Schlyter is definetely in this category. He even
defines the sidereal time as the right ascension of an
earth-bound location and in his programs, he measures sidereal
times in decimal degrees instead of hms values, just like
he does for right ascensions.

The second category considers that the sidereal time
is a measure of time. See
[https://www.localsiderealtime.com/whatissiderealtime.html](https://www.localsiderealtime.com/whatissiderealtime.html)
and [https://en.wikipedia.org/wiki/Sidereal\_time](https://en.wikipedia.org/wiki/Sidereal_time),
as well as
[https://sites.google.com/site/astronomievouteceleste/5---temps-sideral](https://sites.google.com/site/astronomievouteceleste/5---temps-sideral)
[http://www.astrosurf.com/toussaint/dossiers/heuredetoiles/heuredetoiles.htm](http://www.astrosurf.com/toussaint/dossiers/heuredetoiles/heuredetoiles.htm)
[http://dictionnaire.sensagent.leparisien.fr/Temps%20sid%C3%A9ral/fr-fr/](http://dictionnaire.sensagent.leparisien.fr/Temps%20sid%C3%A9ral/fr-fr/)
in French.

But these descriptions seem to never mention issues linked
with the measure of time: How is sidereal time influenced by
timezones and daylight-saving time? What about leap seconds?
With sidereal time as an angle, we can see that if you take two points
on the surface of Earth within a few kilometers from each
other in the E → W direction, these points have a different sidereal
time. With sidereal time as a time, that would translate as saying
that sidereal time and the principle of timezones are incompatible.
Am I right or am I wrong? I found nothing about that in the
"sidereal time as a time" explanations.

So, between a simple and comprehensive definition on one side
and a convoluted and incomplete definition on the other side,
I will stick with "sidereal time as an angle" definition.

## Other Movements

Before I explain the other movements involved with the
Sun and the Earth, let me tell you a little digressive note.

### Weather And Climate

I hate these people who, each time snow falls, cry
"Where is this global warming scientists talk about
again and again?" These people seem to ignore that
climate and weather are two different things. When
the temperature from a meteorologic station varies
by 10 degrees C from one day to the following, this
is a mundane meteorological event. When the _average_
temperature for a decade varies by 2 degrees C from
one century to the next, this is a catastrophic
climate event.

The movements I explain below are more "climatic" and
less "meteorogical" than Earth's spin and orbital
rotation. Their values over a short timespan are so
low that the algorithms computing astronomical positions
over a short timespan do not care about them.

Note: weather (but not climate) will come back in a few
chapters as a real phenomenon, not as a metaphor.

### Equinox Precession

The best known movement with a long timescale is the
equinox precession. Presently, the vernal point lies
within the constellation of Pisces. But actually, it moves
all along the ecliptic, making a whole turn in about
26,000 years.

### Nutation

The angle between the equatorial plane and the ecliptic
plane varies slightly. In Paul Schlyter's C program, the
angle decreases by 356 nanodegrees per day (3.56e-7 °/d,
1.3e-4 °/yr).

### Perihelion Precession

There is also the perihelion precession. This movement
is best known for Mercury, because it is the most apparent,
but all other planets have a perihelion precession, including
the Earth.

### Other Drifts And Fluctuations

The formulas computing the positions of celestial bodies
use some constants. But these values are constant only
on a short timespan (astronomically speaking; or, with the
metaphor above, on a "meteorological" timespan). But they are
variable on a longer timespan (or a "climatic" timespan) For example,
everybody knows that the day lasts 24 hours (the mean
solar day, not the sidereal day). Yet, as I have read it
somewhere, in paleontological times, it used to last
22 hours or so.

The variation of the duration of the day is a tiny
variation, but with our modern measure instruments, we
can measure it. Since the time when scientists abolished the
astronomical standard of time for an atomic
standard, it has been necessary to add 27 leap seconds
over 47 years to synchronise the atomic timescale with
the Earth's spin.

For the moment, all adjustments have consisted in
adding a leap second. But it can happen that we
would have to synchronise in the other direction by removing
a second. So this phenomenon produces fluctuations
rather than a slow drift in a single direction.

### The Equation Of Time

There are other fluctuations, easier to measure and with a more
"meteorological" and less "climatic" timescale. The _true_ solar noon
does not occur on the same precise time as the _mean_ solar noon.
There are two reasons.

#### Obliquity of the Earth

First, there is an angle between the ecliptical plane and the equatorial plane,
therefore, a constant-speed rotation on the ecliptical plane does not translate
to a constant-speed rotation when measured by right ascension on the equatorial
plane. The rate of variation of the right ascension is a variable rate.

If we use the same units for the ecliptic longitude and the right ascension
(either degrees or hours), then both values are nearly equal, but still different.
So, when the ecliptic longitude is 46°20'31", the right ascension is 43°52'36",
that is, a 2°27'54" gap. The same happens at longitude 226°20'31". And at
longitude 313°32'52", the right ascension is 316°47", that is a gap of 2°27'54",
but in the other direction. And the same happens at 133°32'52". These are
the maximum values for the gap when using an obliquity of 23°26'.
And if you prefer hours, here are the values:

    .   longitude   right ascension      gap     longitude   right ascension   gap
    .   3h05mn22s      2h55mn30s       -9mn51s   46°20'31"     43°52'36"     -2°27'54"
    .   8h54mn11s      9h04mn03s        9mn51s  133°32'52"    136°00'47"      2°27'54"
    .  15h05mn22s     14h55mn30s       -9mn51s  226°20'31"    223°52'36"     -2°27'54"
    .  20h54mn11s     21h04mn03s        9mn51s  313°32'52"    316°00'47"      2°27'54"

#### Kepler's Second Law

Second, the rotational speed of Sun itself on the ecliptical plane is not a constant.
It obeys Kepler's second law, with a rotational speed more or less inversely
proportional to the Earth-Sun distance.

Q: You cannot apply Kepler's second law to a geocentric model!

A: No. Kepler's second law applies to a barycentric model as D above. It applies
_approximately_ to an heliocentric model as C. But once we have computed
Earth's angular speed on its orbit around the Sun in model C, the computation of the
Sun's coordinates and speed in the geocentric model is very simple. Especially,
the Sun's angular speed in a geocentric model is equal to the Earth's speed in
an heliocentric model.

Here are the Sun's positions for 2017, as given by Stellarium. The software
gives the equatorial coordinates and I translate them  into ecliptic coordinates.

    date       right ascension         declination  ecliptic longitude
    4 January  18h59mn1s 284°45'15"    -22°44'43"   -76°24'58" or -76,4162°
    5 January  19h3mn24s 285°51'       -22°38'18"   -75°23'58" or -75,3996°
    3 July      6h48mn   102°           22°58'35"   101°2'7"   or 101,0355°
    4 July      6h52mn8s 103°02'        22°53'39"   101°59'26" or 101,9907°

This translates as a speed of 1.0166 degree per day in January at perigee (when
in a geocentric model, that is perihelion in an heliocentric model) and a speed
of 0.9552 degree per day in July at apogee (or aphelion). Values are respectively
0.0423°/h and 0.0398°/h.

#### Equation of Time

The Earth's spin velocity is constant, that is 360.9856 degrees per day
but the Sun's orbital speed around the Earth is not. The combination of
both speeds is variable and it is _not_ 360 degrees per day. The crossing
of the meridian by the Sun is not exactly every 86400 seconds.
There is a difference between the Solar _Mean_ Time, where noon occurs
every 86400 seconds, no more, no less, and the Solar _Real_ Time, in which
noon is defined by the time when the Sun crosses the meridian. The difference
between the Solar Mean Time and the Solar Real Time is called _equation
of time_.

Here are the extreme values for the equation of time in 2017, computed
by a script using [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise) and refined with Stellarium.

    Date          DT::E::S    Stellarium
    2017-11-02    11:43:33    11:43:37   -16mn23s  earliest noon value,
    2017-02-10    12:14:12    12:14:14   +14mn14s  latest noon value
    2017-09-11    11:56:33    11:56:34    -3mn26s
    2017-09-12    11:56:11    11:56:13    -3mn47s  biggest decrease: 21 or 22 seconds
    2017-12-17    11:56:11    11:56:14    -3mn46s
    2017-12-18    11:56:41    11:56:44    -3mn16s  biggest increase: 30 seconds

And here is the curve for the equation of time.

![Curve of the equation of time during one year](equ-time.png)

#### The Analemma

The irregularity of the Sun's trajectory can be visualised by using the Local Mean Time
as a reference and pinpointing the positions of the Sun at noon in LMT.
The various Sun positions day after day build an 8-shaped curve, called _analemma_.

#### Mean Sun, Virtual Homocinetic Sun

In the following, it is useful to imagine a virtual Sun which would use an constant
angular speed (either in equatorial coordinates or ecliptic coordinates, depending on
which is more convenient).

The concept of _Mean Sun_ is a virtual Sun like this, calibrated so it crosses
the meridian at 12:00 (Local Mean Time) each day, and which minimizes the difference
between the real local noon and the mean local noon.

I will also consider several "virtual homocinetic suns" or VHS (no relation with
magnetic tapes). These virtual suns are synchronised with the real Sun at some
convenient point and then move with a constant angular speed.

# Computing Sunrise and Sunset

Computing sunrise and sunset consists in taking in account both the variation of
day's length and the equation of time to pinpoint when the Sun reaches the
altitude that corresponds to sunrise or sunset.

In the schema below, the variation of day's length results in a bobbing up and
down of the sinusoidal curve (and less obviously, a vertical stretch or compression
of this curve). The equation of time results in a leftward or rightward shift
of the curve.

![Evolution of the Sun's trajectory during a year](pseudo-analemma.gif)

Q: Wahoo! Impressive!

A: You should not be impressed. I took some liberties with the reality. First,
I figured the Sun's trajectory as a sinusoidal curve, because it is easy to compute,
but I did not check whether it was the real curve. And I would bet that it is
only approximately close to the real curve. Second, the equation of time is very much
increased. Instead of a true solar noon varying from 11:43 to 12:15 (in mean solar time),
here the variation is multiplied by 4 and the solar noon varies from 11:00, or even less,
to 13:00. But without this stretching, you would not have seen anything.

Q: And this figure eight, is this the analemma?

A: No. The analemma gives the position of the Sun as azimuth and height at
_mean_ solar noon. In the curve above, the abscisse is the mean time of
_true_ solar noon and the ordinate is the height of the Sun at this instant.
In other words, the analemma is based on a regular temporal event, the mean solar
noon, and plots the correlation between two variable spatial phenomena, the
azimuth and the height of the Sun. On the other hand, the curve above is based on
a precise spatial event, the azimuth 180°, and plots the correlation between a
variable spatial phenomenon, the height of the Sun and a variable temporal event,
the true solar noon.

I admit that the ordinates of both curves are very similar notions, and it would be
comparing golden apples with Granny Smiths. On the other hand, the abscisses are
a spatial angle in one case and a time of the day in the other case, so it would
be comparing apples with oranges.

Q: And the similarity of the shapes is juste a coincidence?

A: No, this is no coincidence. Let us start with the ordinates.
The curve above, which I will call "pseudo-analemma", gives the
height of the Sun at _true_ solar noon, so the Sun is at its highest for the current day.
Therefore, the height of the Sun in the analemma is obviously lower than on the
pseudo-analemma (except during the 4 days when the curve crosses the Y-axis).
But since we are near a point with an horizontal tangent, the variation
is very small. For example, we consider an observer at Greenwich observatory on
2nd November 2017. At true solar noon (11h 43mn 37s), the Sun is at 23°37'39"
while a quarter of an hour later, at mean solar noon it is at 23°31'40"
(values given by Stellarium).

For the abscisses, it is a bit more complicated. Let us use the same example as
above. At mean solar noon, the Sun's azimuth is 184°19'08", so on the analemma
the dot for 2nd November is on the right of the Y-axis. On the pseudo-analemma,
true solar noon occurs at 11h 43mn 37s, so the dot for 2nd November is on the
left of the Y-axis. Not only the units of measure are not the same, but there
is a change of sign. So the pseudo-analemma and the analemma
are, approximately, the symetrical image of the other curve.

See [below](#policitally-correct-analemma) for a politically correct
discussion of the analemma and pseudo-analemma.

## Principle of the Iterative Computation

There are two models for the variability of the true solar
noon from one day to the next. Let us take the example
of an observer in Greenwich in September 2017.
On 11th September, the true solar noon occurs at 11:56:34,
with an altitude of 42°53'40" and the next day it occurs
at 11:56:13 with an altitude of 42°30'47".

With the first model, we consider that the 11:56:34 value applies on the 11th from 00:00:01 until 23:59:59, at which time it instantly jumps
to 11:56:13 for the 12th. In other words, the pseudo-analemma
is a cloud of 365 discrete points.

Or else, we can consider that the true solar noon is a continuous function
and that the pseudo-analemma is a continuous curve. When using the orbital parameters
for the 11th at 11:56:34, the computed sunset occurs at 18:23:59. Since the true solar noon varies by 21 seconds over a timespan
of 86379 seconds (one day minus 21 seconds), using linear interpolation,
we can find that after 23225 seconds (i.e. at 18:23:59), the true solar
noon has varied by 5.6 seconds. Likewise, the altitude varies
by 22'53" in 86379 seconds and by 6'9" in 23225 seconds. So at
18:23:59, we have a _virtual_ true solar noon of 11:56:28
and a _virtual_ noon altitude of 42°47'31".

So we move a little bit the course of the Sun so it will
be at its highest at his virtual point
and we recompute the intersection between the new course and
the horizontal line corresponding to sunset. The result will not
be 18:23:59, but very near to this value and even nearer to the value
from Stellarium: 18:23:24.

## Implementation of Basic Algorithm

Before describing the precise algorithm, let us talk about the basic algorithm.
We will use the example of the sunset at Greenwich, on 4th January, 2018.

This paragraph and the following are based on the Perl code below:

    for(0, 1) {
      say join( " | ",$_, sunrise({ year =>  2018, month =>  1, day => 4,
                                    lon  =>    0,  lat   => +51.5, tz  =>  0, isdst => 0,
                                    alt  => -.833, upper_limb => 0, precise => $_, polar => 'retval',
                                    trace => *STDOUT } ));
    }

The basic algorithm begins by computing the day's true solar noon.
On 4th Jan, the true solar noon at Greenwich happens at 12:04:56.

Then we apply both Earth's spin (360.9856 degrees per day) and
the movement of a VHS ("virtual homocinetic sun"), that is, 0.9856 degrees per
day. The result is a combined rotational speed of 360 degrees per day, that is,
15 degrees per hour. And sunset happens when the VHS reaches the target altitude.

So on 4th Jan, the angle between noon and sunset is 59.9746° (59° 58' 28").
We need 3.9983 hours (3 h 59 mn 53 s) to run this angle and the sunset for
the VHS occurs at 16:04:50.

## Implementation of Precise Algorithm

With the precise algorithm, we keep separate Earth's spin (360.9856 degrees
per day) and the Sun's rotational speed around Earth. In addition, this
rotational speed is the real speed, spanning from 0.9552 to 1.0166
degree per day.

First iteration. We start from the true solar noon at 12:04:56 and we apply Earth's spin
(15.04107 degrees per hour). The first result, a very approximate one, is the
instant when Earth's spin brings the Sun to the target altitude.
On 4th Jan, this first value is 16:04:11.

For iteration 2, we determine the virtual solar noon that corresponds to the
Sun's position at 16:04:11. This virtual solar noon occurs at 12:05:01.
With this reference, we apply the Earth's rotation and we get a second
value for sunset, 16:04:23 (16.0731615074431 in decimal hours).

For iteration 3, we determine the virtual solar noon
that corresponds to the Sun's position at 16:04:23. This new virtual solar
noon occurs at 12:05:01. And one more time we apply the Earth's rotation
and we obtain a third value for sunset, 16:04:23, differing from the previous
value by less than a second: 16.0731642391519 instead of 16.0731615074431.
The difference is 2,73e-6 hours, that is 9 ms, so we leave the computation loop.

This is one way to describe the algorithm: the Sun reaches by anticipation
its position in the evening and stays there, waiting for the spinning Earth
to spin until the Sun disappears below the horizon. Another way to describe
the algorithm is as follows:

During iteration 2, between the real solar noon 12:04:56 and the time given
by iteration 1, 16:04:11, the Sun orbitates with its real speed of 1.0166 degree per day
while the Earth spins at 360.9856 degrees per day.
Then, at 16:04:11, the Sun freezes in its track and after that, we adjust the
position with only the Earth's spin to reach the required altitude.
And the sunset occurs at 16:04:23.

During iteration 3, between the real solar noon 12:04:56 and the time given
by iteration 2, 16:04:23, the Sun orbitates with its real speed 1.0166 degree per day.
Then at 16:04:23, it freezes, letting the Earth continue its spin. And sunset
happens 9 milliseconds later, at 16:04:23. So, there are 3 h 59 mn 27 s when we use
the Sun's real orbital speed and 9 milliseconds when we use an obviously wrong orbital
speed. In the end, it is better than the basic algorithm, which uses an approximate
but still wrong orbital speed, but for the whole span of 3 h, 59 mn and 57 s.

## What Happened in Spring 2020?

In Spring 2020, just before the 2020-07-09 release of
[DateTime::Event::Sunrise version 0.0506](https://metacpan.org/pod/DateTime::Event::Sunrise),
I had some discouragement and I nearly let the module go by
[giving it to ADOPTME](https://metacpan.org/author/ADOPTME/permissions).

Let us look a bit farther into  the past. In January 2019, I published
version  0.98   of  [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise),  with  the   precise  algorithm
implemented as explained in the  preceding paragraph. For test data, I
did not know how to cross-check  with authoritative sources, so I just
checked  they  looked plausible  and  that  the iterative  computation
stopped after  a few iterations. At  this time, I did  not synchronise
[DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise) with [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise), because it was not
the proper time yet.

Then in  April 2020, a user  created an RT ticket,  explaining that he
had   compared  the   results   of  [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise)   with
authoritative websites and  that the results were  not precise enough.
Of course  the results were  not precise,  I had not  yet synchronised
[DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise)  with [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise).  Yet this  ticket
gave  me two  things: first,  a  website which  would provide  precise
day-after-day computations of sunrise, sunset and real solar noon, and
second a few round tuits to upgrade [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise) to the
same level as [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise), with real tests values.

There   was   a   glitch.    The   precise   algorithm   copied   from
[Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise) and  the test  data from the  NOAA website  were not
matching. After  tweaking the algorithm  and asking for advice  on the
DateTime mailing-list
([https://www.nntp.perl.org/group/perl.datetime/2020/06/msg8241.html](https://www.nntp.perl.org/group/perl.datetime/2020/06/msg8241.html)),
I had to  admit that using a 15-degree-per-hour spin  speed was giving
better results  than the  normal 15.04107-degree-per-hour value.  So I
coded the  `15` value in [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise)  and I published
the module.

### What Went Wrong?

I still think my explanations of  the precise algorithm are correct. I
think that  the error  lies in the  implementation of  this algorithm.
Using as an example the values above, during iteration 2 we should use
the  Sun  at its  16:04:11  position  and  not moving.  Without  being
certain, I think that actually, the program computes the virtual solar
noon for 16:04:11,  which is 12:05:01 and that after  that it uses the
Sun at its 12:05:01 position.

How can I check  this hypothesis? I need to "create"  a new fixed star
at the 16:04:11 position of the Sun. And  I do not know how to do that
in  Stellarium. A  few  months  later, I  read  the documentation  for
Stellarium 0.20.1-1.  In chapter  13, I  found that  the user  can add
unofficial  novas  to   the  novas  coming  from   the  official  star
catalogues. This  would answer  my need.  The problem  is that  I have
Stellarium 0.18.0 and that I did  not succeed in creating "my" nova in
this  version. So  for  the  moment, it  is  impossible  to check  the
implementation of the precise algorithm.

# More About The Parameters

Below, I give some detailed explanations about the parameter used when
calling the module's functions. These explanations would have been too
long if they had been included in the module's POD and a casual doc reader
would have been drowned in a deluge of informations.

## Choosing The Algorithm, `precise` Parameter

Q: When should I choose the precise algorithm?

A: The short answer is "Never". The long answer is the following:

- If you want some twilight, use the basic algorithm.
- If you live between the polar circles, use the basic algorithm.
- If the date is far from a transition between day+night and either polar
night or midnight sun, use the basic algorithm.
- If the date is near a transition between day+night and polar
night, use the basic algorithm.
- If you live in a polar location AND the date is near a transition between
day+night and midnight Sun AND you are interested in the
visibility of the Sun's disk above the horizon, then you may use the
precise algorithm.

    Note that if you live a bit southward of the arctic circle (say, Reykjavik),
    you should use the precise algorithm around the 21st of June, even if midnight
    sun does not happen there. Same thing aoround the 21st of December if you live
    a bit northward of the antarctic circle.

Q: And can we know why the use of the precise algorithm is so narrow?

A: Let us go back to the animated picture of the solar course curve that
moves along the pseudo-analemma. But instead of using a location
at Greenwich, we use a polar location still at longitude zero, but at
76 degrees and 59 minutes from the equator.

![Evolution of the Sun's trajectory during a year (arctic variant)](ps-an-pol.gif)

As you can see, around 21st April and 21st August, the solar course
is tangent or nearly so with the line of horizon.
With these conditions, a variation of 6' of the solar altitude
can produce a much bigger variation of the points where the
solar course crosses the horizon.
For example, on 20th April 2017, at sunset time, we need 8 mn 18 s
to achieve this variation of 6'.

Q: Where does this 6' value come from?

A; This is the value I calculated in the chapter
["Principle of the Iterative Computation"](#principle-of-the-iterative-computation).

On the other hand, if you live in a temperate location far from the
arctic circles, the slope of the solar course when crossing
the horizon is always a bit steep.
For example, at Greenwich, the shallowest slope occurs at each solstice
and is about 6 or 7 degrees of altitude per hour. So a variation of 6' shifts the sunrise and sunset times by
only 50 seconds or less.

The diagram below shows the effect of a 6' vertical translation on the solar course in
two cases: 20th April at 76° 59' N and 21st December at Greenwich.
Warning: it is not to scale.

![Sun course, comparison between Greenwich on 21/12 and latitude 76 on 20/04](sunset-slope.png)

Q: And what happens to people living in polar locations when
the date is far from any transition?

A: If the period is day+night, the explanations above about the steep enough slope
of the curve still apply. If the period is the polar night or the
midnight Sun, then the course of the Sun never crosses the horizon and
any variation of altitude, within limits, cannot create an intersection
with the horizon.

Q: For the transition with the polar night, the solar course is tangent
to the equator, like it is at the transition with the midnight Sun period.
So, why do you still advise to use the basic algorithm in this case?

A: The basic algorithm and the precise algorithm both try to estimate
the ecliptic longitude and the altitude of the virtual noon sun at
the time of sunset. But while the precise algorithm uses the real
orbital speed which varies from 0.9552°/d to 1.0166°/d, the basic
algorithm uses a constant speed of 0.9856°/d, with an error of
±0.0310°/d. For the transition between day+night and midnight Sun,
this error runs for more than 11 hours, which might result in an error
of 0.015° on the Sun's ecliptic longitude. But for the transition
between day+night and polar night, the error runs for one hour or
less, yielding an error on the ecliptic longitude of 0.0013° only. So
even if a small error on the sun altitude gives a big error on the
sunset time, at the transition with the polar night, you will have a
_tiny_ error, not a _small_ one.

Q: And what about the computation of twilights? We can encounter a situation
where the solar course is tangent to the horizon, if I may use this word for a
line situated 24 degrees below the horizontal plane. And we have a ≈12 hour
gap as for the midnight Sun transition, not a 1-hour gap as for the polar night
transition.

A: Why do you compute twilight times? Because you want a low enough light
level and good enough conditions to observe celestial bodies.
Do you think there is a big difference between a night when the Sun is
at its lowest at 17°57' below the horizon and a night when it is at its
lowest at 18°3' below? In some circumstances, you'd better begin your observations
when the Sun is at, say, -15° than to wait for the -18° twilight if you know
that the Moon will rise at the same time or if a weather report gives a warning
about an incoming overcast layer.

## `alt` Parameter (Altitude) and `upper_limb` Parameter

Parameter `alt`, in decimal degrees, allows you to specify the altitude
of the sun corresponding to the event you are looking for: sun rise, sun
set or a twilight of some degree.

First, the various twilight values: they are arbitrary values. Nothing
to add.

For sunrise and sunset, the usual value is -0.833°, that is, -50'.
It comes from two values:

- -0.583° or -35' for the refraction,
- -0.25° or -15' for the radius of the solar disk.

Actually, in both cases, these are approximate values for variable phenomena.
The radius of the sun disk varies between 0.271° (or 16'16") on 3rd January, when
the sun is closest from the Earth, and 0.262° (or 15'44") on 3rd July, when it is
farthest from the Earth.

And the deviation caused by refraction is highly dependent on the temperature
profile in the atmosphere, therefore dependent on the current weather.

You can refine the computation by using value -0.583 for the `alt` parameter and
giving a true value to the `upper_limb` parameter (usually 1). In this case, the
radius of the sun disk is computed anew for each day. On the other hand, there is
no way within the module to refine the computation of the refraction. The answer
can only come from outside the module computing sunrises and sunsets.

Q: So using a parameter `alt` with -0.583 and a parameter `upper_limb` with 0 is stupid?

A: No, it is just unusual. As stated by Paul Schlyter
[in his website](http://www.stjarnhimlen.se/comp/riset.html#2),
the Swedish national almanacs define sunrise and sunset as the instants when the _centre_
of the sun disk reaches the optical horizon, not the instants when the _upper limb_ of
the sun disk reaches the optical horizon.

Q: On the other hand, using a parameter `alt` with -0.833 and a parameter `upper_limb` with 1 is stupid?

A: I would say neither "stupid" nor "unusual", but "suspicious". Actually, the usual -0.833 value comes from
three elements:

- 0 for the position of the observer relative to the surrounding landscape,
- -0.583° or -35' for the refraction,
- -0.25° or -15' for the radius of the solar disk, or 0 if you give a true value to `upper_limb`.

But if you are at the top of a 60-meter tower, the horizon line no longer
coincides with the horizontal plane, but with a cone making a 0.25° angle with the
horizontal direction. In this case, we have:

- -0.25° for the position of the observer relative to the surrounding landscape,
- -0.583° for the refraction,
- 0° for the radius of the solar disk if you give a true value to `upper_limb`, or -0.25° for a false value.

So this parameter combination is valid, but it is suspicious because it does not correspond
to a usual and mundane situation.

Q: After your explanation about the `precise` parameter, is there a significant
difference between `alt => -0.833, upper_limb => 0` and
`alt => -0.583, upper_limb => 1`?

A: You guessed, it, there is nearly no difference. The example I will take is sunset
at Fairbanks on 3rd January 2020. I take 3rd January because it is the time of the year
when the sun is at its largest. According to Stellarium, the diameter is 32'32", so the
radius is 16'16". And I take Fairbanks, because near a polar circle, the course of the sun
at sunset is much shallower than near the equator. So, for
`alt => -0.833, upper_limb => 0` the sunset occurs when the
center of the sun dist is at -50' and for
`alt => -0.583, upper_limb => 1` it occurs when the center of the sun disk is at -51'16".
Stellarium gives 15:59:12 in the first case and 15:59:37 in the second case.
A meagre 25-second difference.

On the other hand, let us move a few hundred kilometers to the North,
to 68°01'46" N, 147°42'59" W, beyond the polar circle. The computation with
`alt => -0.833, upper_limb => 0` shows that the sun
stays below the horizon and neither rises nor sets, while the computation with
`alt => -0.583, upper_limb => 1` gives a sunrise at 12:45:11 and a
sunset at 13:05:53.

## `year` Parameter

Q: Why does [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise) need the year to compute sunrise and sunset?
I have seen an algorithm which only needs the month and the day.

A: Let us compute the sunset at the Greenwich observatory at the end
of February and at the beginning of March. The times are respectively:

    .     26/02     27/02     28/02     29/02     01/03     02/03     03/03
    2015 17:46:17  17:35:43  17:37:29            17:39:15  17:41:01  17:42:47
    2016 17:47:36  17:35:17  17:37:03  17:38:49  17:40:35  17:42:21  17:44:06
    2017 17:47:11  17:36:37  17:38:24            17:40:10  17:41:55  17:43:41
    2018 17:46:45  17:36:12  17:37:58            17:39:44  17:41:30  17:43:15
    2019 17:46:20  17:35:46  17:37:32            17:39:18  17:41:04  17:42:49
    2020 17:47:39  17:35:20  17:37:06  17:38:52  17:40:38  17:42:24  17:44:09
    2021 17:47:13  17:36:40  17:38:26            17:40:12  17:41:58  17:43:44
    2022 17:46:48  17:36:14  17:38:01            17:39:47  17:41:32  17:43:18
    2023 17:46:23  17:35:48  17:37:35            17:39:21  17:41:07  17:42:52

As you can see in this table, when we go forward by 365 days, the sunset
time decreases by about 25 seconds. When we go forward by 366 days, the
sunset time increases by about 1 mn 20 s. And if we go forward by one
civil year, the sunset time seesaws. So, for the 28th of February,
which result should your yearless algorithm give? 17:37:03? Or 17:38:26?

Q: That means that my algorithm is bad.

A: No. If you want to know the precise instant when the Sun disappear
from our field of view, your algorithm is wrong indeed. On the other hand, if you are only interested
in the level of light, your algorithm is OK. I know a person who uses
a yearless algorithm to activate automated lights in his living room.
For him, turning on the lights at 17:37:03 or 17:38:26 has no importance.
Under our latitudes, the light variation in two minutes is negligible.
Actually, the weather may have a much important effect. If you have a clear
sky or a heavy layer of black thunder clouds, you will have to light
later or sooner than the computed time.

Q: By the way, you seem to say that a yearless algorithm would be sufficient
to compute twilight times? So why use an algorithm requiring the year?

A: Firstly, because the basic algorithm was already coded and a slightly worse
algorithm would be redundant. Then because I do not know which licenses
apply to these yearless algorithms, while at the same time, Paul Schlyter's
algorithm is in the public domain.

Q: Another thing, how did you get the seconds in the table? [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise)
does not provide the seconds.

A: Because I have used [DateTime::Event::Sunrise](https://metacpan.org/pod/DateTime::Event::Sunrise) instead of [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise),
which produces [DateTime](https://metacpan.org/pod/DateTime) objects, complete with seconds.

Q: Could we modify [Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise) to give `"hh:mm:ss"` results instead
of `"hh:mm"`?

A: We could. But would this precision be meaningful? According to Paul
Schlyter, the algorithm precision is about 1 or 2 minutes, except at the
beginning and the end of the Polar Day period when the precision is much
worse. So it is not worth adding the seconds to the results produced by
[Astro::Sunrise](https://metacpan.org/pod/Astro::Sunrise).

Q: And in the discussion above, why did you keep the seconds, if they
are not significant?

A: Because I think that if there is an error, it will be the same error
for similar dates, that is, end-February and beg-March within a decade.
For instance, we may have a +45 s bias on 2015-02-28 and a -50 s
bias on 2015-10-28 and on 2050-02-28, but for all the dates similar
to 2015-02-28 in both a YYYY fashion and a MM-DD fashion, the bias will
be approximately the same as 2015-02-28. Maybe +43 s or +46 s instead
of +45 s, but surely not -50 s. So I can make comparisons with a
granularity of 1 second. By the way, the bias values I gave above are
complete guesses, they are not the result of a precise computation.

TO BE COMPLETED

# Annex: Politically Correct Explanations

## Policitally Correct Analemma

First, let us deal with observers located north of the Arctic Polar Circle.
They just have to know that the analemma and the pseudo-analemma cross the horizon
and are partly hidden by the ground. The hidden part, more or less important depending
on the observer's latitude, corresponds to the year period when the _polar night_ is
in effect. You can find an example of the arctic pseudo-analemma in the
paragraph about the `precise` parameter.

For observers between the Tropic of Capricorn and the Antarctic Polar Circle,
this is more strange. True solar noon corresponds to a right ascension of 0°,
when the Sun is exactly northward. As the observer must face north instead of south,
he sees the sun crossing the sky in the direction E → N → W, that is, in the
direction of _decreasing_ right ascension values. So, when the true solar noon is
ahead of the mean solar noon, the point on the analemma will be to the left of the Y-axis,
and when the true solar noon is later than the mean solar noon, the point on the analemma
will be to the right of the Y-axis.

On the same time, for the pseudo-analemma, there is no reason to change the way
the time of day is represented on the abscisses, that is, left to right. Therefore,
the analemma and the pseudo-analemma will be more or less superposable, without
an intervening symmetry.

For observer to the south of the Antarctic Polar Circle, the situation is the same,
with the additional provision that the analemma and the pseudo-analemma will be partly
hidden by the ground.

And what about observers located between both tropics? An observer facing south
cannot see the whole analemma, he would miss the part around 21st of June,
which is located behind his back. And if he faces north, he will miss the
part around 21st of December. What to do then? Just lie on the ground. If the
observer lies with the head to the north and the feet to the south, the observed
analemma will be similar to the curve seen by an observer north of the Tropic of Cancer.
If the observer lies with the head to the south and the feet to the north, the situation
will be similar to an observer on the south of the Tropic of Capricorn and facing north.

TO BE COMPLETED
