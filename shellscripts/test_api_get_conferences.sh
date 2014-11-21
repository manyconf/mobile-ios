#!/bin/sh
#HOST="localhost:8080/conference"
HOST="www.manyconf.com:80"
URL="http://$HOST/api/1.0/conferences.json?api_key=1f3870be274f6c49b3e31a0c6728957f"

#ACCEPT="-H \"Accept: application/json\""
#CONTENTTYPE="-H \"Content-Type: application/json\""

PARAMS=""
PARAMS+="&sort=startdate"
PARAMS+="&order=desc"
#PARAMS+="&order=asc"
#PARAMS+="&max=5&offset=5"

curl -s ${ACCEPT} ${CONTENTTYPE} "${URL}${PARAMS}" | python -mjson.tool
echo
