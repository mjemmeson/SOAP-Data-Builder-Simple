package SOAP::Data::Builder::Simple;

our $VERSION = '0.01';

use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw( data header );

use List::Util qw( pairs );
use SOAP::Lite;

# So we can stop SOAP::Lite adding 'xsi:nil="true"'
sub SOAP::Serializer::as_nonil {
    my ( $self, $value, $name, $type, $attr ) = @_;
    delete $attr->{'xsi:nil'};
    return [ $name, $attr, $value ];
}

sub data {
    return _add( undef, \@_ );
}

sub header {
    return _add( undef, \@_, 1 );
}

sub _add {
    my $parent    = shift;
    my @data      = @{ shift || [] };
    my $is_header = shift() ? 1 : 0;

    # first argument can be hashref
    my $args = ref $data[0] eq 'HASH' ? shift @data : {};

    # allow arrayref for backwards compatibility
    @data = @{ $data[0] } if ref $data[0] eq 'ARRAY';

    my @return;

    foreach my $pair ( pairs @data ) {

        my ( $key, $value ) = @{$pair};

        # underscore prefix - pass through to parent
        if ( $key =~ m{^_(.+)} ) {
            $parent->$1($value);

        } else {

            my $element = $is_header ? SOAP::Header->new : SOAP::Data->new;
            $element->name($key);
#            $element->type('');

            if ( ref $value eq 'ARRAY' ) {

                $element->value(
                    \SOAP::Data->value( _add( $element, $value ) ) )
                    if @{$value};

            } elsif ( !ref $value ) {

                $element->value($value);
            }

            # ignore $value if hashref

            push @return, $element;
        }

    }

    return @return;
}

1;

__END__

=head1 NAME

SOAP::Data::Builder::Simple - Simplified way of creating data structures for SOAP::Lite

=head1 SYNOPSIS

    use SOAP::Data::Builder::Simple;

    # note - uses arrayrefs to preserve element order

    my @headers = header(
        'eb:MessageHeader' => [
            _attr => { 'eb:version' => "2.0", 'SOAP::mustUnderstand' => "1" },
            'eb:From' => [
                'eb:PartyId' => 'uri:example.com',
                'eb:Role'    => 'http://rosettanet.org/roles/Buyer',
            ],
            'eb:DuplicateElimination' => [
                _type => 'nonil'    # prevent SOAP::Lite adding 'xsi:nil="true"'
            ],
        ]
    );

    my @data = data( foo => 'bar' );

    my $result = SOAP::Lite
        -> uri($uri);
        -> proxy($proxy)
        -> getTest( @headers, @data )
        -> result;

=head1 DESCRIPTION

Simplified interface to L<SOAP::Data::Builder> for creating SOAP::Data objects
for use with L<SOAP::Lite>.

=head1 SEE ALSO

=over

=item *

L<SOAP::Data::Builder>

=back

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/mjemmeson/SOAP-Data-Builder-Simple/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/mjemmeson/SOAP-Data-Builder-Simple>

  git clone https://github.com/mjemmeson/SOAP-Data-Builder-Simple.git

=head1 AUTHOR

Michael Jemmeson <mjemmeson@cpan.org>

=head1 COPYRIGHT

This software is copyright (c) 2014 by Michael Jemmeson.

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

