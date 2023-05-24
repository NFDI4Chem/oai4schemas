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

##
## Create Sets for schema.org types
##
curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "Datacatalogs", "spec": "DataCatalog", "description": "All items of schema.org type DataCatalog, usually describing repositories", "tags": ["DataCatalog"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "Projects", "spec": "Project", "description": "All items of schema.org type Project, usually containing a number of studies", "tags": ["Project"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "Studies", "spec": "Study", "description": "All items of schema.org type Study, usually containing a number of Datasets", "tags": ["Study"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "Datasets", "spec": "Dataset", "description": "All items of schema.org type Dataset, describing e.g. simulated or measured chemical data", "tags": ["Dataset"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MolecularEntities", "spec": "MolecularEntity", "description": "All items of schema.org type MolecularEntity, describing the notion and often structure of a molecule", "tags": ["MolecularEntity"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "ChemicalSubstances", "spec": "ChemicalSubstance", "description": "All items of schema.org type ChemicalSubstance, describing a specific aliquot or sample of a chemical substance", "tags": ["ChemicalSubstance"]}'

##
## Create Sets for MassBank
##
curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MassBank items", "spec": "MassBank", "description": "All items in MassBank", "tags": ["MassBank"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MassBank Molecules", "spec": "MassBank:MolecularEntity", "description": "All molecules known in MassBank", "tags": ["MassBank:MolecularEntity"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "MassBank Spectra", "spec": "MassBank:Dataset", "description": "All MassBank Spectra", "tags": ["MassBank:Dataset"]}'

##
## Create Sets for RADAR4Chem
##

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "RADAR4Chem items", "spec": "RADAR4Chem", "description": "All items in RADAR4Chem", "tags": ["RADAR4Chem"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "RADAR4Chem Datasets", "spec": "RADAR4Chem:Dataset", "description": "All RADAR4Chem Spectra", "tags": ["RADAR4Chem:Dataset"]}'

##
## Create Sets for nmrXiv
##

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "nmrXiv items", "spec": "nmrXiv", "description": "All items in nmrXiv", "tags": ["nmrXiv"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "nmrXiv Molecules", "spec": "nmrXiv:MolecularEntity", "description": "All molecules known in MassBank", "tags": ["nmrXiv:MolecularEntity"]}'

curl -X POST -H 'Content-Type: application/json' \
  -i "$BACKEND/set" \
  --data '{"name": "nmrXiv Spectra", "spec": "nmrXiv:Dataset", "description": "All nmrXiv Spectra", "tags": ["nmrXiv:Dataset"]}'


