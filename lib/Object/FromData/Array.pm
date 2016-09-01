package Object::FromData::Array;

use strict;
use warnings;

our $VERSION = '0.03';

sub _new {
    my ( $class, $arg_for ) = @_;

    my $arrayref = $arg_for->{ref};
    my $self     = {
        array         => [],
        current_index => 0,
    };
    foreach my $item (@$arrayref) {
        if ( 'ARRAY' eq ref $item ) {
            push @{ $self->{array} } => $class->_new( { ref => $item } );
        }
        elsif ( 'HASH' eq ref $item ) {
            push @{ $self->{array} } =>
              Object::FromData::Hash->_new( { ref => $item } );
        }
        else {
            push @{ $self->{array} } => $item;    # accept it raw
        }
    }
    return bless $self => $class;
}

sub current_index {
    my $self = shift;
    return $self->{current_index};
}

sub num_elems {
    my $self = shift;
    return scalar @{ $self->{array} };
}

sub reset {
    my $self = shift;
    $self->{current_index} = 0;
}

sub all {
    my $self = shift;
    return @{ $self->{array} };
}

sub has_more {
    my $self     = shift;
    my $arrayref = $self->{array};
    return $self->{current_index} <= $#$arrayref;
}

sub next {
    my $self = shift;
    return unless $self->has_more;
    return $self->{array}->[ $self->{current_index}++ ];
}

sub is_hashref  { }
sub is_arrayref {1}

1;

__END__

=head1 NAME

Object::FromData::Array - Create an object from an arrayref.

=head1 SYNOPSIS

Don't instantiate directly using this module. Use C<Object::FromData> instead.

    my $arrayref = Object::FromData->new( { ref => \@array } );

    while ( $arrayref->has_more ) {
        my $value = $arrayref->next;
        ...
    }

=head2 C<has_more>

    while ( $arrayref->has_more ) {
        my $value = $arrayref->next;
        ...
    }

Boolean indicating if the array iterator is exhausted.

=head2 C<next>

    my $value = $arrayref->next;

Returns the next value in the arrayref iterator.

=head2 C<reset>

    $arrayref->reset;

Resets the arrayref iterator.

=head2 C<all>

    my @values = $arrayref->all;

Returns a list of all values. Each value I<might> be an C<Object::FromData::>
object if it's a reference.

=head2 C<num_elems>

    my $num_elems = $arrayref->num_elems;

Returns the number of elements in the array reference.

=head2 C<current_index>

    my $i = $arrayref->current_index;

Returns the current numeric index of the iterator.

=head2 C<is_hashref>

    if ( $arrayref->is_hashref ) { ... }

Returns false.

=head2 C<is_arrayref>

    if ( $arrayref->is_arrayref ) { ... }

Returns true.
