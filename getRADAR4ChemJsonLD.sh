#!/bin/bash

set +x

OAIPMHBASE="https://www.radar-service.eu/oai/OAIHandler"
DOIBASE="https://doi.org"
JSONDIRPREFIX=./10.22000

## Get list of all RADAR4Chem records:

wget -q -O- "$OAIPMHBASE?verb=ListRecords&metadataPrefix=oai_dc&set=radar4chem" |\
    grep '<identifier>' |\
    cut -d '>' -f 4 | cut -d '<' -f 1 \
    > all.RADR4Chem-dois.txt

# Extract all <script type=”application/ld+json”> from HTML pages
for DOI in `cat all.RADR4Chem-dois.txt` ; do 
    echo $DOI
    wget -q -O- "$DOIBASE/$DOI" |\
    xmllint --html --nowarning \
            --xpath '/html//*/script[@type="application/ld+json"]/text()' - \
      2>/dev/null |\
    sed -e 's/<!\[CDATA\[//g; s/\]\]>//g' \
    >"./$DOI.json"
done

## concatenate the individual records
DUMPFILE=RADAR4Chem-datadump-`date --iso-8601`.json
echo "Concatening and Compressing to $DUMPFILE.gz"

(
echo '{ "@graph": [' 
i="0"
find $JSONDIRPREFIX -type f |\
    while read F ; do
	if RESULT=`cat "$F" | grep -v '^\[$' | grep -v '^\]$' | jq '.["@graph"]' ` ; then
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

   
