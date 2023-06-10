#!bash

#
# usage:
# 	stubhub.sh $no_of_tickets $max_price "$stubhub_event_url"
#
# 	$stubhub_event_url should be of the form with the trailing slash, eg:
# 		https://www.stubhub.com/coldplay-zurich-tickets-7-1-2023/event/150371201/
#
set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TICKETS=$1
MAX_PRICE=$2
URL="$3?quantity=$TICKETS"

curl $URL > $SCRIPT_DIR/stubhub.html
for price in $($SCRIPT_DIR/stubhub.pl --html $SCRIPT_DIR/stubhub.html --tickets $TICKETS --max-price $MAX_PRICE)
do
	/opt/homebrew/bin/ntfy publish tickets "$TICKETS Stubhub tickets available for $price each 😀"
done
