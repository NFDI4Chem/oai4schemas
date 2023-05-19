# oai4schemas

This repo contains a XML schema that can embed JSON+LD (bio)schema metadata, crosswalks and examples. They are designed to work with https://radar.products.fiz-karlsruhe.de/en/radarfeatures/radar-oai-provider.

## Creating the format

Neither OAI-PMH nor the FIZ OAI-PMH provider are (currently) designed
to import and serve JSON+LD schema.org metadata. As workaround, we
use a super-simple XML schema (`metadataPrefix` in OAI language)
with the sole purpose to hold JSON content.

The format is created via the REST interface of the FIZ OAI-PMH backend
by calling
```
createFormats.sh [URLofBackend]
```
If no URL is provided, `http://localhost:8081/oai-backend` is assumed.

## Creating the crosswalk

The FIZ OAI-PMH provider allows to specify crosswalks between metadata formats
as XSLT that also has to be created with the backend:
```
createCrosswalks.sh [URLofBackend]
```
Currently, there is only a super simple crosswalk creating (broken) `oai_dc` metadata.
See https://github.com/NFDI4Chem/oai4schemas/issues/1 for more information.

## Create sets holding subset of records
Using the sets you can tag uploaded records, and query by sets
```
./createSets.sh [URLofBackend]
```

# Adding data

An individual example is part of this repository, and there are examples
how to import data from the Chemotion repository and the MassBank spectral database.

## Adding example record(s)

The example data is a Chemotion Molecule
with DOI 10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1
downloaded from the Chemotion REST API
at https://www.chemotion-repository.net/api/v1/public/molecule.json?id=6338
and converted/crosswalked to Bioschemas JSON+LD
using https://gist.github.com/sneumann/072adeb302ca010e2eb5de24e3bdb413
```
./addItems.sh [URLofBackend]
```

## Importing MassBank data dumps

The script `massbank-jsonld2oai.sh` can import a MassBank data dump to OAI.

## Chemotion repository

Code snippet to import Chemotion metadata to OAI:
https://gist.github.com/sneumann/6c814c5357bb35a948cd8e3c8b57fca1
(Caveat! This crosswalk is known to be slightly incorrect!)

## nmrXiv

tbd.

## Radar4Chem

The RADAR repository serves schema.org markup as RDFa embedded in the web pages.
To import the metadata into the OAI backend, we need it converted to JSON+LD,
e.g. using the Online converter at https://issemantic.net/rdf-converter
Two examples () are included here as demo data.

# Retrieving the data and using it

Retrieval works just like all other OAI-PMH services.

## Extracting the JSON content

We have an IPB NFDI4Chem OAI test instance with some example data:
https://msbi.ipb-halle.de/oai/OAIHandler?verb=GetRecord&metadataPrefix=json_container&identifier=10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1


The following is a snippet to retrieve the example with `curl`,
and extract the actual JSON with `xmllint`using an xpath expression.
Note that the `local-name()="json"` trick is required to ignore
the XML namespace of the `<json>` element. Similarly, `sed` is used to strip off the `CDATA` in the XML (any suggestion of
a more elegant solution welcome! Doesn't have to use `xmllint`, but needs
to fit the commandline).
The optional `jq` is a nice way to pretty-print JSON, see https://blog.lazy-evaluation.net/posts/linux/jq-xq-yq.html
and https://stedolan.github.io/jq/
```
OAIURL=https://msbi.ipb-halle.de/oai/OAIHandler
curl -s "$OAIURL?verb=GetRecord&metadataPrefix=json_container&identifier=10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1" |\
  xmllint --xpath '//*[local-name()="json"]/text()' - |\
  sed -e 's/<!\[CDATA\[//g; s/\]\]>//g' |\
  jq
```
In case our IPB NFDI4Chem OAI test instance disappears,
the example response of the above `curl` is available
in this repo for reference (https://github.com/NFDI4Chem/oai4schemas/blob/main/10.14272-MIIFHRBUBUHJMC-UHFFFAOYSA-N.1.xml)

## Validating the oai_dc conversion

Since the `<oai_dc:dc>` version of the metadata is embedded in the `<OAI-PMH>` response,
for the validation and use it needs to be extracted and piped into the validation
or some other consumer:

```
xmllint --xpath '//*[namespace-uri()="http://www.openarchives.org/OAI/2.0/oai_dc/" and local-name()="dc"]' \
  examples/oai_dc-MIIFHRBUBUHJMC-UHFFFAOYSA-N.1.xml  |\
  xmllint --schema oai_dc.xsd -
```

## More OAI call examples:

- Get (a small part of) the above example record in `oai_dc` metadata format: https://msbi.ipb-halle.de/oai/OAIHandler?verb=GetRecord&metadataPrefix=oai_dc&identifier=10.14272/MIIFHRBUBUHJMC-UHFFFAOYSA-N.1
- List all schemas records: https://msbi.ipb-halle.de/oai/OAIHandler?verb=ListIdentifiers&metadataPrefix=json_container
- List the set of all MassBank molecules: https://msbi.ipb-halle.de/oai/OAIHandler?verb=ListIdentifiers&metadataPrefix=json_container&set=MassBank:MolecularEntity
