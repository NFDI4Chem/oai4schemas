# oai4chem
This repo contains a XML schema that can embed JSON+LD (bio)schema metadata, crosswalks and examples. They are designed to work with https://radar.products.fiz-karlsruhe.de/en/radarfeatures/radar-oai-provider.

# Creating the format
Neither OAI-PMH nor the FIZ OAI-PMH provider is (currently) designed
to import and serve JSON+LD schema.org metadata. As workaround, we can create
use super-simple XML schema with the sole purpose to hold JSON content.

The format is created (and deleted) via the REST interface of the FIZ OAI-PMH backend
by calling

```
createFormats.sh [URLofBackend]
```
If no URL is provided, `http://localhost:8081/oai-backend` is assumed.

# Creating the crosswalk

The FIZ OAI-PMH provider allows to specify crosswalks between metadata formats
as XSLT that also has to be created with the backend:

```
createCrosswalks.sh [URLofBackend]
```

# Adding example record(s)

The example data is a Chemotion Molecule
with DOI 10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1
downloaded from the Chemotion REST API
at https://www.chemotion-repository.net/api/v1/public/molecule.json?id=6338
and converted/crosswalked to Bioschemas JSON+LD
using https://gist.github.com/sneumann/072adeb302ca010e2eb5de24e3bdb413

```
./addItems.sh [URLofBackend]
```

# Retrieving the data and using it

tbd.
