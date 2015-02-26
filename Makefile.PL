use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME           => 'Astro::Sunrise',
    VERSION_FROM   => 'lib/Astro/Sunrise.pm', # finds $VERSION
    ABSTRACT       => 'Perl extension for computing the sunrise/sunset on a given day',
    PREREQ_PM      => { # DateTime => '0.16',
                        POSIX => 0,
                        'Math::Trig' => 0, },
    AUTHOR         => [ 'Ron Hill <rkhill@firstlight.net>', 'Jean Forget <JFORGET@cpan.org>' ],
    LICENSE        => 'perl',
    BUILD_REQUIRES => { 'Test::More'         => '0',   # should be 'TEST_REQUIRES', except that ExtUtils::MakeMaker 6.5705 does not accept it
                           },
    META_MERGE       => {
       recommends => {
           DateTime => '0.16',
       }
    },
);
