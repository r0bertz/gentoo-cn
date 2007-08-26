<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns="http://purl.org/rss/1.0/">

  <xsl:output
    encoding="UTF-8"
    method="xml"
    indent="yes"/>

  <xsl:param name='num' select='"all"'/>

  <xsl:template match="/glsaindex-rdf">
    <xsl:variable name="src" select="'/dyn/glsa-index.xml'"/>
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns="http://purl.org/rss/1.0/">

<channel rdf:about="http://www.gentoo.org/security/en/index.xml">
  <title>Gentoo Linux Security Advisories</title>
  <link>http://www.gentoo.org/security/en/glsa/index.xml</link>
  <description>
    This index is automatically generated from XML source. Please contact the
    Gentoo Linux Security Team (security@gentoo.org) for related inquiries.
  </description>
  <items>
    <rdf:Seq>
    <xsl:for-each select="document($src)/guide/chapter[1]/section[1]/body/table[1]/tr[position()&gt;1]">
      <!-- num parameter can be used to limit the number of GLSAs,
           it must be all digits and >=1, otherwise, spit all GLSAs -->
      <xsl:if test="not(string-length(translate($num,'0123456789',''))=0 and position()&gt;number($num)) or position()=1">
        <rdf:li>
          <xsl:attribute name="rdf:resource"><xsl:value-of select="ti[1]/uri/@link"/></xsl:attribute>
        </rdf:li>
      </xsl:if>
    </xsl:for-each>
    </rdf:Seq>
  </items>
</channel>

<xsl:for-each select="document($src)/guide/chapter[1]/section[1]/body/table[1]/tr[position()&gt;1]">
  <xsl:if test="not(string-length(translate($num,'0123456789',''))=0 and position()&gt;number($num)) or position()=1">
    <item>
      <xsl:variable name="glsaid" select="normalize-space(ti[1]/uri/text())"/>
      <xsl:variable name="glsalink" select="string(ti[1]/uri/@link)"/>
      <xsl:variable name="glsasev" select="normalize-space(ti[2]/text())"/>
      <xsl:variable name="glsapkg" select="normalize-space(ti[3]/text())"/>
      <xsl:variable name="glsadesc" select="normalize-space(ti[4]/text())"/>
      <xsl:attribute name="rdf:about"><xsl:value-of select="$glsalink"/></xsl:attribute>
      <title>
        <xsl:choose>
          <xsl:when test="$glsapkg='kernel'">
            <xsl:value-of select="concat('GLSA ', $glsaid, ' (', $glsasev, '): ', $glsapkg)"/>
          </xsl:when>
          <xsl:when test="$glsapkg!=''">
            <xsl:value-of select="concat('GLSA ', $glsaid, ' (', $glsasev, '): ', substring-after($glsapkg, '/'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('GLSA ', $glsaid, ' (', $glsasev, ')')"/>
          </xsl:otherwise>
        </xsl:choose>
      </title>
      <link>
        <xsl:value-of select="$glsalink"/>
      </link>
      <description>
        <xsl:value-of select="$glsadesc"/>
      </description>
    </item>
  </xsl:if>
</xsl:for-each>

</rdf:RDF>
</xsl:template>

</xsl:stylesheet>
