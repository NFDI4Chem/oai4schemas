#!/bin/bash

##
## Optionally specify the backend as argument, e.g.
## ./createFormats.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

##
## Create Format
##

curl -X POST -H 'Content-Type: application/json' -i "$BACKEND/format" \
  --data '{"metadataPrefix":"json_container","schemaLocation":"http://denbi.de/schemas/json-container.xsd","schemaNamespace":"http://denbi.de/schemas/json-container","identifierXpath":""}'

# Read all formats
curl -X GET "$BACKEND/format"

# Delete a specific crosswalk
# curl -v -X DELETE http://localhost:8081/oai-backend/format/json_container
