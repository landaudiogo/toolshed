#!/usr/bin/env bash

set -euo pipefail

curl \
    -H "X-API-Key: $PDNS_API_KEY" \
    -X GET \
    -s \
    "http://$PDNS_SERVER/api/v1/servers/localhost/zones/$ZONE"
