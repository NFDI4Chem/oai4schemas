#!/bin/bash

BASEURL=https://www.chemotion-repository.net/api/v1/public/metadata/publications
LIMIT=500

MAXPARALLEL=25
MAXRECORDS=99999999
#MAXRECORDS=2000

# There are currently ~6000 Samples, ~25000 Containers and ~5000 Reactions
find ./json-ld -type f | xargs rm -f 
for OBJECTTYPE in Sample Container Reaction ; do 

  echo "Getting index for $OBJECTTYPE"
  OFFSET=0
  echo -n > all.$OBJECTTYPE.txt
  while [ $OFFSET -lt $MAXRECORDS ] && curl -s -X GET --header 'Accept: application/json' \
             "$BASEURL?type=$OBJECTTYPE&offset=$OFFSET&limit=$LIMIT" |\
		jq "if (.publications | length > 0) then .publications[] else halt_error end" >>all.$OBJECTTYPE.txt ; do 
    echo -n "$OFFSET " 
    OFFSET=$((OFFSET+LIMIT))
  done

  echo "Now Downloading all $OBJECTTYPE"

  ## Download the individual records
  cat all.$OBJECTTYPE.txt | tr -d \" |\
      parallel --joblog /tmp/parallel.log wget -q --content-on-error --directory-prefix=./json-ld  
  
done

## concatenate Download the individual records
echo '{ "@graph": [' >chemotion-datadump.json
i="0"
find ./json-ld -type f |\
    while read F ; do
	if [ "$i" == "1" ] ; then 
	    echo "," >>chemotion-datadump.json
	else
	    i="1"
	fi	
	cat "$F" | jq . >>chemotion-datadump.json || echo "Error in $F"
    done
echo "]}" >>chemotion-datadump.json
