#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'HTML::FormHandler::Role::Default' ) || print "Bail out!\n";
}

diag( "Testing HTML::FormHandler::Role::Default $HTML::FormHandler::Role::Default::VERSION, Perl $], $^X" );
