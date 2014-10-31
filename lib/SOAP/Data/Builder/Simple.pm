package SOAP::Data::Builder::Simple;

use strict;
use warnings;

use base 'Exporter';
our @EXPORT_OK = qw( data header );

use List::Util qw( pairs );
use SOAP::Data::Builder;

sub data {
    my $data = shift;

    my $sdb = SOAP::Data::Builder->new();

    _add( $sdb, $data );

print $sdb->serialise;

    return $sdb->to_soap_data;
}

sub header {
    my $data = shift;

    my $sdb = SOAP::Data::Builder->new();

    _add( $sdb, $data, 1 );

print $sdb->serialise;

    return $sdb->to_soap_data;
}

sub _add {
    my ( $element, $data, $is_header ) = @_;

    use Data::Dumper::Concise;
    warn Dumper( { data => $data, is_header => $is_header } );

    foreach my $pair ( pairs( @{ $data || [] } ) ) {
        my ( $name, $v ) = @{$pair};

        unless ( ref $v ) {
            $element->add_elem(
                name   => $name,
                header => $is_header ? 1 : 0,
                value  => $v
            );
            return;
        }

        if ( $name eq '_attr' && ref $v eq 'HASH' ) {
            $element->{attributes} = $v;
            return;
        }

        $element = $element->add_elem( name => $name );

        return _add->($v);
    }
}

1;

__END__

=head1 NAME

SOAP::Data::Builder::Simple

=head1 SYNOPSIS

    use SOAP::Data::Builder::Simple;

    my $headers = header(
        [   'eb:MessageHeader' => [
                _attr =>
                    { 'eb:version' => "2.0", 'SOAP::mustunderstand' => "1" },
                'eb:From' => [
                    'eb:PartyId' => 'uri:example.com',
                    'eb:Role'    => 'http://rosettanet.org/roles/Buyer',
                ],
                'eb:DuplicateElimination' => undef,
            ]
        ]
    );

    my $data = data( [ foo => 'bar' ] );

    my $result = SOAP::Lite
        -> uri($uri);
        -> proxy($proxy)
        -> getTest( $headers, $data )
        -> result;

=cut


