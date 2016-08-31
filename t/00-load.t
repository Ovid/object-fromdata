#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Object::FromData' ) || print "Bail out!\n";
}

diag( "Testing Object::FromData $Object::FromData::VERSION, Perl $], $^X" );
