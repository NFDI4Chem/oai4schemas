#!/usr/bin/env bash

## Usage:
## ./chemotion-jsonld2oai.sh filename.json
## ./chemotion-jsonld2oai.sh ~/tmp/chemotion-dump/chemotion-datadump-2023-12-13.jsonld.gz
## or 
## ./chemotion-jsonld2oai.sh "https://github.com/elixir-europe/biohackathon-projects-2023/raw/main/7/dumps/chemotion-datadump-2023-12-13.jsonld.gz"

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

#wget -q -O- "$JSONLD" |\
#  zcat | \
#  jq --compact-output '.[]' | \

# Local file:
zcat $JSONLD | jq --compact-output '.["@graph"][]' |\
  while read -r i; do

IDENTIFIER=`echo "$i" | jq '."@id"'`
if [ -z $IDENTIFIER ] ; then
  echo "Empty @id:"
  echo "$i"
  exit 1
fi

TYPE=`echo "$i" | jq '."@type"'`
if [ -z $TYPE ] ; then
  echo "Empty @type:"
  echo "$i"
  exit 1
fi

if [ "$TYPE" = "Study" ] ; then 
  TAGS='["Chemotion", "Chemotion:Study", "Study"]'
elif [ "$TYPE" = "Dataset" ] ; then
  TAGS='["Chemotion", "Chemotion:Dataset", "Dataset"]'
fi

## TODO: Depending on @type and/or for Reaction a regex on @id
## TAGS='["Chemotion", "Chemotion:Reaction", "Reaction"]'
## TAGS='["Chemotion", "Chemotion:ChemicalSubstance", "ChemicalSubstance"]'

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

done # while read
