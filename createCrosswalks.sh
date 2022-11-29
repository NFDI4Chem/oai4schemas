#! /bin/bash
##
## Optionally specify the backend as argument, e.g.
## ./createCrosswalks.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

#The examples below use the linux command jq for encoding teh XSLT to JSON for adding it into the curl command
#The package can be installed via yum install jq

#Create Crosswalk from embedded JSON+LD to oai_dc
XSLT_JSON_ENCODED=`cat json_container2oai_dc.xslt | jq -Rsa .`
curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/crosswalk" \
  --data '{"name":"json_container2OAI_DC_v09","formatFrom":"json_container","formatTo":"oai_dc","xsltStylesheet":'"$XSLT_JSON_ENCODED}"'}'

#Read all crosswalk
curl -X GET "$BACKEND/crosswalk"

# Delete specific crosswalk
# curl -v -X DELETE $BACKEND/crosswalk/Radar2OAI_DC_v09
