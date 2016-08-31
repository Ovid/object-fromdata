#!/usr/bin/env perl

use Test::Most;
use Object::FromData::Array;

my @items = qw( one two three four );
my $array = Object::FromData::Array->new( \@items );

is $array->elems, 4,
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

done_testing;
