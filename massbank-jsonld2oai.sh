#!/usr/bin/env bash

export BACKEND=http://localhost:8081/oai-backend

if [ $# -eq 0 ]
  then
    echo "Filename argument required"
    exit 1
fi

JSONLD="$1"

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
rm error.log
touch error.log

jq --compact-output '.[]' $JSONLD | \
while read -r i; do

#IDENTIFIER=`echo "$i" | jq '.identifier'`
IDENTIFIER=`echo "$i" | jq '."@id"'`
if [ -z $IDENTIFIER ] ; then
  echo "Empty IDENTIFIER:"
  echo "$i"
  exit 1
fi

if (echo $IDENTIFIER | grep "\#") ; then
  TAGS='["MolecularEntity", "MassBank-molecule"]'
else
  TAGS='["DataSet", "MassBank-spectrum"]'
fi

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
