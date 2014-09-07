#!/bin/sh
#HOST="localhost:8080"
HOST="www.manyconf.com:80"
#URL="http://$HOST/conference/api/1.0/conferences?api_key=1f3870be274f6c49b3e31a0c6728957f"
URL="http://$HOST/api/1.0/conferences?api_key=1f3870be274f6c49b3e31a0c6728957f"

#ACCEPT="-H \"Accept: application/json\""
CONTENTTYPE="-H \"Content-Type: application/json\""

PARAMS="&max=100&offset=5"

curl -s ${ACCEPT} ${CONTENTTYPE} "${URL}${PARAMS}"  | python -mjson.tool
echo
