#! /bin/bash
##
## Optionally specify the backend as argument, e.g.
## ./createSets.sh http://10.22.13.12:6081/oai-backend
##

BACKEND="${1:-http://localhost:8081/oai-backend}"

## STN: I used plural for the set name and description
## and singular for the tags
## The first tag is the Bioschemas profile,
## and the second a custom combination of MassBank and content

# Create Sets for MassBank
curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MassBank-spectra", "spec": "MassBank:DataSet", "description": "MassBank spectra", "tags": ["DataSet", "MassBank-spectrum"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MassBank-molecules", "spec": "MassBank:MolecularEntity", "description": "MassBank molecules", "tags": ["MolecularEntity", "MassBank-molecule"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "nmrXiv-datasets", "spec": "nmrXiv:DataSet", "description": "nmrXiv datasets", "tags": ["DataSet", "mrXiv-dataset"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "RADAR4Chem-datasets", "spec": "RADAR4Chem:DataSet", "description": "RADAR4Chem datasets", "tags": ["DataSet", "RADAR4Chem-dataset"]}'

