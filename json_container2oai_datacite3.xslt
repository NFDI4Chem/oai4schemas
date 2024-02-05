<?xml version="1.0"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:json="http://nfdi4chem.de/schemas/json-container/1.0/"
    exclude-result-prefixes="xs math" version="3.0">

    <xsl:output indent="yes" omit-xml-declaration="yes" />
    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:template match="json:json">

      <!-- read json from XML -->
      <xsl:variable name="data" as="map(*)"  select="parse-json(.)"/>
      <xsl:variable name="idfield" select="'@id'"/>

      <!-- <xsl:variable name="id" select="array { $data?id }"/> -->
      <xsl:variable name="id" select="map:get($data, '@id')" />
      <xsl:variable name="name" select="array { $data?name }"/>

      <resource xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd" xmlns="http://datacite.org/schema/kernel-3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">  
	<identifier identifierType="DOI">
	  <xsl:value-of select="$id"/>
	</identifier>
  <titles>
    <title>
      <xsl:value-of select="$name"/>
    </title>
  </titles>
  <creators>
    <creator>
      <creatorName>Dummy Creator</creatorName>
    </creator>
  </creators>
  <publisher>Dummy Publisher</publisher>
  <publicationYear>9999</publicationYear>
  <subjects>
    <subject>Chemistry</subject>
  </subjects>
  <dates>
    <date dateType="Dummy">9999-12-31</date>
  </dates>  

</resource>

  </xsl:template>

  </xsl:stylesheet>
