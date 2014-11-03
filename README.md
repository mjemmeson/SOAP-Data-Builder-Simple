# NAME

SOAP::Data::Builder::Simple - Simplified interface to SOAP::Data::Builder

# SYNOPSIS

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

# DESCRIPTION

Simplified interface to [SOAP::Data::Builder](https://metacpan.org/pod/SOAP::Data::Builder) for creating SOAP::Data objects
for use with [SOAP::Lite](https://metacpan.org/pod/SOAP::Lite).

# SEE ALSO

- [SOAP::Data::Builder](https://metacpan.org/pod/SOAP::Data::Builder)

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
