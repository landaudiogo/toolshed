#!/usr/bin/env bash

set -euo pipefail

script=$(basename "$0")
USAGE="
Usage: $script <subdomain>

Positional parameters:
    subdomain: subdomain which will be prepended to '$ZONE'. E.g. if 'subdomain=example' then the record name will be example.$ZONE
"

if (( $# != 1 )); then
    echo "$USAGE"
    exit 1
fi

subdomain="$1"

curl \
    -H "X-API-Key: $PDNS_API_KEY" \
    -H 'Content-Type: application/json' \
    -X PATCH \
    "http://$PDNS_SERVER/api/v1/servers/localhost/zones/$ZONE" \
    --data '{
        "rrsets": [
            {
                "name": "'"$subdomain"'.'"$ZONE"'", 
                "type": "A", 
                "changetype": "DELETE"
            }
        ]
    }'
