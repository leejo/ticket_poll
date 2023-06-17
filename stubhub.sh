#!/usr/bin/env bash

#
# usage:
# 	stubhub.sh $no_of_tickets $max_price "$stubhub_event_url" $event_name
#
# 	$stubhub_event_url should be of the form with the trailing slash, eg:
# 		https://www.stubhub.com/coldplay-zurich-tickets-7-1-2023/event/150371201/
#
set -eu

date

PERL=/Users/leejohnson/perl5/perlbrew/perls/perl-5.36.1/bin/perl
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

QUANTITY=$1
MAX_PRICE=$2
URL="$3?quantity=$QUANTITY"
EVENT=$4
HTML_FILE=$SCRIPT_DIR/stubhub_${EVENT}.html

curl $URL > $HTML_FILE
for price in $($PERL $SCRIPT_DIR/stubhub.pl --html $HTML_FILE --tickets $QUANTITY --max-price $MAX_PRICE)
do
	/opt/homebrew/bin/ntfy publish tickets "$QUANTITY $EVENT Stubhub tickets available for $price each 😀"
done
