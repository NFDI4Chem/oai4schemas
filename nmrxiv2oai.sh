#!/usr/bin/env bash

##
## Optionally specify the backend as argument, e.g.
## ./nmrxiv2oai.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

JSONLDS=data/nmrxiv-datacatalog.json data/nmrxiv-D506.json 

## Clean logs
rm -f error.log
touch error.log

for JSONLD in $JSONLDS ; do 
    echo Processing $JSONLD
    
    if [ ! -f "$JSONLD" ] ; then
	echo "File not found"
	continue
    fi

    if ! jq type "$JSONLD" ; then
	EXITCODE=$?
	echo "jq found invalid JSON. Exit code $EXITCODE"
	continue
    fi

    jq --compact-output '.' $JSONLD | \
	while read -r i; do

	    IDENTIFIER=`echo "$i" | jq '."@id"'`
	    if [ -z $IDENTIFIER ] ; then
		echo "Empty @id:"
		echo "$i"
		exit 1
	    fi

	    TYPE=`echo "$i" | jq '."@type"' | tr -d \"`
	    if [ -z $TYPE ] ; then
		echo "Empty @type:"
		echo "$i"
		exit 1
	    fi

	    TAGS="[\"nmrXiv\", \"$TYPE\", \"nmrXiv:$TYPE\"]"

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
	    ) | echo curl -v -H 'Content-Type: multipart/form-data' \
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
done # while JSONLDs

