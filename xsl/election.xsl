<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                extension-element-prefixes="func">

<xsl:output encoding="UTF-8"
            method="xml"
            indent="yes"
            doctype-system="/dtd/guide.dtd"/>

<xsl:include href="util.xsl"/>
<xsl:include href="inserts.xsl"/>

<xsl:template match="/election">
<mainpage>
  <title><xsl:value-of select="title"/></title>

  <xsl:choose>
    <xsl:when test="author">
      <xsl:apply-templates select="author"/>
    </xsl:when>
    <xsl:otherwise>
      <author title="script generated">Gentoo Project</author>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="abstract">
    <abstract><xsl:value-of select="abstract"/></abstract>
  </xsl:if>

  <xsl:if test="version">
    <version><xsl:value-of select="version"/></version>
  </xsl:if>

  <date><xsl:value-of select="date"/></date>

  <chapter>
    <title><xsl:apply-templates select="title"/></title>

    <xsl:apply-templates select="nominations"/>

</chapter>
</mainpage>
</xsl:template>

<!-- Nominations data -->
<xsl:template match="nominations">
  <section>
  <title>Nominations status</title>
  <body>

  <note>
  Nominations are allowed from <xsl:value-of
  select="func:format-date(@from,'en')"/> 00:00 UTC to <xsl:value-of
  select="func:format-date(@to,'en')"/> 23:59 UTC via the gentoo-dev mailling
  list.
  </note>

  <table>
    <tr><th>Accepted</th><th>Developer</th><th>Nickname</th><th>Devrel</th><th>Council</th><th>Trustee</th></tr>
    <xsl:apply-templates select="nominee"/>
  </table>

  </body>
  </section>
</xsl:template>

<!-- Nominee row -->
<xsl:template match="nominee">

  <xsl:variable name="fullname">
    <xsl:call-template name="fullname">
      <xsl:with-param name="nick" select="."></xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <tr>
    <ti>
      <xsl:apply-templates select="@accepted"/>
    </ti>
    <ti>
      <xsl:choose>
       <xsl:when test="@platform">
         <uri link="{@platform}"><xsl:value-of select="$fullname"/></uri>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="$fullname"/>
       </xsl:otherwise>
      </xsl:choose>
    </ti>
    <ti>
      <xsl:value-of select='translate(.,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")'/>
    </ti>
    <ti>
      <xsl:apply-templates select="@devrel"/>
    </ti>
    <ti>
      <xsl:apply-templates select="@council"/>
    </ti>
    <ti>
      <xsl:apply-templates select="@trustee"/>
    </ti>
  </tr>
</xsl:template>

<!-- Identity transform -->
<xsl:template match="author|mail//@*|mail//node()|author//node()|author//@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<!-- Capitalize -->
 <!-- List attributes explicitely in match="" if you add non yes/no attributes-->
<xsl:template match="nominee/@*"> 
  <xsl:value-of select='concat(translate(substring(.,1,1),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),translate(substring(.,2),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz"))'/>
</xsl:template>

</xsl:stylesheet>
