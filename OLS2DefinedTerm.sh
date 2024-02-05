#!/bin/bash

chmo2definedterm () {
  CURIE=`echo "$1" | sed -e 's/.*\(CHMO:[0-9]*\).*/\1/'`
  wget -q -O- "https://service.tib.eu/ts4tib/api/ontologies/chmo/terms?obo_id=$CURIE" |\
  jq '{ measurementTechnique: { "@type": "DefinedTerm", "@id": ._embedded.terms[0].iri, "termCode": ._embedded.terms[0].obo_id, "name": ._embedded.terms[0].label, "url": ("https://terminology.nfdi4chem.de/ts/ontologies/"+._embedded.terms[0].ontology_name+"/terms?iri="+._embedded.terms[0].iri), "inDefinedTermSet": { "@type": "DefinedTermSet", "@id": ._embedded.terms[0].ontology_iri, "name": ._embedded.terms[0].ontology_name, } } }' |\
    grep -v '^[{}]$'
  echo ","
}


zcat /tmp/chemotion-datadump-20231206.json.gz |\
while read LINE ; do 
  echo "$LINE"
  if ( echo "$LINE" | grep -q 'CHMO:[0-9]* ' ) ; then 
    chmo2definedterm "$LINE"
  fi  
done

  