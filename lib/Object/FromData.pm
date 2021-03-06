package Object::FromData;

use strict;
use warnings;
use Object::FromData::Array;
use Object::FromData::Hash;
use Carp 'confess';

=head1 NAME

Object::FromData - Throw arrayrefs or hashrefs at this to get an object

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    use Object::FromData;

    my $object = Object::FromData->new(
        {   ref => {
                foo      => 'bar',
                this     => 'that',
                _private => 'no method will be created',
                colors   => [qw/red blue green/],
                numbers  => {
                    un    => 1,
                    deux  => 2,
                    trois => 3,
                },
            },
        }
    );

    say $object->is_hashref;     # 1
    say $object->is_arrayref;    # 0

    say $object->foo;            # bar
    say $object->this;           # that
    say $object->_private;       # BOOM! No such method

    say $object->numbers->is_hashref;     # 0
    say $object->numbers->is_arrayref;    # 1
    say $object->numbers->deux;           # 2

    my $colors = $object->colors;
    while ( $colors->has_more ) {
        say $colors->next;    # red, blue, green on successive lines
    }

=head2 C<new>

    my $object = Object::FromData->new({ ref => $ref });

Takes a hashref. The key of C<ref> must be a hashref or arrayref. Returns an
object. The object represents a hash or an arrayref as created by
C<Object::FromData::Hash> or C<Object::FromData::Array>.

The primary purpose of this module was to be able to take arbitrary JSON from
a client and create an object I could safely embed in another object.

=cut

sub new {
    my ( $class, $arg_for ) = @_;

    my $ref = $arg_for->{ref}
      or confess "no ref() supplied to Object::FromData::new";
    if ( 'ARRAY' eq ref $ref ) {
        return Object::FromData::Array->_new( { ref => $ref } );
    }
    elsif ( 'HASH' eq ref $ref ) {
        return Object::FromData::Hash->_new( { ref => $ref } );
    }
    else {
        croak(
            "Don't know how to convert '$ref' into an object. I only handle arrayrefs and hashrefs"
        );
    }
}

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-object-fromdata at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Object-FromData>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

We've tried to keep the methods minimal, but because we're inheriting from
C<Object::FromData::Array> and C<Object::FromData::Hash>, the latter might
have keys which override the main keys. If that happens, call the methods as
class methods, passing in the object as an argument:

    my %hash = (
        keys => [qw/foo bar baz/],
    );
    my $object = Object::FromData->new({ ref => \%hash });

    my @keys = $hash->keys; # returns an Object::FromData::Array instance of foo, bar, and baz
    my @keys = Object::FromData::Hash->keys($hash); # returns 'keys'

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Object::FromData

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Object-FromData>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Object-FromData>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Object-FromData>

=item * Search CPAN

L<http://search.cpan.org/dist/Object-FromData/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Curtis "Ovid" Poe.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of Object::FromData
