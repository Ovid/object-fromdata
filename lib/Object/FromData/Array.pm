package Object::FromData::Array;

use strict;
use warnings;

sub new {
    my ( $class, $arg_for ) = @_;

    my $arrayref = $arg_for->{arrayref}
      or die "arrayref argument not passed to Object::FromData::Array::new";
    my @array;
    my $self = {
        array         => \@array,
        current_index => 0,
    };
    foreach my $item (@$arrayref) {
        if ( !ref $item ) {
            push @array => $item;
        }
        elsif ( 'ARRAY' eq ref $item ) {
            push @array => $class->new( { arrayref => $item } );
        }
        elsif ( 'HASH' eq ref $item ) {
            push @array =>
              Object::FromData::Hash->new( { hashref => $item } );
        }
        else {
            die "Don't yet handle $item";
        }
    }
    return bless $self => $class;
}

sub current_index {
    my $self = shift;
    return $self->{current_index};
}

sub elems {
    my $self = shift;
    return scalar @{ $self->arrayref };
}

sub reset {
    my $self = shift;
    $self->{current_index} = 0;
}

sub all {
    my $self = shift;
    return @{ $self->arrayref };
}

sub arrayref {
    my $self = shift;
    return $self->{array};
}

sub has_more {
    my $self     = shift;
    my $arrayref = $self->arrayref;
    return $self->{current_index} <= $#$arrayref;
}

sub next {
    my $self = shift;
    return unless $self->has_more;
    return $self->arrayref->[ $self->{current_index}++ ];
}

1;
