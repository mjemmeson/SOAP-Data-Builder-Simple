package SOAP::Data::Builder::Simple;

our $VERSION = '0.01';

use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw( data header to_soap );

use List::Util qw( pairs );
use SOAP::Data::Builder;

sub data {
    my $data = shift;

    my $sdb = SOAP::Data::Builder->new();

    _add( $sdb, $data );

    return $sdb->to_soap_data;
}

sub header {
    my $data = shift;

    my $sdb = SOAP::Data::Builder->new();

    _add( $sdb, $data, 1 );

    return $sdb->to_soap_data;
}

sub _add {
    my ( $element, $data, $is_header ) = @_;

    foreach my $pair ( pairs( @{ $data || [] } ) ) {
        my ( $name, $v ) = @{$pair};

        unless ( ref $v ) {
            $element->add_elem(
                header => $is_header ? 1 : 0,
                name   => $name,
                value  => $v
            );
            next;
        }

        if ( $name eq '_attr' && ref $v eq 'HASH' ) {
            $element->{attributes} = $v;
            next;
        }

        my $added = $element->add_elem( name => $name );

        _add( $added, $v, $is_header );
    }
}

1;

__END__

=head1 NAME

SOAP::Data::Builder::Simple - Simplified interface to SOAP::Data::Builder

=head1 SYNOPSIS

    use SOAP::Data::Builder::Simple;

    # note - uses arrayrefs to preserve element order

    my @headers = header(
        [   'eb:MessageHeader' => [
                _attr =>
                    { 'eb:version' => "2.0", 'SOAP::mustUnderstand' => "1" },
                'eb:From' => [
                    'eb:PartyId' => 'uri:example.com',
                    'eb:Role'    => 'http://rosettanet.org/roles/Buyer',
                ],
                'eb:DuplicateElimination' => undef,
            ]
        ]
    );

    my @data = data( [ foo => 'bar' ] );

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

