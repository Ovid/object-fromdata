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
    homepage   => 'https://github.com/Ovid/object-fromdata',
    license    => 'http://www.perlfoundation.org/artistic_license_2_0',
    repository => 'git://github.com/Ovid/Object-FromData.git',
    bugtracker => 'https://github.com/Ovid/object-fromdata/issues',
);

configure_requires(
    'Module::Install' => 0,
);

build_requires(
    'Test::More' => 0,
);

requires();    # none

install_as_cpan;
auto_install;
WriteAll;
