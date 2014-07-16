#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WWW::Blogger' ) || print "Bail out!\n";
}

diag( "Testing WWW::Blogger $WWW::Blogger::VERSION, Perl $], $^X" );
