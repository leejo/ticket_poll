#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say /;

use File::Slurper qw/ read_text /;
use Mojo::DOM;
use Mojo::JSON qw/ from_json /;
use Getopt::Long;

GetOptions(
	\my %opts,
	'html=s',
	'tickets=i',
	'max-price=i',
);

my $html      = read_text( $opts{'html'} );
my $max_price = $opts{'max-price'};
my $tickets   = $opts{'tickets'};

my $dom  = Mojo::DOM->new( $html );

# grab the listings JSON
my $json = $dom->find( 'script[id^="index-data"]' )
	->map( 'text' )
	->join( "\n" );

my $listings = from_json( $json );

# see if we have any entries
my @available;

foreach my $listing (
	grep {
		$_->{availableTickets} >= $tickets
		&& $_->{rawPrice} <= $max_price
	}
	$listings->{grid}{items}->@*
) {
	push( @available,$listing->{priceWithFees} );
}

say join( ' ',@available );
