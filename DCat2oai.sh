#!/usr/bin/env bash

##
## Optionally specify the backend as argument, e.g.
## ./DCat2oai.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

DCATS=(DCat/*)

## Clean logs
rm -f error.log
touch error.log

for DCAT in "${DCATS[@]}" ; do
    echo Processing $DCAT

    if [ ! -f "$DCAT" ] ; then
		echo "File \"$DCAT\" not found"
		continue
    fi

	IDENTIFIER=$(basename "$DCAT")
	TAGS="\"\""

    curl -v -H 'Content-Type: multipart/form-data' \
		 -i \
		 --fail-with-body \
		 "$BACKEND/item"  \
		 -F "item={\"identifier\":\"$IDENTIFIER\",\"deleteFlag\":false,\"ingestFormat\":\"DCat\",\"tags\":\"[$TAGS]\"};type=application/json" \
		 -F content=@${DCAT} 
	retval=$?
	if [ $retval -ne 0 ] ; then
	    echo -e "curl error $retval:\t$IDENTIFIER" >>error.log
	fi

done # while DCATS
