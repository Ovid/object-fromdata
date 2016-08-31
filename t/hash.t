#!/usr/bin/env perl

use Test::Most;
use Object::FromData;

my %items = (
    one      => 1,
    two      => 2,
    arrayref => [qw/un deux trois/],
    hashref  => { this => 'that', foo => 'bar', },
    _private => 666,
);
my $hashref = Object::FromData->new( { ref => \%items } );

explain ref $hashref;
is $hashref->one, 1, 'We should have methods on our hashref';
ok !$hashref->can('_private'), '... but not private ones';

ok my $arrayref = $hashref->arrayref,
  'We should be able to fetch an array ref';
is $arrayref->num_elems, 3,
  '... and it should have the correct number of elements';
is $arrayref->next, 'un',    '... and we should be able to iterate over it';
is $arrayref->next, 'deux',  '... and we should be able to iterate over it';
is $arrayref->next, 'trois', '... and we should be able to iterate over it';
is $hashref->hashref->this, 'that',
  '... and we should also store hashrefs correctly';

my %bad_keys = (
    keys   => 'syek',
    values => 'seulav',
);

$hashref = Object::FromData->new( { ref => \%bad_keys } );

is $hashref->keys, 'syek',
  'If the keys override the base method keys, we should still be able to fetch the value';
eq_or_diff [ sort Object::FromData::Hash->keys($hashref) ],
  [ sort keys %bad_keys ],
  '... but we can call the method as a class method to get our underlying data';

done_testing;
