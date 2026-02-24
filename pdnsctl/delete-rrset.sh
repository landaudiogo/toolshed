#!/usr/bin/env bash

set -euo pipefail

script=$(basename "$0")
USAGE="
Usage: $script <record-name>

Positional parameters:
    record-name: DNS Canonical A Record Name (e.g. example.ad.dlandau.nl.)
"

if (( $# != 1 )); then
    echo "$USAGE"
    exit 1
fi

record_name="$1"

curl \
    -H "X-API-Key: $PDNS_API_KEY" \
    -H 'Content-Type: application/json' \
    -X PATCH \
    "http://$PDNS_SERVER/api/v1/servers/localhost/zones/$ZONE" \
    --data '{
        "rrsets": [
            {
                "name": "'"$record_name"'", 
                "type": "A", 
                "changetype": "DELETE"
            }
        ]
    }'
