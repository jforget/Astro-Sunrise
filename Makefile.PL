use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Astro::Sunrise',
    'VERSION_FROM' => 'Sunrise.pm', # finds $VERSION
    'PREREQ_PM' =>{ 'Time::Object' => 0, },
);
