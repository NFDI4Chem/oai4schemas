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

jq -c '.[]' $JSONLD | \
while read i; do

IDENTIFIER=`echo "$i" | jq '.identifier'`

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
  -i "$BACKEND/item"  \
  -F "item={\"identifier\":$IDENTIFIER,\"deleteFlag\":false,\"ingestFormat\":\"json_container\"};type=application/json" \
  -F content=@- ;\

done # while read
