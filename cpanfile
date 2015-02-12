requires 'perl' => "5.008";

requires 'base'       => '0';
requires 'List::Util' => '1.29';
requires 'Safe::Isa'  => '0';
requires 'SOAP::Lite' => '0';

on 'test' => sub {
    requires 'SOAP::Data::Builder' => '0';
    requires 'Test::More'          => '0';
};

on 'develop' => sub {
    requires 'Dist::Milla' => '0';
};

