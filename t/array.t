#!/usr/bin/env perl

use Test::More;
use Object::FromData;

my @items = qw( one two three four );
my $array = Object::FromData->new( { ref => \@items } );

is $array->num_elems, 4,
  'We should have the correct number of items in the array';

foreach my $item (@items) {
    ok $array->has_more,
      'has_more() should tell us if the iterator is exhausted';
    is $array->next, $item, '... and next() should return the next item';
}

ok !$array->has_more,
  'has_more() should tell us when the iterator is exhausted';
$array->reset;
ok $array->has_more, '... and when it has been reset';

push @items => [ 1, 2, 3 ], 4;
$array = Object::FromData->new( { ref => \@items } );

is $array->num_elems, 6,
  'We should have the correct number of items in the array';
$array->next for 1 .. 4;
my $next = $array->next;

is $next->num_elems, 3,
  '... and array refs are stored correctly';
is $array->next, 4, '... and we can fetch values after them';

done_testing;
