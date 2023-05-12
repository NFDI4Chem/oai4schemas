#!/usr/bin/env bash

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

if ! [ `jq type "$JSONLD"` == '"object"' ] ; then
  EXITCODE=$?
  echo "jq found invalid JSON. Exit code $EXITCODE"
  exit $EXITCODE
fi

jq --compact-output '.' $JSONLD | \
while read -r i; do
    IDENTIFIER=`echo "$i" | jq '."@id"'`
    if [ -z $IDENTIFIER ] ; then
	echo "Empty IDENTIFIER:"
	echo "$i"
	exit 1
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
    )
     
done # while read
