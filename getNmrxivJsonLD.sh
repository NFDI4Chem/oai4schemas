#!/bin/bash

## No trailling slash please!

#BASEURL=https://dev.nmrxiv.org/api/v1
BASEURL=https://nmrxiv.org/api/v1
JSONDIRPREFIX=./nmrxiv-json-ld
LIMIT=500

MAXPARALLEL=12

if /bin/false ; then 
# There are currently ~XXX Projects, ~YYY Samples, and ~ZZZ Datasets
mkdir -p $JSONDIRPREFIX
find $JSONDIRPREFIX -type f | xargs rm -f 

for OBJECTTYPE in projects samples datasets ; do 
#for OBJECTTYPE in datasets  ; do 

    echo -n "Getting list of $OBJECTTYPE "
    echo -n > nmrxiv.$OBJECTTYPE.txt

    REQUEST="$BASEURL/list/$OBJECTTYPE"
    RESPONSE='{"links": {"next": "Dummy"}}'

    while [ "`echo $RESPONSE | jq .links.next`" != "null" ] ; do
	RESPONSE=`curl -s "$REQUEST"`
	echo -n "."
	RESPONSE=`curl -s "$REQUEST"`

	echo "$RESPONSE" |\
	    jq .data[].identifier |\
	    tr -d \" >>nmrxiv.$OBJECTTYPE.txt
	REQUEST=`echo "$RESPONSE" | jq .links.next | tr -d \"`
    done
    echo " Done."

  echo "Now Downloading all $OBJECTTYPE"

  ## Download the individual records
  cat nmrxiv.$OBJECTTYPE.txt | tr -d \" |\
      parallel --joblog /tmp/parallel.nmrxiv.log \
	       -j $MAXPARALLEL --bar \
	       wget -q --content-on-error --directory-prefix=$JSONDIRPREFIX "$BASEURL/schemas/bioschemas/{}"    
done
fi
## concatenate Download the individual records
DUMPFILE=nmrxiv-datadump-`date --iso-8601`.json
echo "Concatening and Compressing to $DUMPFILE.gz"

(
echo '{ "@graph": [' 
i="0"
find $JSONDIRPREFIX -type f |\
    while read F ; do
	if RESULT=`cat "$F" | jq .` ; then
	    if [ "$i" == "1" ] ; then 
		echo "," 
	    else
		i="1"
	    fi
	    echo "$RESULT"
	else
	    echo "Error in $F" >&2
	fi 	
    done
echo "]}"
) | gzip >$DUMPFILE.gz

