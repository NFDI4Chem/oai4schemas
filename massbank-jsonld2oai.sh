#!/usr/bin/env bash

## Usage:
## ./massbank-jsonld2oai.sh filename.json
## or 
## ./massbank-jsonld2oai.sh "https://github.com/MassBank/MassBank-data/releases/latest/download/MassBank.json"

export BACKEND=http://localhost:8081/oai-backend
export BACKEND=http://10.22.13.12:6081/oai-backend

if [ $# -eq 0 ]
  then
    echo "Filename argument required"
    exit 1
fi

## File or URL
JSONLD="$1"

## No checks for online sources
if /bin/false ; then 
if [ ! -f "$JSONLD" ] ; then
  echo "File not found"
  exit 1
fi

if ! jq type "$JSONLD" ; then
  EXITCODE=$?
  echo "jq found invalid JSON. Exit code $EXITCODE"
  exit $EXITCODE
fi

fi

## Clean logs
rm -f error.log
touch error.log

# Local file:
# jq --compact-output '.[]' $JSONLD | \
wget -q -O- "$JSONLD" | \
jq --compact-output '.[]' | \
while read -r i; do

IDENTIFIER=`echo "$i" | jq '."@id"'`
if [ -z $IDENTIFIER ] ; then
  echo "Empty IDENTIFIER:"
  echo "$i"
  exit 1
fi

if (echo $IDENTIFIER | grep "\#") ; then
  TAGS='["MassBank", "ChemicalSubstance", "MassBank:ChemicalSubstance"]'
else
  TAGS='["MassBank", "Dataset", "MassBank:Dataset"]'
fi

(
cat <<EOF
<json xmlns="http://nfdi4chem.de/schemas/json-container/1.0/">
<![CDATA[
EOF
echo "$i"
cat <<EOF
]]>
</json>
EOF
) | curl -v -H 'Content-Type: multipart/form-data' \
    -i \
    "$BACKEND/item"  \
    -F "item={\"identifier\":$IDENTIFIER,\"deleteFlag\":false,\"ingestFormat\":\"json_container\",\"tags\":$TAGS};type=application/json" \
    -F content=@- ;\
retval=$?
if [ $retval -ne 0 ] ; then
  echo -e "curl error $retval:\t$IDENTIFIER" >>error.log
fi

## not everywhere supported:    --fail-with-body \

done # while read
