<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="UTF-8" method="xml" indent="yes" doctype-system="/dtd/guide.dtd"/>

<xsl:template match="/useflags">
<guide link="" lang="en">
<author>
  <mail link="neysx@gentoo.org">Xavier Neys</mail>
</author>

<abstract>Global and local USE flags used by Gentoo</abstract>

<title>Gentoo Linux Use Variable Descriptions</title>
<version>2</version>
<date><xsl:value-of select="date"/></date>

<xsl:apply-templates/>
</guide>
</xsl:template>

<xsl:template match="global">
<chapter id="global">
<title>Global Use Flags</title>
<section><body><table>
<tcolumn width="180"/>
<tr><th>Flag</th><th>Description</th></tr>
  <xsl:apply-templates select="flag"/>
</table></body></section>
</chapter>
</xsl:template>

<xsl:template match="local">
<chapter id="local">
<title>Local Use Flags</title>
<section id="categories">
<title>Categories</title>
<body>
<table>
<xsl:for-each select="category">
  <xsl:if test="position() mod 6 = 1">
    <xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
  </xsl:if>
  <ti><uri link="{concat('#', @name)}"><xsl:value-of select="@name"/></uri></ti>
  <xsl:if test="position() mod 6 = 0 and not (position()=last())">
    <xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
  </xsl:if>
</xsl:for-each>
<!-- Complete last row with empty <ti>s -->
<xsl:if test="count(category) mod 6 > 0">
  <xsl:call-template name="ti-filler">
    <xsl:with-param name="count" select="6 - count(category) mod 6"/>
  </xsl:call-template>
</xsl:if>
<!-- Close last row -->
<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
</table>
</body>
</section>
  <xsl:apply-templates select="category"/>
</chapter>
</xsl:template>

<xsl:template name="ti-filler">
  <xsl:param name="count"/>
  <ti/>
  <xsl:if test="$count > 1">
    <xsl:call-template name="ti-filler">
      <xsl:with-param name="count" select="$count - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="category">
<section id="{@name}">
<title><xsl:value-of select="@name"/></title>
<body>
<table>
<tcolumn width="180"/>
<tcolumn width="160"/>
<tr><th>Package</th><th>Flag</th><th>Description</th></tr>
  <xsl:apply-templates select="package"/>
</table>
</body></section>
</xsl:template>

<xsl:template match="package">
  <xsl:apply-templates select="flag"/>
</xsl:template>

<xsl:template match="flag">
<tr>
  <xsl:if test="name(..)='package'">
      <xsl:if test="position() = 1">
    <ti>
        <xsl:attribute name="rowspan"><xsl:value-of select="count(../flag)"/></xsl:attribute>
        <c><b><xsl:value-of select="../@name"/></b></c>
    </ti>
      </xsl:if>
  </xsl:if>
  <ti><b><xsl:value-of select="@name"/></b></ti>
  <ti><xsl:value-of select="."/></ti>
</tr>
</xsl:template>

</xsl:stylesheet>
