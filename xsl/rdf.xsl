<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://purl.org/rss/1.0/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:admin="http://webns.net/mvcb/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt"
>

<xsl:strip-space elements="*"/>

<!-- Bring in all guide.xsl shebang to apply-templates to the news <body>,
     http://bugs.gentoo.org/204402
-->
<xsl:include href="/xsl/guide.xsl"/>

<xsl:output encoding="UTF-8" method="xml" indent="yes" cdata-section-elements="description" />


<xsl:template match="/rdffeed">

<rdf:RDF>
  <channel>
    <xsl:attribute name="rdf:about"><xsl:value-of select="link" /></xsl:attribute>
    <title><xsl:value-of select="title" /></title>
    <link><xsl:value-of select="link" /></link>
    <description><xsl:value-of select="description" /></description>
    <dc:creator>www@gentoo.org</dc:creator>
    <dc:language>en-US</dc:language>
    <admin:errorReportsTo rdf:resource="mailto:www@gentoo.org" />
    <items>
      <rdf:Seq>
        <xsl:for-each select="document('/dyn/news-index.xml')/uris/uri[position()&lt;11]/text()">
          <rdf:li>
            <xsl:attribute name="rdf:resource">http://www.gentoo.org<xsl:value-of select="." /></xsl:attribute>
          </rdf:li>
        </xsl:for-each>
      </rdf:Seq>
    </items>
  </channel>

  <xsl:for-each select="document('/dyn/news-index.xml')/uris/uri[position()&lt;11]/text()">
  <xsl:variable name="da-news" select="document(.)"/>
  <xsl:if test="$da-news/news/title">
    <item>
      <xsl:attribute name="rdf:about">http://www.gentoo.org<xsl:value-of select="." /></xsl:attribute>
      <title><xsl:value-of select="$da-news/news/title" /></title>
      <link>http://www.gentoo.org<xsl:value-of select="." /></link>
      <dc:subject><xsl:value-of select="$da-news/news/@category" /></dc:subject>
      <dc:creator><xsl:value-of select="$da-news/news/poster" /></dc:creator>
      <!-- <dc:date><xsl:value-of select="document(.)/news/date" /></dc:date> -->
      <xsl:variable name="xmlnews"><xsl:apply-templates select="$da-news/news/body"/></xsl:variable>
      <xsl:variable name="txtnews"><xsl:apply-templates select="exslt:node-set($xmlnews)" mode="txtnews"/></xsl:variable>
      <description>
       <xsl:value-of disable-output-escaping="yes" select="$txtnews"/>
      </description>
    </item>
  </xsl:if>
  </xsl:for-each>
</rdf:RDF>

</xsl:template>

<xsl:template match="node()" mode="txtnews">
  <xsl:choose>
   <xsl:when test="self::text()">
     <xsl:value-of disable-output-escaping="yes" select="."/>
   </xsl:when>
   <xsl:when test="self::*">
    <xsl:text disable-output-escaping="yes">&lt;</xsl:text><xsl:value-of select="name(.)"/>
    <xsl:apply-templates select="@*" mode="txtnews"/>
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    <xsl:apply-templates mode="txtnews"/>
    <xsl:text disable-output-escaping="yes">&lt;/</xsl:text><xsl:value-of select="name(.)"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
   </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="@class | @style" mode="txtnews"/>

<xsl:template match="@*" mode="txtnews">
  <xsl:value-of select="concat(' ', name(.))"/><xsl:text>=</xsl:text>
  <xsl:text>"</xsl:text>
  <xsl:choose>
    <xsl:when test="name(.)='href' and starts-with(., '/')"><xsl:value-of select="concat('http://www.gentoo.org', .)"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
  <xsl:text>"</xsl:text>
</xsl:template>

</xsl:stylesheet>
