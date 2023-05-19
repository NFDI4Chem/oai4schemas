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

    <oai_dc:dc xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ https://www.openarchives.org/OAI/2.0/oai_dc.xsd http://purl.org/dc/elements/1.1/ https://www.radar-service.eu/schemas/dc.xsd">
      <dc:identifier>
        <xsl:value-of select="$id"/>
      </dc:identifier>
      <dc:title>
        <xsl:value-of select="$name"/>
      </dc:title>
    </oai_dc:dc>

  </xsl:template>

  </xsl:stylesheet>
