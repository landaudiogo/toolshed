#!/usr/bin/env bash

set -euo pipefail

script=$(basename "$0")
USAGE="
Usage: $script <subdomain> <ipv4>

Positional parameters:
    subdomain: subdomain which will be prepended to $ZONE. E.g. if 'subdomain=example' then the record name will be example.$ZONE
    ipv4: IPv4 address which to link to the record
"

if (( $# != 2 )); then
    echo "$USAGE"
    exit 1
fi

subdomain="$1"
ipv4="$2"

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
                "ttl": 3600, 
                "changetype": "REPLACE", 
                "records": [{"content": "'"$ipv4"'", "disabled": false}]
            }
        ]
    }'
