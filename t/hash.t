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
ok !$arrayref->has_more, '... until we are out of elements';
is $hashref->hashref->this, 'that',
  '... and we should also store hashrefs correctly';

while ( $hashref->has_more ) {
    my ( $key, $value ) = $hashref->each;
    explain $key, $value;
}

done_testing;
