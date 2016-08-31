use 5.006;
use strict;
use warnings;
use inc::Module::Install;

name 'Object-FromData';
all_from 'lib/Object/FromData.pm';
author q{Curtis "Ovid" Poe <ovid@cpan.org>};
license 'artistic2';

perl_version 5.006;

tests_recursive('t');

resources(
    #homepage   => 'http://yourwebsitehere.com',
    #IRC        => 'irc://irc.perl.org/#Object-FromData',
    license => 'http://www.perlfoundation.org/artistic_license_2_0',

    #repository => 'git://github.com/Curtis "Ovid" Poe/Object-FromData.git',
    #repository => 'https://bitbucket.org/Curtis "Ovid" Poe/Object-FromData',
    bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Object-FromData',
);

configure_requires(
    'Module::Install' => 0,
);

build_requires(
    'Test::Most' => 0,
);

requires(
    #'ABC'              => 1.6,
    #'Foo::Bar::Module' => 5.0401,
);

install_as_cpan;
auto_install;
WriteAll;
