package Object::FromData::Hash;

use strict;
use warnings;
use Digest::MD5 'md5_hex';    # convenience, not security

sub _new {
    my ( $class, $arg_for ) = @_;

    my $hashref       = $arg_for->{ref};
    my $allow_private = $arg_for->{allow_private} || 0;
    my @all_keys      = sort CORE::keys %$hashref;
    my @keys          = $allow_private ? @all_keys : grep { !/^_/ } @all_keys;

    my $new_class = "${class}::" . md5_hex( join '-' => @keys );
    {
        no strict 'refs';
        @{"${new_class}::ISA"} = $class;
    }

    my %hash;
    my $self = {
        hash          => \%hash,
        keys          => \@keys,
        allow_private => $allow_private,
        current_index => 0,
    };

    KEY: foreach my $key (@all_keys) {
        my $value = $hashref->{$key};
        if ( !ref $value ) {
            $hash{$key} = $value;
        }
        elsif ( 'ARRAY' eq ref $value ) {
            $hash{$key}
              = Object::FromData::Array->_new( { ref => $value } );
        }
        elsif ( 'HASH' eq ref $value ) {
            $hash{$key} = $class->_new( { ref => $value } );
        }
        else {
            die "Don't yet handle $value";
        }
        if ( $key =~ /^_/ ) {
            next KEY unless $allow_private;
        }
        no strict 'refs';
        *{"$new_class::$key"} = sub { $hash{$key} };
    }
    return bless $self => $new_class;
}

sub keys {
    my $self = shift;
    $self = shift if @_;
    return keys %{ $self->{hash} };
}

sub values {
    my $self = shift;
    $self = shift if @_;
    return values %{ $self->{hash} };
}

sub is_hashref  {1}
sub is_arrayref { }

1;

__END__

=head1 NAME

Object::FromData::Hash -> Create an object from a hashref.

=head1 SYNOPSIS

Don't instantiate directly using this module. Use C<Object::FromData> instead.

    my %hash = (
        name   => 'Bob',
        age    => 27,
        colors => [qw/red green blue/],
    );

    my $hashref = Object::FromData->new( { ref => \%hash } );
    my @keys    = $hashref->keys;
    my @values  = $hashref->values;
    say $hashref->name;    # Bob
    my $arrayref_object = $hashref->colors;    # Object::FromData::Array

=head2 C<is_hashref>

    if ( $hashref->is_hashref ) { ... }

Returns true.

=head2 C<is_arrayref>

    if ( $hashref->is_arrayref ) { ... }

Returns false.

=head2 C<keys>

    my @keys = $hashref->keys;

Returns a I<list> of the keys.

=head2 C<values>

    my @values = $hashref->values;

Returns a I<list> of the values.

=head1 HASH KEYS OVERRIDING BUILT IN METHODS

We've tried to keep the methods minimal, but because we're inheriting from
C<Object::FromData::Hash> and the hash you pass in might have keys which
override the main keys. If that happens, call the methods as class methods,
passing in the object as an argument:

    my %hash = (
        keys => [qw/foo bar baz/],
    );
    my $object = Object::FromData->new({ ref => \%hash });

    my @keys = $hash->keys; # returns an Object::FromData::Array instance of foo, bar, and baz
    my @keys = Object::FromData::Hash->keys($hash); # returns 'keys'
