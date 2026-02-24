#!/usr/bin/env bash

set -euo pipefail

script=$(basename "$0")
USAGE="
Usage: $script <record-name> <ipv4>

Positional parameters:
    record-name: DNS A Record Name
    ipv4: IPv4 address which to link to the record
"

if (( $# != 2 )); then
    echo "$USAGE"
    exit 1
fi

record_name="$1"
ipv4="$2"

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
                "ttl": 3600, 
                "changetype": "REPLACE", 
                "records": [{"content": "'"$ipv4"'", "disabled": false}]
            }
        ]
    }'
