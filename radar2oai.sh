#!/usr/bin/env bash

##
## Optionally specify the backend as argument, e.g.
## ./radar2oai.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

JSONLD=data/10.22000-702.json 

if [ ! -f "$JSONLD" ] ; then
  echo "File not found"
  exit 1
fi

if ! jq type "$JSONLD" ; then
  EXITCODE=$?
  echo "jq found invalid JSON. Exit code $EXITCODE"
  exit $EXITCODE
fi

## Clean logs
rm -f error.log
touch error.log

# For array of records:
# jq --compact-output '.[]' $JSONLD | \

jq --compact-output '.' $JSONLD | \
while read -r i; do

IDENTIFIER=`echo "$i" | jq '."@id"'`
if [ -z $IDENTIFIER ] ; then
  echo "Empty IDENTIFIER:"
  echo "$i"
  exit 1
fi

TAGS='["DataSet", "RADAR4Chem-dataset"]'

# Change to: <json xmlns="http://nfdi4chem.de/schemas/json-container/1.0/">
(
cat <<EOF
<json xmlns="http://denbi.de/schemas/json-container">
<![CDATA[
EOF
echo "$i"
cat <<EOF
]]>
</json>
EOF
) | curl -v -H 'Content-Type: multipart/form-data' \
    -i \
    --fail-with-body \
    "$BACKEND/item"  \
    -F "item={\"identifier\":$IDENTIFIER,\"deleteFlag\":false,\"ingestFormat\":\"json_container\",\"tags\":$TAGS};type=application/json" \
    -F content=@- ;\
retval=$?
if [ $retval -ne 0 ] ; then
  echo -e "curl error $retval:\t$IDENTIFIER" >>error.log
fi

done # while read
