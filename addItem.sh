#!/bin/bash

##
## Optionally specify the backend as argument, e.g.
## ./addItems.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

# The example data is a Chemotion Molecule
# with DOI 10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1
# downloaded from the Chemotion REST API
# at https://www.chemotion-repository.net/api/v1/public/molecule.json?id=6338
# and converted/crosswalked to Bioschemas JSON+LD
# using https://gist.github.com/sneumann/072adeb302ca010e2eb5de24e3bdb413

# Create Item for 10.14272-MIIFHRBUBUHJMC-UHFFFAOYSA-N.1.xml

curl -v -X POST -H 'Content-Type: multipart/form-data' \
  -i "$BACKEND/item"  \
  -F "item={\"identifier\":\"10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1\",\"deleteFlag\":false,\"ingestFormat\":\"json_container\"};type=application/json" \
  -F content=@./10.14272-MIIFHRBUBUHJMC-UHFFFAOYSA-N.1.xml
