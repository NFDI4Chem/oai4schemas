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
  --data '{"metadataPrefix":"json_container","schemaLocation":"https://nfdi4chem.de/schemas/json-container/json-container.xsd","schemaNamespace":"http://nfdi4chem.de/schemas/json-container/1.0/","identifierXpath":""}'

# Read all formats
curl -X GET "$BACKEND/format"

# Delete a specific crosswalk
# curl -v -X DELETE http://localhost:8081/oai-backend/format/json_container
