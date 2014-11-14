# NAME

SOAP::Data::Builder::Simple - Simplified way of creating data structures for SOAP::Lite

# SYNOPSIS

    use SOAP::Data::Builder::Simple qw( header data );

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

# DESCRIPTION

Simplified interface to [SOAP::Data](https://metacpan.org/pod/SOAP::Data) for creating data structures for use with
[SOAP::Lite](https://metacpan.org/pod/SOAP::Lite).

# DATA STRUCTURES

## Simple element (value only)

    # SOAP::Data->name($name)->value($value)
    $name => $value

## Element with attributes

    # SOAP::Data->name( $name => $value )->type($type)->attr( \%attr )
    $name => [
        _attr  => \%attr,
        _value => $value,
        _type  => $type,
    ]

## Element with children

    # SOAP::Data->name(
    #     $name => \SOAP::Data->value(
    #         SOAP::Data->name( child1 => $v1 ),
    #         SOAP::Data->name( child2 => ... ),
    #         ...
    #     )
    # )->type($type)->attr( \%attr )
    $name => [
        _attr  => \%attr,
        _type  => $type,
        child1 => $v1,
        child2 => [ ... ],
        ...
    ]

# FUNCTIONS

## header

Identical to `data` except the top level element(s) are of type SOAP::Header.

## data

Returns a list of one or more SOAP::Data objects. Each object may have further
SOAP::Data objects as children. Arrayrefs are used to preserve order of child
elements (ordering of `_value`, `_type`, `_attr`, etc is not important).

# SEE ALSO

- [SOAP::Data::Builder](https://metacpan.org/pod/SOAP::Data::Builder)
- [SOAP::Lite](https://metacpan.org/pod/SOAP::Lite)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/mjemmeson/SOAP-Data-Builder-Simple/issues](https://github.com/mjemmeson/SOAP-Data-Builder-Simple/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/mjemmeson/SOAP-Data-Builder-Simple](https://github.com/mjemmeson/SOAP-Data-Builder-Simple)

    git clone https://github.com/mjemmeson/SOAP-Data-Builder-Simple.git

# AUTHOR

Michael Jemmeson <mjemmeson@cpan.org>

# COPYRIGHT

This software is copyright (c) 2014 by Michael Jemmeson.

# LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
